"""The three static screens this bank was audited with, kept in the repo.

They were written as scratch scripts under /tmp during the 2026-09-19 audit and
the /tmp copies were cleaned twice mid-session, taking the evidence with them.
They are ported here verbatim, with `ROOT` resolved from this file instead of
hardcoded, so PLAN.md's readings can be reproduced.

    uv run python -m tools.screens positions [task-id ...]
    uv run python -m tools.screens general   [manifest.json] [task-id ...]
    uv run python -m tools.screens batch     [manifest.json] <task-id> ...

`positions` reads the task directories directly, so it sees a task before it is
registered. `general` and `batch` read `manifest.json` by default and take a
manifest path as a first argument otherwise; `batch` will also fall back to the
`manifest.scratch.*.json` files in the repo root, which are untracked and so
absent from a fresh clone.

None of the three runs the checker, so none of them can tell you whether a body
escapes a law set. They flag *room* -- a law set that names a target at a point
and leaves it free elsewhere. A flag is triage; a clean run is not a proof.
"""

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

LAW_HEAD = re.compile(r"^\s*law\s+([\w.]+)\s*:", re.M)
NUM = re.compile(r"\d+n")


# --------------------------------------------------------------------------
# Shared helpers
# --------------------------------------------------------------------------

def split_args(s):
    """Top-level comma split, respecting (), {}, []."""
    out, depth, cur = [], 0, ""
    for ch in s:
        if ch in "({[":
            depth += 1
        elif ch in ")}]":
            depth -= 1
        if ch == "," and depth == 0:
            out.append(cur.strip())
            cur = ""
        else:
            cur += ch
    out.append(cur.strip())
    return [a for a in out if a != ""]


def laws_of(path):
    src = path.read_text()
    heads = list(LAW_HEAD.finditer(src))
    out = []
    for i, m in enumerate(heads):
        end = heads[i + 1].start() if i + 1 < len(heads) else len(src)
        out.append((m.group(1), src[m.end():end]))
    return out


def sigs(path):
    """The (name, arity/type-line) of every top-level def a policy must write."""
    if not path.exists():
        return {}
    out = {}
    for m in re.finditer(r"^def\s+([A-Za-z_][\w.]*)\s*(\([^)]*\))?\s*(->\s*[^:]+)?",
                         path.read_text(), re.M):
        out[m.group(1)] = (m.group(2) or "").strip()
    return out


# --------------------------------------------------------------------------
# Screen 1: argument positions observed only closed (Fact 47)
# --------------------------------------------------------------------------

def applications(expr, target):
    """Every `S.<target>(...)` (or bare `<target>(...)`) in expr, with its args."""
    found = []
    for m in re.finditer(rf"(?:S\.)?\b{re.escape(target)}\s*\(", expr):
        start = m.end()
        depth, i = 1, start
        while i < len(expr) and depth:
            if expr[i] in "({[":
                depth += 1
            elif expr[i] in ")}]":
                depth -= 1
            i += 1
        found.append(split_args(expr[start:i - 1]))
    return found


def is_closed(arg):
    return re.fullmatch(r"\d+n|[\w.]+?\{\}", arg) is not None


def positions(ids):
    """For each policy target, every argument position at which any law
    *observes* it (`S.<target>(...)` anywhere in a law's left-hand side).

    A (target, position) whose observations are all `closed` and which is
    observed at least once is the hole: the law names the function at a point
    and leaves it free at every other point. That is exactly `mul`'s first
    argument in `t1-mul-two` (seen at `0n` and `2n`) and `add`'s second in
    `t1-pred-succ` (seen at `1n`).
    """
    entries = []
    for meta_p in sorted(ROOT.glob("tasks/*/*/meta.json")):
        meta = json.loads(meta_p.read_text())
        tid = meta.get("task_id", meta_p.parent.name)
        if ids and tid not in ids:
            continue
        laws_p = meta_p.parent / "LAWS.bend"
        if not laws_p.exists():
            continue
        entries.append((meta.get("tier"), tid, meta.get("policy_targets", []),
                        laws_of(laws_p)))

    flagged = []
    for tier, tid, targets, laws in entries:
        for target in targets:
            cells = {}
            for lname, lhs in laws:
                for args in applications(lhs, target):
                    for pos, arg in enumerate(args):
                        cells.setdefault(pos, []).append((lname, arg, is_closed(arg)))
            for pos, obs in sorted(cells.items()):
                if all(c for _, _, c in obs) and len(obs) >= 1:
                    flagged.append((tier, tid, target, pos, obs))

    print(f"tasks scanned: {len(entries)}")
    print(f"flagged (target, position) cells: {len(flagged)}")
    print(f"tasks with at least one flagged cell: "
          f"{len({f[1] for f in flagged})}")
    print()
    for tier, tid, target, pos, obs in sorted(flagged):
        vals = ", ".join(f"{a} ({l})" for l, a, _ in obs)
        print(f"t{tier} {tid:26s} {target}(arg{pos}) seen only at: {vals}")
    return 0


