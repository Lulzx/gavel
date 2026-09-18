"""Locating and verifying the pinned checker.

The ``bend`` on PATH is a launcher: it phones home, self-updates, and moved
2.0.4 -> 2.0.5 underneath a single probe session. Nothing in the reward path
may touch it. The real checker is a TypeScript program (``bend2/main.ts``) run
by bun, so pinning means hashing the vendored source tree and calling bun on it
directly. The tree hash -- not a version string -- is the identity, because
that is the only thing the launcher cannot change under us.
"""

from __future__ import annotations

import os
import shutil
import subprocess
from dataclasses import dataclass
from pathlib import Path

from .hashing import tree_hash

DEFAULT_VERSION = "2.0.5"
REPO_ROOT = Path(__file__).resolve().parent.parent
TOOLCHAIN_DIR = REPO_ROOT / "toolchain"

# Files that constitute a version. Anything else in the tree is data the
# checker reads (effs/) and is hashed along with it.
SOURCE_DIR = "bend2"


class ToolchainError(RuntimeError):
    """The pinned checker is missing, corrupt, or not the version we pinned."""


@dataclass(frozen=True)
class Toolchain:
    version: str
    root: Path          # toolchain/<version>
    bun: Path
    bun_version: str
    tree_hash: str      # sha256 of the vendored bend2/ tree, as verified now

    @property
    def source(self) -> Path:
        return self.root / SOURCE_DIR

    @property
    def main_ts(self) -> Path:
        return self.source / "main.ts"

    @property
    def base_bend(self) -> Path:
        return self.source / "base.bend"

    def argv(self, target: str | Path) -> list[str]:
        """The exact command the reward path runs. Never the launcher."""
        return [str(self.bun), str(self.main_ts), str(target)]

    def to_json(self) -> dict[str, str]:
        return {"version": self.version, "tree_hash": self.tree_hash,
                "bun": self.bun_version}

    @classmethod
    def load(cls, version: str = DEFAULT_VERSION, root: Path | None = None,
             bun: str | Path | None = None, verify: bool = True) -> "Toolchain":
        base = Path(root) if root is not None else TOOLCHAIN_DIR
        home = base / version
        if not (home / SOURCE_DIR / "main.ts").is_file():
            raise ToolchainError(
                f"no vendored Bend {version} at {home}. "
                f"Run: uv run python -m toolchain.fetch {version}")
        expected_file = base / f"{version}.sha256"
        if verify:
            if not expected_file.is_file():
                raise ToolchainError(
                    f"{expected_file} is missing; the pin cannot be checked. "
                    f"Run: uv run python -m toolchain.fetch {version}")
            expected = expected_file.read_text().split()[0].strip()
            actual = tree_hash(home / SOURCE_DIR)
            if actual != expected:
                raise ToolchainError(
                    f"toolchain {version} does not match its pin: "
                    f"expected {expected}, computed {actual}. The tree has been "
                    f"modified since it was vendored; re-vendor it.")
        resolved_bun = _resolve_bun(bun)
        bun_version = _bun_version(resolved_bun)
        pinned_file = base / "bun.version"
        if verify and pinned_file.is_file():
            pinned = pinned_file.read_text().strip()
            if pinned and bun_version != pinned and \
                    os.environ.get("GAVEL_ALLOW_BUN_DRIFT") != "1":
                raise ToolchainError(
                    f"bun is {bun_version} but the toolchain pins {pinned}. "
                    f"A different bun can change checker behaviour, so the pin "
                    f"is enforced; set GAVEL_ALLOW_BUN_DRIFT=1 to override.")
        return cls(version=version, root=home, bun=resolved_bun,
                   bun_version=bun_version, tree_hash=tree_hash(home / SOURCE_DIR))


def _resolve_bun(bun: str | Path | None) -> Path:
    if bun is not None:
        path = Path(bun).expanduser()
        if not path.is_file():
            raise ToolchainError(f"bun not found at {path}")
        return path
    env = os.environ.get("GAVEL_BUN")
    if env:
        path = Path(env).expanduser()
        if not path.is_file():
            raise ToolchainError(f"GAVEL_BUN points at {path}, which is not a file")
        return path
    found = shutil.which("bun")
    if found:
        return Path(found).resolve()
    fallback = Path.home() / ".bun" / "bin" / "bun"
    if fallback.is_file():
        return fallback
    raise ToolchainError("bun not found: set GAVEL_BUN or put it on PATH")


def _bun_version(bun: Path) -> str:
    try:
        out = subprocess.run([str(bun), "--version"], capture_output=True,
                             text=True, timeout=30, check=True)
    except (subprocess.SubprocessError, OSError) as exc:
        raise ToolchainError(f"could not run {bun} --version: {exc}") from exc
    return out.stdout.strip()
