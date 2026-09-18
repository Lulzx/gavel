"""The tokenizer, against the scanners it was ported from."""

from __future__ import annotations

import pytest

from gavel.lexer import (KIND_AT, KIND_CHAR, KIND_HOLE, KIND_NAME, KIND_NUMBER,
                         KIND_OP, KIND_STRING, LexError,
                         strip_comments_and_literals, tokenize)


def kinds(src: str) -> list[tuple[str, str]]:
    return [(t.kind, t.text) for t in tokenize(src)]


def test_number_literals():
    assert kinds("0n 1n 42 3.5 1.5e-3 2.0E+4") == [
        (KIND_NUMBER, "0n"), (KIND_NUMBER, "1n"), (KIND_NUMBER, "42"),
        (KIND_NUMBER, "3.5"), (KIND_NUMBER, "1.5e-3"), (KIND_NUMBER, "2.0E+4"),
    ]


def test_exponent_needs_a_decimal_point():
    # bend.ts:2208 allows an exponent only inside the '.<digits>' branch, so a
    # bare 1e3 is a number followed by a name. Worth pinning: it is the kind of
    # thing a hand-written regex would get wrong and nobody would notice.
    assert kinds("1e3") == [(KIND_NUMBER, "1"), (KIND_NAME, "e3")]


def test_names_may_contain_dots():
    assert kinds("L.add_zero") == [(KIND_NAME, "L.add_zero")]


def test_law_is_a_keyword_only_as_a_whole_lexeme():
    tokens = tokenize("law Word.law")
    assert tokens[0].is_keyword
    assert not tokens[1].is_keyword


def test_hole_names_and_bare_question():
    assert kinds("?TODO ?name") == [(KIND_HOLE, "?TODO"), (KIND_HOLE, "?name")]
    assert kinds("a ? b") == [(KIND_NAME, "a"), (KIND_OP, "?"), (KIND_NAME, "b")]


def test_strings_and_characters_keep_their_escapes():
    assert kinds('"hi\\n"') == [(KIND_STRING, '"hi\\n"')]
    assert kinds("'\\n'") == [(KIND_CHAR, "'\\n'")]
    assert kinds("'a'") == [(KIND_CHAR, "'a'")]


def test_unicode_escape_is_variable_width():
    assert kinds('"\\u{1F600}"') == [(KIND_STRING, '"\\u{1F600}"')]
    # and does not swallow the closing quote
    assert len(tokenize('"\\u{1F600}"')) == 1


def test_unterminated_string_is_an_error():
    with pytest.raises(LexError) as excinfo:
        tokenize('def f() -> String:\n  "oops\n')
    assert excinfo.value.line == 2


def test_comments_run_to_end_of_line():
    assert kinds("a # not a name\nb") == [(KIND_NAME, "a"), (KIND_NAME, "b")]


def test_at_sign_is_its_own_token():
    assert kinds("@unsafe def f() -> Nat: 0n")[0] == (KIND_AT, "@")


def test_positions_are_one_based():
    tokens = tokenize("def f() -> Nat:\n  0n\n")
    assert (tokens[0].line, tokens[0].col) == (1, 1)
    assert (tokens[-1].line, tokens[-1].col) == (2, 3)


def test_strip_comments_and_literals_preserves_offsets():
    src = 'def f() -> String:\n  "law @unsafe main" # law\n'
    stripped = strip_comments_and_literals(src)
    assert len(stripped) == len(src)
    assert stripped.count("\n") == src.count("\n")
    assert "law" not in stripped
    assert "@unsafe" not in stripped
    assert "main" not in stripped
    assert "def f" in stripped
