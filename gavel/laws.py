"""Reading declarations out of Bend source: imports, laws, defs.

Everything here works on the token stream from ``lexer`` rather than on
regexes over text, so a name inside a string or a comment is never mistaken for
a declaration. Module qualification mirrors ``parse_qual``/``parse_reso``
(bend.ts:1646) so that the names this module reports are the names the checker
will bind.
"""

from __future__ import annotations

import posixpath
import re
from dataclasses import dataclass

from .lexer import (KIND_AT, KIND_NAME, KIND_OP, KIND_STRING, LexError, tokenize)

# bend.ts:1028 and :1030. Imports are recognised per *line*, not per token --
# that is how the loader reads them, and matching it keeps the gate honest.
_IMPORT_LINE = re.compile(r"^import(\s.*|)$")
_IMPORT_REST = re.compile(r"^\s+(\S+)(?:\s+as\s+([A-Za-z_][A-Za-z0-9_]*))?\s*(?:#.*)?$")

DECL_KEYWORDS = frozenset({"def", "type", "law"})


@dataclass(frozen=True)
class ImportSpec:
    path: str | None      # what follows ``import``, or None if the line is malformed
    alias: str | None
    raw: str
    line: int             # 1-based

    @property
    def is_base(self) -> bool:
        return self.path == "Base" and self.alias is None

    @property
    def is_hub(self) -> bool:
        return self.path is not None and re.match(r"^0x[0-9a-fA-F]+/", self.path) is not None

    @property
    def is_relative(self) -> bool:
        return self.path is not None and self.path.startswith("./")

    @property
    def module(self) -> str | None:
        """The namespace this import binds, as bend.ts computes it."""
        if self.path is None or self.alias is None:
            return None
        return posixpath.basename(posixpath.normpath(self.path))[: -len(".bend")] \
            if self.path.endswith(".bend") else None


@dataclass(frozen=True)
class Chunk:
    """One top-level declaration and the exact source text that spells it."""

    kind: str            # "def" | "type" | "law"
    name: str            # the name as written, before qualification
    unsafe: bool
    text: str
    line: int            # 1-based line of the declaration keyword
    index: int           # position among top-level declarations


def parse_imports(src: str) -> list[ImportSpec]:
    out: list[ImportSpec] = []
    for i, raw in enumerate(src.split("\n"), start=1):
        if _IMPORT_LINE.match(raw.strip()) is None:
            continue
        rest = _IMPORT_REST.match(raw.strip()[len("import"):])
        if rest is None:
            out.append(ImportSpec(None, None, raw.strip(), i))
        else:
            out.append(ImportSpec(rest.group(1), rest.group(2), raw.strip(), i))
    return out


def alias_map(imports: list[ImportSpec]) -> dict[str, str]:
    """alias -> module namespace, for the files this submission imports."""
    return {imp.alias: imp.module for imp in imports
            if imp.alias is not None and imp.module is not None}


def qualify(name: str, ns: str = "", aliases: dict[str, str] | None = None) -> str:
    """Resolve a written name to the key the checker binds (parse_reso)."""
    if aliases:
        head, dot, rest = name.partition(".")
        if dot and head in aliases:
            return aliases[head] + "." + rest
    return f"{ns}.{name}" if ns else name


def split_top_level(src: str) -> list[Chunk]:
    """Split a module into its top-level declarations.

    ``def``, ``type`` and ``law`` cannot occur inside a body or an expression --
    ``parse_name`` rejects them as names -- so every occurrence of one starts a
    declaration, and the token stream alone is enough to cut the file up.
    """
    try:
        tokens = tokenize(src)
    except LexError:
        return []
    heads: list[tuple[int, int, bool]] = []  # (token index, start offset, unsafe)
    for i, token in enumerate(tokens):
        if token.kind != KIND_NAME or token.text not in DECL_KEYWORDS:
            continue
        start = token.start
        unsafe = False
        # bend.ts:2540 takes "@", then the word "unsafe", then requires "def".
        # So the decorator is three tokens, and only a def may carry it.
        if (token.text == "def" and i >= 2
                and tokens[i - 1].kind == KIND_NAME and tokens[i - 1].text == "unsafe"
                and tokens[i - 2].kind == KIND_AT):
            start = tokens[i - 2].start
            unsafe = True
        heads.append((i, start, unsafe))
    chunks: list[Chunk] = []
    for n, (ti, start, unsafe) in enumerate(heads):
        end = heads[n + 1][1] if n + 1 < len(heads) else len(src)
        name = ""
        for token in tokens[ti + 1:]:
            if token.kind == KIND_NAME:
                name = token.text
                break
            if token.kind != KIND_OP or token.text != "<":
                break
        text = src[start:end].rstrip()
        if not text:
            continue
        chunks.append(Chunk(kind=tokens[ti].text, name=name, unsafe=unsafe,
                            text=text, line=tokens[ti].line, index=len(chunks)))
    return chunks


def law_names(src: str, ns: str = "", aliases: dict[str, str] | None = None) -> list[str]:
    """Law names in declaration order, qualified as the checker binds them."""
    return [qualify(c.name, ns, aliases) for c in split_top_level(src) if c.kind == "law"]


def def_chunks(src: str) -> dict[str, Chunk]:
    """Written def name -> chunk. Later duplicates overwrite earlier ones."""
    return {c.name: c for c in split_top_level(src) if c.kind == "def"}


def top_level_names(src: str, ns: str = "", aliases: dict[str, str] | None = None) -> list[tuple[str, Chunk]]:
    """Every top-level name this file declares, qualified, with its chunk."""
    return [(qualify(c.name, ns, aliases), c) for c in split_top_level(src)]


def declared_names(src: str) -> list[tuple[str, Chunk]]:
    """Every top-level name as *written*, unqualified."""
    return [(c.name, c) for c in split_top_level(src)]


def uses_unsafe(src: str) -> bool:
    return any(c.unsafe for c in split_top_level(src))


def has_foreign_import(src: str) -> tuple[bool, int]:
    """``import "x.c"`` inside a def body declares a foreign effect (bend.ts:2508)."""
    try:
        tokens = tokenize(src)
    except LexError:
        return (False, 0)
    for i, token in enumerate(tokens[:-1]):
        if (token.kind == KIND_NAME and token.text == "import"
                and tokens[i + 1].kind == KIND_STRING):
            return (True, token.line)
    return (False, 0)
