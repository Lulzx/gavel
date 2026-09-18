"""Derive a task's metadata from its files, and rebuild the bank manifest.

The law list and the immutable-file hashes are read out of the task's own
``LAWS.bend`` and ``prelude.bend`` rather than being maintained by hand: a
metadata field that can disagree with the file it describes is a field that
eventually will, and the gate's integrity check would then reject a task that
is perfectly fine.

Usage:
    uv run python -m tools.publish            # every task under tasks/
    uv run python -m tools.publish tasks/1/t1-add-zero
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from gavel.hashing import hash_files, sha256_text  # noqa: E402
from gavel.laws import split_top_level  # noqa: E402
from gavel.tasks import (HASH_KEYS, LAWS_FILE, PRELUDE_FILE,  # noqa: E402
                         SOLUTION_FILE)
from gavel.toolchain import DEFAULT_VERSION, Toolchain  # noqa: E402

REPO_ROOT = Path(__file__).resolve().parent.parent
MANIFEST = REPO_ROOT / "manifest.json"

DEFAULT_PROOF_HEADER = (
    "import Base\n"
    "import ./prelude.bend as P\n"
    "import ./solution.bend as S\n"
    "import ./LAWS.bend as L\n"
)


def law_names(src: str) -> list[str]:
    return [c.name for c in split_top_level(src) if c.kind == "law"]


def target_names(src: str) -> list[str]:
    """The defs a stub leaves for the policy: everything not under Policy.*."""
    return [c.name for c in split_top_level(src)
            if c.kind == "def" and not c.name.startswith("Policy.")]


def publish_task(root: Path, version: str) -> dict:
    meta_path = root / "meta.json"
    meta = json.loads(meta_path.read_text()) if meta_path.is_file() else {}
    laws_src = (root / LAWS_FILE).read_text()
    prelude_src = (root / PRELUDE_FILE).read_text()
    stub_src = (root / SOLUTION_FILE).read_text()

    task_id = root.name
    tier = int(root.parent.name)
    laws = law_names(laws_src)
    if not laws:
        raise SystemExit(f"{root}: LAWS.bend declares no law")

    meta.update({
        "task_id": task_id,
        "tier": tier,
        "laws": laws,
        "policy_targets": meta.get("policy_targets") or target_names(stub_src),
        "prelude_defs": meta.get("prelude_defs", []),
        "proof_header": meta.get("proof_header", DEFAULT_PROOF_HEADER),
        "hashes": {
            HASH_KEYS[LAWS_FILE]: sha256_text(laws_src),
            HASH_KEYS[PRELUDE_FILE]: sha256_text(prelude_src),
        },
        "bend_version": version,
    })
    meta_path.write_text(json.dumps(meta, indent=2, sort_keys=False) + "\n")
    return {
        "task_id": task_id,
        "tier": tier,
        "path": root.relative_to(REPO_ROOT).as_posix(),
        "reference": f"references/{task_id}",
        "hash": hash_files({LAWS_FILE: laws_src, PRELUDE_FILE: prelude_src,
                            SOLUTION_FILE: stub_src}),
        "valid": True,
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("paths", nargs="*", help="task directories")
    parser.add_argument("--version", default=DEFAULT_VERSION)
    parser.add_argument("--manifest", default=str(MANIFEST),
                        help="where to write the bank; task paths are stored "
                             "relative to this file, so keep it in the repo root")
    args = parser.parse_args(argv)
    manifest = Path(args.manifest).resolve()

    if args.paths:
        roots = [Path(p).resolve() for p in args.paths]
        existing = json.loads(manifest.read_text()) if manifest.is_file() else {"tasks": []}
    else:
        roots = sorted(p.parent for p in (REPO_ROOT / "tasks").glob("*/*/LAWS.bend"))
        existing = {"tasks": []}

    entries = {e["task_id"]: e for e in existing.get("tasks", [])}
    for root in roots:
        entry = publish_task(root, args.version)
        entries[entry["task_id"]] = entry
        print(f"published {entry['task_id']} (tier {entry['tier']}, "
              f"{len(json.loads((root / 'meta.json').read_text())['laws'])} laws)")

    toolchain = Toolchain.load(args.version)
    bank = {
        "version": 1,
        "bend_version": args.version,
        "toolchain_hash": toolchain.tree_hash,
        "bun_version": toolchain.bun_version,
        "tasks": sorted(entries.values(), key=lambda e: (e["tier"], e["task_id"])),
    }
    manifest.write_text(json.dumps(bank, indent=2) + "\n")
    print(f"manifest: {len(bank['tasks'])} tasks -> {manifest}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
