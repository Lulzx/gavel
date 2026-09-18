"""Content addressing: the only pin that survives a toolchain that self-updates."""

from __future__ import annotations

import hashlib
from pathlib import Path


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_text(text: str) -> str:
    return sha256_bytes(text.encode("utf-8"))


def sha256_file(path: Path) -> str:
    return sha256_bytes(Path(path).read_bytes())


def tree_hash(root: Path) -> str:
    """Hash a directory tree deterministically.

    Files are visited in sorted relative-path order and each contributes
    "<sha256> <path>\\n" to the outer digest, the same shape main.ts uses for
    hub package hashes (main.ts:331). Sorting makes the result independent of
    directory iteration order, so the same bytes hash the same on any host.
    """
    root = Path(root)
    outer = hashlib.sha256()
    for path in sorted(p for p in root.rglob("*") if p.is_file()):
        rel = path.relative_to(root).as_posix()
        outer.update(f"{sha256_file(path)} {rel}\n".encode("utf-8"))
    return outer.hexdigest()


def hash_files(files: dict[str, str]) -> str:
    """Hash a mapping of logical path -> content, order-independently."""
    outer = hashlib.sha256()
    for name in sorted(files):
        outer.update(f"{sha256_text(files[name])} {name}\n".encode("utf-8"))
    return outer.hexdigest()
