"""Tokenizer for the Bend surface syntax.

The gate exists to catch what a *checker* cannot, which means it must not be
fooled by text that merely looks like a construct. A regex over the source
would read ``"@unsafe"`` inside a string, or ``# law`` inside a comment, as the
real thing; a tokenizer cannot. So the scan is token-based, and this module is
a faithful port of the scanners in ``bend.ts``:

  parse_skip      -- whitespace and ``#`` comments      (bend.ts:1523)
  char_is_head    -- what may start a name              (bend.ts:484)
  char_is_name    -- what may continue a name           (bend.ts:489)
  parse_lexeme    -- a name, dots included              (bend.ts:1564)
  parse_char      -- one character, escapes included    (bend.ts:1588)
  NUMBER          -- a numeric literal                  (bend.ts:2208)

Ported rather than imported because the gate must run before, and independently
of, the checker, and because a pinned copy can be diffed against a new release
(``tools/migrate.py``). ``VERSION`` records which release this port tracks; the
gate refuses to run against a tree it was not ported for.
"""

from __future__ import annotations

import re
from dataclasses import dataclass

VERSION = "2.0.5"

# bend.ts:1477. Note that these are compared against a *whole* lexeme, never a
# prefix: ``Word.law`` is one name (dots are name characters) and is not the
# keyword ``law``.
KEYWORDS = frozenset({
    "def", "type", "law", "match", "case", "do", "return",
    "for", "exs", "where", "is", "import",
    "Type", "Data", "Kind", "Quant",
})

# bend.ts:2208, made sticky so it anchors at the scan position.
NUMBER = re.compile(r"(\d+)(n|\.\d+([eE][+-]?\d+)?)?")

# bend.ts:1202
ESCAPES = frozenset("ntr0\\'\"")

_NAME_HEAD = re.compile(r"[A-Za-z_]")
_NAME_CHAR = re.compile(r"[A-Za-z0-9_.]")

KIND_NAME = "name"
KIND_NUMBER = "number"
KIND_STRING = "string"
KIND_CHAR = "char"
KIND_HOLE = "hole"
KIND_AT = "at"
KIND_OP = "op"

UNTERMINATED = "unterminated"


@dataclass(frozen=True)
class Token:
    kind: str
    text: str
    line: int      # 1-based
    col: int       # 1-based
    start: int
    end: int

    @property
    def is_keyword(self) -> bool:
        return self.kind == KIND_NAME and self.text in KEYWORDS

    def __str__(self) -> str:
        return f"{self.kind}({self.text!r}) at {self.line}:{self.col}"


class LexError(Exception):
    """A tokenization that failed the way bend.ts would have failed it."""

    def __init__(self, message: str, line: int, col: int):
        super().__init__(f"{message} at {line}:{col}")
        self.message = message
        self.line = line
        self.col = col


def _line_col(src: str, pos: int) -> tuple[int, int]:
    # parse_col (bend.ts:1485) counts from the last newline; both are 1-based.
    line = src.count("\n", 0, pos) + 1
    col = pos - src.rfind("\n", 0, pos)
    return line, col


def _skip(src: str, pos: int) -> int:
    """parse_skip: whitespace, and ``#`` to end of line."""
    n = len(src)
    while pos < n:
        c = src[pos]
        if c in " \n\r\t":
            pos += 1
            continue
        if c == "#":
            nl = src.find("\n", pos)
            pos = n if nl < 0 else nl
            continue
        break
    return pos


def _scan_name(src: str, pos: int) -> tuple[str, int]:
    start = pos
    while pos < len(src) and _NAME_CHAR.match(src[pos]):
        pos += 1
    return src[start:pos], pos


def _scan_quoted(src: str, pos: int, quote: str) -> tuple[str, int]:
    """Consume a ``"..."`` string or ``'...'`` character, escapes intact."""
    start = pos
    pos += 1
    while pos < len(src):
        c = src[pos]
        if c == "\\":
            # \\u{1F600} is variable width; every other escape is two chars.
            m = re.compile(r"\\u\{[0-9a-fA-F]+\}").match(src, pos)
            pos += m.end() - pos if m else 2
            continue
        pos += 1
        if c == quote:
            return src[start:pos], pos
    raise LexError(UNTERMINATED, *_line_col(src, start))


def tokenize(src: str) -> list[Token]:
    """Scan ``src`` into tokens. Raises LexError on an unterminated literal."""
    tokens: list[Token] = []
    pos = 0
    n = len(src)
    while True:
        pos = _skip(src, pos)
        if pos >= n:
            return tokens
        line, col = _line_col(src, pos)
        c = src[pos]
        start = pos
        if _NAME_HEAD.match(c):
            text, pos = _scan_name(src, pos)
            if text.endswith("."):
                raise LexError("a name cannot end in '.'", line, col)
            tokens.append(Token(KIND_NAME, text, line, col, start, pos))
            continue
        if c.isdigit():
            m = NUMBER.match(src, pos)
            assert m is not None  # the first char is a digit
            pos = m.end()
            tokens.append(Token(KIND_NUMBER, m.group(0), line, col, start, pos))
            continue
        if c in "\"'":
            text, pos = _scan_quoted(src, pos, c)
            kind = KIND_STRING if c == '"' else KIND_CHAR
            tokens.append(Token(kind, text, line, col, start, pos))
            continue
        if c == "?":
            pos += 1
            if pos < n and _NAME_HEAD.match(src[pos]):
                text, pos = _scan_name(src, pos)
                if text.endswith("."):
                    raise LexError("a name cannot end in '.'", line, col)
                tokens.append(Token(KIND_HOLE, "?" + text, line, col, start, pos))
                continue
            tokens.append(Token(KIND_OP, "?", line, col, start, pos))
            continue
        if c == "@":
            pos += 1
            tokens.append(Token(KIND_AT, "@", line, col, start, pos))
            continue
        pos += 1
        tokens.append(Token(KIND_OP, c, line, col, start, pos))


def blank_multiline_literals(src: str) -> str:
    """Blank the interiors of literals that span lines, preserving offsets.

    A single-line literal cannot begin a line, so a decision anchored at the
    line head is unaffected by its content -- and ``import "x.c"`` has to stay
    readable, because that is how a def-level foreign import is spelled. A
    literal that spans lines can begin one, and is the only way literal content
    reaches a line-head scan; measured against 2.0.5 the checker accepts such
    literals (``"a`` newline ``b"`` prints as ``a\nb``).
    """
    out = list(src)
    for token in tokenize(src):
        if token.kind not in (KIND_STRING, KIND_CHAR):
            continue
        if "\n" not in src[token.start:token.end]:
            continue
        for i in range(token.start + 1, token.end - 1):
            if src[i] != "\n":
                out[i] = " "
    return "".join(out)


def strip_comments_and_literals(src: str) -> str:
    """Replace comments and literal bodies with spaces, preserving offsets.

    Used where a whole-file textual decision is wanted (counting lines, looking
    for a token at a line head) without letting literal content leak in.
    """
    out = list(src)
    for token in tokenize(src):
        if token.kind in (KIND_STRING, KIND_CHAR):
            # Newlines survive: a string literal may span lines (measured
            # against 2.0.5), and callers count lines in the result.
            for i in range(token.start + 1, token.end - 1):
                if src[i] != "\n":
                    out[i] = " "
    pos = 0
    while True:
        pos = src.find("#", pos)
        if pos < 0:
            break
        nl = src.find("\n", pos)
        nl = len(src) if nl < 0 else nl
        for i in range(pos, nl):
            out[i] = " "
        pos = nl
    return "".join(out)
