"""Reading declarations out of Bend source."""

from __future__ import annotations

import pytest

from gavel.laws import (alias_map, has_foreign_import, law_names, parse_imports,
                        qualify, split_top_level, uses_unsafe)
from gavel.tasks import DEFAULT_PROOF_HEADER

HEADER = DEFAULT_PROOF_HEADER


def test_parse_imports_reads_paths_and_aliases():
    imports = parse_imports(HEADER)
    assert [(i.path, i.alias) for i in imports] == [
        ("Base", None), ("./prelude.bend", "P"),
        ("./solution.bend", "S"), ("./LAWS.bend", "L"),
    ]
    assert imports[0].is_base
    assert not imports[1].is_base
    assert imports[3].module == "LAWS"


def test_base_with_an_alias_is_not_an_import_of_base():
    imports = parse_imports("import Base as B\n")
    assert imports[0].alias == "B"
    assert not imports[0].is_base


def test_hub_imports_are_recognised():
    assert parse_imports("import 0xdeadbeef/foo@abcdef\n")[0].is_hub
    assert not parse_imports("./x.bend").__len__()  # not at line head: ignored


def test_relative_and_hub_are_distinct():
    assert parse_imports("import ./x.bend\n")[0].is_relative
    assert not parse_imports("import 0x1/x\n")[0].is_relative


def test_a_bare_import_is_malformed_not_silent():
    spec = parse_imports("import\n")[0]
    assert spec.path is None
    assert spec.is_hub is False


def test_an_indented_import_line_is_still_read():
    # book_load is line-based and strips; matching it keeps the gate honest
    # about a body-level `import "x.c"` that the loader would also see.
    assert parse_imports('  import "x.c"\n')[0].path == '"x.c"'


def test_an_import_spelled_inside_a_multiline_string_is_not_read():
    """The loader stops at the first declaration and never reaches such a line.

    The checker accepts the file, so a scan that rejected it would refuse an
    honest submission. See test_a_multiline_string_can_spell_an_import_line for
    what the file does at the gate.
    """
    src = ('import Base\n\ndef f() -> String:\n'
           '  "a\nimport ./evil.bend as E\n"\n')
    assert [spec.path for spec in parse_imports(src)] == ["Base"]


def test_a_single_line_string_cannot_hide_a_foreign_import():
    """`import "x.c"` is a real declaration and must stay readable."""
    assert parse_imports('import "x.c"\n')[0].path == '"x.c"'


def test_alias_map():
    assert alias_map(parse_imports(HEADER)) == {"P": "prelude", "S": "solution",
                                                "L": "LAWS"}


def test_qualify_resolves_through_aliases():
    aliases = alias_map(parse_imports(HEADER))
    assert qualify("S.add", "", aliases) == "solution.add"
    assert qualify("L.add_zero", "", aliases) == "LAWS.add_zero"
    # an unknown head is left alone rather than mangled
    assert qualify("Nat", "", aliases) == "Nat"
    assert qualify("add", "L") == "L.add"


def test_split_top_level_cuts_on_declaration_keywords():
    src = "def a() -> Nat:\n  0n\n\ndef b() -> Nat:\n  1n\n"
    assert [(c.kind, c.name) for c in split_top_level(src)] == [
        ("def", "a"), ("def", "b")]


def test_split_top_level_recognises_types_and_laws():
    src = "type Foo:\n  Bar\n\nlaw l:\n  for x: Nat\n  {x == x : Nat}\n"
    assert [(c.kind, c.name) for c in split_top_level(src)] == [
        ("type", "Foo"), ("law", "l")]
    assert law_names(src) == ["l"]


def test_imports_are_not_declarations():
    assert split_top_level(HEADER) == []


def test_unsafe_is_attributed_to_the_declaration_it_precedes():
    chunks = split_top_level("@unsafe\ndef a() -> Nat:\n  0n\n")
    assert chunks[0].unsafe
    assert uses_unsafe("@unsafe\ndef a() -> Nat:\n  0n\n")
    assert not uses_unsafe("def a() -> Nat:\n  0n\n")


def test_unsafe_does_not_leak_to_a_later_declaration():
    # A single-declaration file passes even if the flag is computed once and
    # reused, so this is the case that actually pins the attribution.
    src = ("@unsafe\ndef a() -> Nat:\n  0n\n\n"
           "def b() -> Nat:\n  1n\n")
    a, b = split_top_level(src)
    assert a.unsafe
    assert not b.unsafe


def test_unsafe_does_not_leak_backwards_from_a_later_declaration():
    src = ("def a() -> Nat:\n  0n\n\n"
           "@unsafe\ndef b() -> Nat:\n  1n\n")
    a, b = split_top_level(src)
    assert not a.unsafe
    assert b.unsafe


def test_only_a_def_may_carry_the_decorator():
    # bend.ts:2546 requires "def" immediately after @unsafe
    chunks = split_top_level("@unsafe\nlaw l:\n  for x: Nat\n  {x == x : Nat}\n")
    assert not chunks[0].unsafe


def test_a_declaration_inside_a_string_is_not_a_declaration():
    src = 'def a() -> String:\n  "def b() -> Nat: 0n"\n'
    assert [c.name for c in split_top_level(src)] == ["a"]


def test_a_declaration_inside_a_comment_is_not_a_declaration():
    src = "def a() -> Nat:\n  # def b() -> Nat:\n  0n\n"
    assert [c.name for c in split_top_level(src)] == ["a"]


def test_chunks_preserve_declaration_order():
    src = "def z() -> Nat:\n  0n\n\ndef a() -> Nat:\n  1n\n"
    assert [c.index for c in split_top_level(src)] == [0, 1]
    assert [c.name for c in split_top_level(src)] == ["z", "a"]


def test_foreign_import_inside_a_def_body():
    src = 'def f() -> u24:\n  import "x.c"\n  return 0\n'
    assert has_foreign_import(src) == (True, 2)


def test_a_top_level_import_is_not_a_foreign_import():
    assert has_foreign_import(HEADER) == (False, 0)


def test_untokenizable_source_yields_no_chunks_rather_than_raising():
    # A file the *gate* cannot read must not become a file the checker is
    # handed: returning no chunks leaves nothing to allowlist, and the
    # submission fails the name check rather than sailing through.
    assert split_top_level('def f() -> String:\n  "x\n') == []


def test_source_that_tokenizes_but_does_not_parse_still_cuts_into_chunks():
    # Tokenizing is not parsing: the gate does not need a grammar, and
    # refusing to answer here would turn a policy's syntax error into a gate
    # rejection with a misleading reason.
    assert [c.name for c in split_top_level("def f( -> Nat:\n")] == ["f"]