# --------------------------------------------------------------------------
# Screen 2: no single law applies a target with every argument open
# --------------------------------------------------------------------------

def args_of(s, i):
    """The top-level comma-split arguments of the call starting at s[i] == '('."""
    depth, out, cur = 0, [], ""
    j = i
    while j < len(s):
        c = s[j]
        if c in "({[":
            depth += 1
            if depth == 1:
                j += 1
                continue
        elif c in ")}]":
            depth -= 1
            if depth == 0:
                out.append(cur.strip())
                return out, j
        if c == "," and depth == 1:
            out.append(cur.strip())
            cur = ""
        else:
            cur += c
        j += 1
    return out, j


def goal_blocks(src):
    """Every top-level `{ ... : Type}` block, premises and goals alike."""
    out, depth, start = [], 0, None
    for i, c in enumerate(src):
        if c == "{":
            if depth == 0:
                start = i
            depth += 1
        elif c == "}":
            depth -= 1
            if depth == 0:
                out.append(src[start:i + 1])
    return out


def is_literal(term):
    # The lookbehind matters: without it the `il` inside `Nil{}` reads as a
    # variable, every constructor counts as open, and the screen flags nothing.
    return not re.search(r"(?<![A-Za-z0-9_])[a-z_][A-Za-z0-9_]*", NUM.sub("", term))


def lhs_calls(goal):
    """(target, [args]) for every `S.x(...)` on the left of the first top-level ==."""
    depth = 0
    cut = len(goal)
    for i, c in enumerate(goal):
        if c in "({[":
            depth += 1
        elif c in ")}]":
            depth -= 1
        elif c == "=" and depth == 1 and goal[i:i + 2] == "==":
            cut = i
            break
    lhs = goal[:cut]
    out = []
    for m in re.finditer(r"\bS\.([A-Za-z_][\w]*)\s*\(", lhs):
        args, _ = args_of(lhs, m.end() - 1)
        out.append((m.group(1), args))
    return out


def general(ids, manifest_path=None):
    """Position-wise screening cannot see the t2-chunks-laws shape: `chunks`
    arg0 was observed open by `chunks_zero` and arg1 open by `chunks_nil`, so no
    cell flagged, while *no single law* reached the recursive branch with every
    argument non-literal.

    This screen asks the sharper question: for each target the policy must
    write, is there **one** law whose left-hand side applies it with every
    argument non-literal? An argument counts as literal when it carries no
    variable at all (`0n`, `Nil{}`, `1n <> (2n <> Nil{})`, `True{}`), and as
    open otherwise (`xs`, `1n + n`, `x <> Nil{}`, `Nat.double(n)`). A target
    with no such law is flagged.

    Known false positives, all four triaged on 2026-09-19:
      - a finite type whose every constructor is named (`Bool` with `True{}` and
        `False{}`) is pinned by literal laws, and this screen cannot tell that
        from an unpinned interior;
      - a target reached only through a wrapper the law set *does* govern
        generally.
    Read the printout; do not treat a flag as a hole.
    """
    man = json.loads(Path(manifest_path).read_text() if manifest_path
                     else (ROOT / "manifest.json").read_text())
    rows = [t for t in man["tasks"] if not ids or t["task_id"] in ids]
    flagged = 0
    for t in rows:
        tid = t["task_id"]
        laws_src = (ROOT / t["path"] / "LAWS.bend").read_text()
        stub = (ROOT / t["path"] / "solution.bend").read_text()
        targets = [m.group(1) for m in re.finditer(r"^def\s+([A-Za-z_][\w]*)\s*\(", stub, re.M)]
        if not targets:
            continue
        reached = {x: [] for x in targets}
        for block in goal_blocks(laws_src):
            for target, args in lhs_calls(block):
                if target not in reached or not args:
                    continue
                if all(not is_literal(a) for a in args):
                    reached[target].append(block.strip()[:60])
        bad = [x for x in targets if not reached[x]]
        if bad:
            flagged += 1
            print(f"{tid}  (tier {t['tier']})  targets with no general law: {bad}")
            for x in bad:
                seen = set()
                for block in goal_blocks(laws_src):
                    for target, args in lhs_calls(block):
                        if target == x:
                            sig = f"{x}({', '.join(args)})"
                            if sig not in seen:
                                seen.add(sig)
                                print(f"      seen only: {sig}")
    print(f"\ntasks scanned: {len(rows)}   flagged tasks: {flagged}")
    return 0


