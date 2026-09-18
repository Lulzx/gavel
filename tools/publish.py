"""Derive a task's metadata from its files, and rebuild the bank manifest.

The law list and the immutable-file hashes are read out of the task's own
``LAWS.bend`` and ``prelude.bend`` rather than being maintained by hand: a
metadata field that can disagree with the file it describes is a field that
eventually will, and the gate's integrity check would then reject a task that
is perfectly fine.

This tool does not claim a task is valid. It used to -- every entry it wrote
carried ``"valid": true``, which nothing had measured, and a bare run rebuilt
the entries from scratch so a quarantine set by hand was silently erased by the
very command CI runs. Validity is V1-V5's to state (``tools/validate.py``) and
this tool's job is only to describe the files. What it does carry is
``quarantined``: a task excluded from the bank on purpose, which survives a
republish because dropping it would make the exclusion expire on its own.
Lifting one is a deliberate edit, not a side effect of editing the task.

Usage:
    uv run python -m tools.publish            # every task under tasks/
    uv run python -m tools.publish tasks/1/t1-add-plus
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


def publish_task(root: Path, version: str, repo: Path = REPO_ROOT,
                 previous: dict | None = None) -> dict:
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
    entry = {
        "task_id": task_id,
        "tier": tier,
        "path": root.relative_to(repo).as_posix(),
        "reference": f"references/{task_id}",
        "hash": hash_files({LAWS_FILE: laws_src, PRELUDE_FILE: prelude_src,
                            SOLUTION_FILE: stub_src}),
    }
    # Carried forward whether or not the task's files changed. A quarantine that
    # expires when someone edits the task is not an exclusion, it is a delay.
    if previous and previous.get("quarantined"):
        entry["quarantined"] = True
    return entry


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("paths", nargs="*", help="task directories")
    parser.add_argument("--version", default=DEFAULT_VERSION)
    parser.add_argument("--manifest", default=str(MANIFEST),
                        help="where to write the bank; task paths are stored "
                             "relative to this file, so keep it in the repo root")
    args = parser.parse_args(argv)
    manifest = Path(args.manifest).resolve()

    # Read the bank even on a bare run. Rebuilding the entries from scratch is
    # what erased hand-set quarantines; a task whose directory is gone is still
    # dropped below, because that is the one thing the filesystem decides.
    existing = json.loads(manifest.read_text()) if manifest.is_file() else {"tasks": []}
    roots = ([Path(p).resolve() for p in args.paths] if args.paths else
             sorted(p.parent for p in (REPO_ROOT / "tasks").glob("*/*/LAWS.bend")))

    # Everything is checked before anything is written. Publishing is a
    # read-then-write per task, so a task that is mid-write used to fail on the
    # eighth of twenty with a FileNotFoundError, having already rewritten the
    # metadata of the first seven. Two agents share this tree; the whole point
    # of failing here is that "half of it happened" is not a state anyone can
    # reason about afterwards.
    unusable = [(root, [n for n in (LAWS_FILE, PRELUDE_FILE, SOLUTION_FILE)
                        if not (root / n).is_file()]) for root in roots]
    unusable = [(root, missing) for root, missing in unusable if missing]
    if unusable:
        for root, missing in unusable:
            print(f"publish: {root} is missing {', '.join(missing)}",
                  file=sys.stderr)
        print(f"publish: nothing written -- {len(unusable)} of {len(roots)} "
              f"task(s) are incomplete, and a task caught mid-write would be "
              f"registered exactly as it stands", file=sys.stderr)
        return 1

    entries = {e["task_id"]: e for e in existing.get("tasks", [])}
    if not args.paths:
        entries = {name: e for name, e in entries.items()
                   if (REPO_ROOT / e["path"]).is_dir()}
    for root in roots:
        entry = publish_task(root, args.version, previous=entries.get(root.name))
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
