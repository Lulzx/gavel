"""Vendor a Bend release into the repository and record its pin.

A version is not a pin: the launcher serves whatever is current, and the
release it served has changed mid-session before. So a version is identified by
the sha256 of the tarball it came from and, once extracted, by the sha256 of
every file in ``bend2/``. Both are recorded, and ``gavel.toolchain`` recomputes
the tree hash on every load.

bun is pinned too (``bun.version``), and ``--bun`` fetches that exact release
into ``toolchain/bun/<version>/``, where ``gavel.toolchain`` prefers it over the
bun on PATH. The archive is checked against the ``SHASUMS256.txt`` the same
release publishes.

Usage:
    uv run python -m toolchain.fetch 2.0.5
    uv run python -m toolchain.fetch --from-launcher ~/.bend/rep
    uv run python -m toolchain.fetch --bun
"""

from __future__ import annotations

import argparse
import io
import json
import os
import platform
import subprocess
import sys
import tarfile
import urllib.request
import zipfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from gavel.hashing import sha256_bytes, tree_hash  # noqa: E402
from gavel.toolchain import (BUN_DIR, SOURCE_DIR, TOOLCHAIN_DIR,  # noqa: E402
                             pinned_bun_version, vendored_bun)

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


BUN_RELEASE = "https://github.com/oven-sh/bun/releases/download/bun-v{version}/{name}"


def bun_asset() -> str:
    """The release archive for this machine, by bun's own naming."""
    system = {"Darwin": "darwin", "Linux": "linux"}.get(platform.system())
    machine = {"arm64": "aarch64", "aarch64": "aarch64",
               "x86_64": "x64", "AMD64": "x64"}.get(platform.machine())
    if system is None or machine is None:
        raise SystemExit(f"no bun release for {platform.system()} "
                         f"{platform.machine()}; set GAVEL_BUN instead")
    return f"bun-{system}-{machine}"


def fetch_bun(version: str) -> Path:
    dest = vendored_bun(version)
    if dest.is_file():
        print(f"already fetched: {dest}")
        return dest
    asset = bun_asset()
    sums_url = BUN_RELEASE.format(version=version, name="SHASUMS256.txt")
    with urllib.request.urlopen(sums_url, timeout=60) as response:
        sums = response.read().decode()
    expected = next((line.split()[0] for line in sums.splitlines()
                     if line.strip().endswith(f"{asset}.zip")), None)
    if expected is None:
        raise SystemExit(f"{sums_url} lists no {asset}.zip")
    url = BUN_RELEASE.format(version=version, name=f"{asset}.zip")
    print(f"fetching {url}")
    blob = download(url, expected)
    with zipfile.ZipFile(io.BytesIO(blob)) as archive:
        binary = archive.read(f"{asset}/bun")
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_bytes(binary)
    dest.chmod(0o755)
    out = subprocess.run([str(dest), "--version"], capture_output=True,
                         text=True, check=True).stdout.strip()
    if out != version:
        dest.unlink()
        raise SystemExit(f"the fetched bun reports {out}, not {version}")
    print(f"bun {version} -> {dest}")
    return dest


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("version", nargs="?", help="release to vendor, e.g. 2.0.5")
    parser.add_argument("--from-launcher", metavar="REP",
                        help="read url and sha256 from a launcher rep file")
    parser.add_argument("--dir", default=str(TOOLCHAIN_DIR))
    parser.add_argument("--bun", action="store_true",
                        help=f"fetch the bun that bun.version pins into {BUN_DIR}")
    args = parser.parse_args(argv)

    if args.bun:
        pinned = pinned_bun_version(Path(args.dir))
        if pinned is None:
            parser.error("bun.version is missing, so there is no pin to fetch")
        fetch_bun(pinned)
        if args.version is None and not args.from_launcher:
            return 0

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