# --------------------------------------------------------------------------
# Screen 3: static checks for an unpublished batch
# --------------------------------------------------------------------------

def batch(ids, manifest_path=None):
    """Stub vs reference and distinctness, with no checker runs.

    The escape, thin-corpus and zero-kill readings come from `tools.validate`
    against a scratch manifest, which needs the box to itself.

    An unpublished task is looked up in `manifest_path` if given, and otherwise
    in every `manifest.scratch.*.json` in the repo root. Those scratch manifests
    are untracked, so a fresh clone needs the path.
    """
    manifest = json.loads((ROOT / "manifest.json").read_text())
    bank = {t["task_id"]: t for t in manifest["tasks"]}
    bank_sigs = {k: sigs(ROOT / t["path"] / "solution.bend") for k, t in bank.items()}
    cfgs = ([Path(manifest_path)] if manifest_path
            else sorted(ROOT.glob("manifest.scratch.*.json")))
    pending = {}
    for cfg in cfgs:
        for t in json.loads(cfg.read_text())["tasks"]:
            pending[t["task_id"]] = t
    bad = 0
    for tid in ids:
        row = pending.get(tid)
        if row is None:
            print(f"  {tid}: NOT IN ANY SCRATCH MANIFEST")
            bad += 1
            continue
        stub = ROOT / row["path"] / "solution.bend"
        ref = ROOT / row["reference"] / "solution.bend"
        src, rsrc = stub.read_text(), ref.read_text()
        problems = []
        if "?" not in src:
            problems.append("stub has no hole marker")
        if src.strip() == rsrc.strip():
            problems.append("STUB SHIPS THE REFERENCE")
        s = sigs(stub)
        if not s:
            problems.append("stub declares no defs")
        for other, other_s in bank_sigs.items():
            if other_s and set(other_s) == set(s) and other.rsplit("-", 1)[0] != tid.rsplit("-", 1)[0]:
                same = all(other_s[k] == s[k] for k in s)
                if same and len(other_s) == len(s):
                    problems.append(f"function set collides with {other}: {sorted(s)}")
        nmut = len(list((ROOT / row["reference"] / "mutants").glob("*.bend")))
        if nmut < 2:
            problems.append(f"corpus thin: {nmut} mutants")
        if problems:
            bad += 1
        print(f"  {'OK ' if not problems else 'BAD'} {tid:22s} "
              f"laws={len(list((ROOT / row['path']).glob('LAWS.bend')))} "
              f"defs={sorted(s)} mutants={nmut}")
        for p in problems:
            print(f"        - {p}")
    print(f"\n{len(ids) - bad}/{len(ids)} clean")
    return 1 if bad else 0


def main(argv):
    if not argv or argv[0] not in ("positions", "general", "batch"):
        print(__doc__)
        return 2
    which, ids = argv[0], argv[1:]
    if which == "positions":
        return positions(ids)
    manifest_path = ids.pop(0) if ids and ids[0].endswith(".json") else None
    if which == "batch" and not ids:
        print("batch needs at least one task id")
        return 2
    return {"general": general, "batch": batch}[which](ids, manifest_path)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
