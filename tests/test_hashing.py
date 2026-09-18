"""Hashing, including the tree hash that pins the toolchain."""

from __future__ import annotations

from pathlib import Path

from gavel.hashing import hash_files, sha256_bytes, sha256_file, sha256_text, tree_hash

# The empty input's digest, so a change to the encoding shows up as a failure
# rather than as a silently different pin.
EMPTY_SHA256 = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"


def test_sha256_of_empty_input():
    assert sha256_bytes(b"") == EMPTY_SHA256
    assert sha256_text("") == EMPTY_SHA256


def test_sha256_text_matches_its_utf8_bytes():
    assert sha256_text("λ") == sha256_bytes("λ".encode("utf-8"))


def test_sha256_file(tmp_path: Path):
    path = tmp_path / "f"
    path.write_text("hello")
    assert sha256_file(path) == sha256_text("hello")


def test_tree_hash_is_order_independent(tmp_path: Path):
    a, b = tmp_path / "a", tmp_path / "b"
    (a / "sub").mkdir(parents=True)
    (b / "sub").mkdir(parents=True)
    for root in (a, b):
        (root / "x.ts").write_text("x")
        (root / "sub" / "y.ts").write_text("y")
    assert tree_hash(a) == tree_hash(b)


def test_tree_hash_notices_a_changed_byte(tmp_path: Path):
    (tmp_path / "x.ts").write_text("x")
    before = tree_hash(tmp_path)
    (tmp_path / "x.ts").write_text("y")
    assert tree_hash(tmp_path) != before


def test_tree_hash_notices_a_renamed_file(tmp_path: Path):
    (tmp_path / "x.ts").write_text("same")
    before = tree_hash(tmp_path)
    (tmp_path / "x.ts").rename(tmp_path / "z.ts")
    assert tree_hash(tmp_path) != before


def test_tree_hash_notices_an_added_file(tmp_path: Path):
    (tmp_path / "x.ts").write_text("x")
    before = tree_hash(tmp_path)
    (tmp_path / "y.ts").write_text("y")
    assert tree_hash(tmp_path) != before


def test_tree_hash_of_an_empty_tree_is_the_empty_digest(tmp_path: Path):
    assert tree_hash(tmp_path) == EMPTY_SHA256


def test_hash_files_covers_names_and_contents():
    base = {"a.bend": "1", "b.bend": "2"}
    assert hash_files(base) == hash_files(dict(reversed(list(base.items()))))
    assert hash_files(base) != hash_files({"a.bend": "1", "b.bend": "3"})
    assert hash_files(base) != hash_files({"a.bend": "1"})
