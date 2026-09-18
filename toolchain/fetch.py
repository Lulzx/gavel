"""Vendor a Bend release into the repository and record its pin.

A version is not a pin: the launcher serves whatever is current, and the
release it served has changed mid-session before. So a version is identified by
the sha256 of the tarball it came from and, once extracted, by the sha256 of
every file in ``bend2/``. Both are recorded, and ``gavel.toolchain`` recomputes
the tree hash on every load.

Usage:
    uv run python -m toolchain.fetch 2.0.5
    uv run python -m toolchain.fetch --from-launcher ~/.bend/rep
"""

from __future__ import annotations

import argparse
import io
import json
import os
import subprocess
import sys
import tarfile
import urllib.request
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from gavel.hashing import sha256_bytes, tree_hash  # noqa: E402
from gavel.toolchain import SOURCE_DIR, TOOLCHAIN_DIR  # noqa: E402

# A release is pinned by the hash of the bytes we vendored, so a re-fetch of a
# moved URL fails loudly instead of silently changing the reward function.
RELEASES: dict[str, dict[str, str]] = {
    "2.0.5": {
        "url": "https://bend-lang.com/dl/2.0.5.tar.gz",
        "sha256": "4db70e77ce1b1027f1d0e15dee025921fa794a9b415add4350ec7c64acf2775b",
    },
}


def load_rep(path: Path) -> dict[str, str]:
    """Read the launcher's own release record (~/.bend/rep)."""
    rep = json.loads(Path(path).read_text())
    return {"url": rep["url"], "sha256": rep["sha256"]}


def download(url: str, expected: str) -> bytes:
    with urllib.request.urlopen(url, timeout=120) as response:
        blob = response.read()
    actual = sha256_bytes(blob)
    if actual != expected:
        raise SystemExit(
            f"refusing to vendor {url}: sha256 is {actual}, expected {expected}")
    return blob


def extract(blob: bytes, dest: Path) -> None:
    """Extract only the bend2/ tree; a release carries nothing else we need."""
    dest.mkdir(parents=True, exist_ok=True)
    with tarfile.open(fileobj=io.BytesIO(blob), mode="r:gz") as tar:
        members = [m for m in tar.getmembers()
                   if m.name == SOURCE_DIR or m.name.startswith(SOURCE_DIR + "/")]
        if not members:
            raise SystemExit(f"the tarball carries no {SOURCE_DIR}/ directory")
        for member in members:
            # A tarball is untrusted input; refuse anything that climbs out.
            target = (dest / member.name).resolve()
            if not str(target).startswith(str(dest.resolve()) + os.sep):
                raise SystemExit(f"refusing to extract {member.name}: escapes {dest}")
        tar.extractall(dest, members=members, filter="data")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("version", nargs="?", help="release to vendor, e.g. 2.0.5")
    parser.add_argument("--from-launcher", metavar="REP",
                        help="read url and sha256 from a launcher rep file")
    parser.add_argument("--dir", default=str(TOOLCHAIN_DIR))
    args = parser.parse_args(argv)

    if args.from_launcher:
        info = load_rep(Path(args.from_launcher).expanduser())
        version = args.version or Path(args.from_launcher).expanduser().parent.name
        if version not in RELEASES:
            version = Path(info["url"]).name.removesuffix(".tar.gz")
    else:
        if args.version is None:
            parser.error("a version is required unless --from-launcher is given")
        version = args.version
        if version not in RELEASES:
            parser.error(f"unknown release {version}; known: {sorted(RELEASES)}")
        info = RELEASES[version]

    root = Path(args.dir)
    home = root / version
    if (home / SOURCE_DIR / "main.ts").is_file():
        print(f"already vendored: {home}")
    else:
        print(f"fetching {info['url']}")
        extract(download(info["url"], info["sha256"]), home)

    digest = tree_hash(home / SOURCE_DIR)
    (root / f"{version}.sha256").write_text(digest + "\n")
    print(f"{SOURCE_DIR} tree hash {digest}")
    print(f"wrote {root / f'{version}.sha256'}")

    bun = _bun_path()
    if bun is not None:
        version_out = subprocess.run([str(bun), "--version"], capture_output=True,
                                     text=True, check=True).stdout.strip()
        (root / "bun.version").write_text(version_out + "\n")
        print(f"pinned bun {version_out} ({bun})")
    return 0


def _bun_path() -> Path | None:
    from gavel.toolchain import _resolve_bun  # local import: fetch may run standalone
    try:
        return _resolve_bun(None)
    except Exception:
        return None


if __name__ == "__main__":
    raise SystemExit(main())
