"""Break a reference solution in rule-shaped ways, and record what it costs.

    uv run python -m tools.mutate t1-add-plus            # write the mutants
    uv run python -m tools.mutate t1-add-plus --check    # and run them
    uv run python -m tools.mutate --check                # the whole bank

A mutant is V2's evidence. The point of V2 is not that *something* about a
mutant fails -- a mutant with a coverage error fails at tier 1 and proves
nothing about the law -- but that a mutant which still type-checks cannot
satisfy the law. Those are the **strong** mutants, and a task with none of them
has laws that constrain nothing.

So each mutant is labelled with the tier it reaches:

    tier 4   the law is too weak to catch a wrong solution -- a task defect
    tier 2-3 strong: it type-checks and the law rejects it
    tier 0-1 weak: it does not type-check, so the law was never exercised
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass, replace
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from gavel.check import CheckConfig  # noqa: E402
from gavel.tasks import load_manifest  # noqa: E402
from gavel.toolchain import DEFAULT_VERSION, Toolchain  # noqa: E402
from gavel.validate import mutant_verdicts  # noqa: E402
from gavel.verdict import TIER_COMPLETE, TIER_NO_CHECK  # noqa: E402

REPO_ROOT = Path(__file__).resolve().parent.parent

_CASE = re.compile(r"^(\s*)case\s+(.*?)\s*:\s*$")
_DEF = re.compile(r"^def\s+([A-Za-z_][\w.]*)\s*\(([^)]*)\)\s*->\s*([^:]+):\s*$")
_MATCH = re.compile(r"^(\s*)match\s+(.*?)\s*:\s*$")


@dataclass(frozen=True)
class Mutant:
    name: str
    rule: str
    source: str
    strong: bool          # intended to still type-check
    note: str = ""


def _indent(line: str) -> int:
    return len(line) - len(line.lstrip())


def _blocks(lines: list[str], header: re.Pattern) -> list[tuple[int, int, re.Match]]:
    """``(header_index, body_end, match)`` for every match of ``header``.

    Bodies are delimited by indentation rather than by braces, which is what
    the language does too: a block runs until a non-blank line's indentation
    drops back to the header's own.
    """
    out = []
    for i, line in enumerate(lines):
        found = header.match(line)
        if not found:
            continue
        base = _indent(line)
        end = i + 1
        while end < len(lines):
            candidate = lines[end]
            if candidate.strip() and _indent(candidate) <= base:
                break
            end += 1
        out.append((i, end, found))
    return out


def _cases(lines: list[str], start: int, end: int) -> list[tuple[int, int]]:
    """``(case_index, case_body_end)`` for the cases of the match at ``start``.

    Only the *direct* cases. A match inside a case body is a different match,
    and its cases are indented deeper -- reading them here would mutate them
    with this match's subject, which is not the construct the rule thinks it is
    looking at. Cost of getting that wrong, measured: `drop(n: Nat, xs: ...)`
    produced one mutant replacing the inner tail with `xs` and a second
    replacing it with the *outer* subject `n`, both named after the same line.
    """
    found = [i for i in range(start, end) if _CASE.match(lines[i])]
    if not found:
        return []
    # The direct cases are the shallowest ones in the range: a nested match is
    # always indented past its parent's cases.
    depth = min(_indent(lines[i]) for i in found)
    out = []
    for i in found:
        if _indent(lines[i]) != depth:
            continue
        base = depth
        body_end = i + 1
        while body_end < end:
            candidate = lines[body_end]
            if candidate.strip() and _indent(candidate) <= base:
                break
            body_end += 1
        out.append((i, body_end))
    return out


def _join(lines: list[str]) -> str:
    return "\n".join(lines).rstrip("\n") + "\n"


def _replace(lines: list[str], start: int, end: int, new: list[str]) -> str:
    return _join(lines[:start] + new + lines[end:])


# --- rules ----------------------------------------------------------------------
# Each takes the def name, its parameter names, and the source lines, and yields
# mutants. A rule that does not apply yields nothing rather than guessing.

def rule_swap_case_bodies(name, params, lines) -> list[Mutant]:
    """Keep the patterns, swap which answer each one gives."""
    out = []
    for i, end, _ in _blocks(lines, _MATCH):
        cases = _cases(lines, i, end)
        if len(cases) < 2:
            continue
        first_head, first_body, last_head, last_body = (
            lines[cases[0][0]:cases[0][0] + 1], lines[cases[0][0] + 1:cases[0][1]],
            lines[cases[-1][0]:cases[-1][0] + 1], lines[cases[-1][0] + 1:cases[-1][1]])
        if not first_body or not last_body:
            continue
        rebuilt = (first_head + last_body
                   + lines[cases[0][1]:cases[-1][0]]
                   + last_head + first_body)
        out.append(Mutant(f"{name}-swap-case-bodies-{i}", "swap-case-bodies",
                          _replace(lines, cases[0][0], cases[-1][1], rebuilt),
                          strong=True))
    return out


def rule_drop_last_case(name, params, lines) -> list[Mutant]:
    """An incomplete match: a weak mutant, caught before any law is consulted."""
    out = []
    for i, end, _ in _blocks(lines, _MATCH):
        cases = _cases(lines, i, end)
        if len(cases) < 2:
            continue
        out.append(Mutant(f"{name}-drop-last-case-{i}", "drop-last-case",
                          _replace(lines, cases[-1][0], cases[-1][1], []),
                          strong=False))
    return out


def rule_nat_base_off_by_one(name, params, lines) -> list[Mutant]:
    """`case 0n:` -> `case 1n:`: the zero case is simply not handled."""
    out = []
    for i, end, _ in _blocks(lines, _MATCH):
        for start, body_end in _cases(lines, i, end):
            if not re.match(r"^\s*case\s+0n\s*:\s*$", lines[start]):
                continue
            mutated = list(lines)
            mutated[start] = lines[start].replace("0n", "1n")
            if mutated != lines:
                out.append(Mutant(f"{name}-nat-base-off-by-one-{start}",
                                  "nat-base-off-by-one",
                                  _join(mutated),
                                  strong=False))
    return out


def rule_tail_to_whole(name, params, lines) -> list[Mutant]:
    """Recurse on the whole list instead of the tail: right shape, no progress.

    The tail variable lives in the *case pattern* (`case h <> t:`) while the
    thing it gets replaced by is the match's *subject* (`match xs:`). Reading
    the pattern off the subject instead is why this rule silently produced
    nothing the first time it was written.
    """
    out = []
    for i, end, found in _blocks(lines, _MATCH):
        subject = found.group(2).strip()
        for start, body_end in _cases(lines, i, end):
            head = _CASE.match(lines[start])
            if head is None:
                continue
            tail = re.search(r"<>\s*([A-Za-z_]\w*)", head.group(2))
            if not tail or tail.group(1) == subject:
                continue
            mutated = list(lines)
            for j in range(start + 1, body_end):
                mutated[j] = re.sub(rf"\b{re.escape(tail.group(1))}\b", subject,
                                    mutated[j])
            if mutated != lines:
                out.append(Mutant(f"{name}-tail-to-whole-{start}", "tail-to-whole",
                                  _join(mutated),
                                  strong=True))
    return out


def rule_swap_call_arguments(name, params, lines) -> list[Mutant]:
    """`f(a, b)` -> `f(b, a)` wherever both are plain names."""
    out = []
    call = re.compile(r"\b(\w+)\(([^()]*)\)")
    for i, line in enumerate(lines):
        for found in call.finditer(line):
            args = [a.strip() for a in found.group(2).split(",")]
            if len(args) != 2 or not all(re.fullmatch(r"[A-Za-z_]\w*", a) for a in args):
                continue
            swapped = f"{found.group(1)}({args[1]}, {args[0]})"
            mutated = list(lines)
            mutated[i] = line[:found.start()] + swapped + line[found.end():]
            out.append(Mutant(f"{name}-swap-args-{i}", "swap-call-arguments",
                              _join(mutated), strong=True))
    return out


def rule_recursion_to_parameter(name, params, lines) -> list[Mutant]:
    """Call the function on an argument it was not recursing on."""
    out = []
    if not params:
        return out
    call = re.compile(rf"\b{re.escape(name)}\(([^()]*)\)")
    for i, line in enumerate(lines):
        for found in call.finditer(line):
            args = [a.strip() for a in found.group(1).split(",")]
            if not args or any(not re.fullmatch(r"[A-Za-z_]\w*", a) for a in args):
                continue
            for which in range(len(args)):
                if args[which] == params[0]:
                    continue
                replaced = list(args)
                replaced[which] = params[0]
                mutated = list(lines)
                mutated[i] = (line[:found.start()]
                              + f"{name}({', '.join(replaced)})"
                              + line[found.end():])
                out.append(Mutant(
                    f"{name}-recursion-arg{which}-to-param-{i}",
                    "recursion-to-parameter",
                    _join(mutated), strong=True))
    return out


def rule_constant_body(name, params, lines) -> list[Mutant]:
    """Return the base case's answer for every input."""
    out = []
    for i, end, _ in _blocks(lines, _MATCH):
        cases = _cases(lines, i, end)
        if len(cases) < 2:
            continue
        base = lines[cases[0][0] + 1:cases[0][1]]
        if not base:
            continue
        rebuilt = []
        for start, body_end in cases:
            rebuilt.append(lines[start])
            rebuilt.extend(base)
        out.append(Mutant(f"{name}-constant-body-{i}", "constant-body",
                          _replace(lines, cases[0][0], cases[-1][1], rebuilt),
                          strong=True))
    return out


# Reordering disjoint match cases is deliberately absent: Nat and List patterns
# do not overlap, so swapping two cases yields the same function and a mutant
# that proves nothing. It was the first rule written and the first to escape.
RULES = (rule_swap_case_bodies, rule_constant_body,
         rule_tail_to_whole, rule_swap_call_arguments,
         rule_recursion_to_parameter, rule_drop_last_case,
         rule_nat_base_off_by_one)


def mutants_of(src: str) -> list[Mutant]:
    """Every mutant of every def in ``src``.

    Defs under ``Policy.`` are left alone: they are the task's own helpers, not
    the solution being tested.
    """
    lines = src.split("\n")
    out: list[Mutant] = []
    for i, end, found in _blocks(lines, _DEF):
        def_name = found.group(1)
        if def_name.startswith("Policy."):
            continue
        params = [p.split(":")[0].strip() for p in found.group(2).split(",") if p.strip()]
        head = lines[:i]
        tail = lines[end:]
        body = lines[i:end]
        for rule in RULES:
            for mutant in rule(def_name, params, body):
                source = "\n".join(head + mutant.source.split("\n") + tail)
                # A rule that dropped the def entirely would produce a file
                # that fails to check for a reason unrelated to the law, and
                # V2 would count it as a caught mutant. Three rules did exactly
                # that before this guard existed.
                if f"def {def_name}(" not in source:
                    continue
                out.append(Mutant(mutant.name, mutant.rule, source, mutant.strong))
    return _unique_names(out)


def _unique_names(mutants: list[Mutant]) -> list[Mutant]:
    """A mutant's name is its filename, so two of them are one file.

    ``write_mutants`` clears the directory and writes one file per mutant, so a
    collision does not fail -- it loses whichever the other overwrote, and the
    report still says both were written. The corpus V2 measures is then thinner
    than the tool claims, and if the lost mutant was the strong one the task
    looks better guarded than it is. Suffixing is the cheap fix; the nesting
    bug that caused the first collision is fixed at its source, and this is what
    keeps the next one from being silent.
    """
    seen: dict[str, int] = {}
    out: list[Mutant] = []
    for mutant in mutants:
        seen[mutant.name] = seen.get(mutant.name, 0) + 1
        count = seen[mutant.name]
        out.append(mutant if count == 1 else
                   replace(mutant, name=f"{mutant.name}-{count}"))
    return out


# --- the driver -----------------------------------------------------------------

def dedupe(mutants: list[Mutant], reference: str) -> list[Mutant]:
    """Drop duplicates, and drop anything that is just the reference again."""
    seen = {reference.strip()}
    out = []
    for mutant in mutants:
        key = mutant.source.strip()
        if key in seen:
            continue
        seen.add(key)
        out.append(mutant)
    return out


def write_mutants(task, mutants: list[Mutant]) -> list[Path]:
    dest = task.references / "mutants"
    dest.mkdir(exist_ok=True)
    for stale in dest.glob("*.bend"):
        stale.unlink()
    written = []
    for mutant in mutants:
        path = dest / f"{mutant.name}.bend"
        path.write_text(mutant.source)
        written.append(path)
    return written


def check_mutants(task, toolchain, mutants: list[Mutant]) -> list[dict]:
    """Run each mutant twice: against the reference proof, and alone.

    The tier against the reference proof says whether the task's laws catch it.
    The tier *without* a proof says whether it still type-checks -- which is
    what makes the first number evidence about a law. A mutant that fails to
    type-check would fail the reference proof anyway, and for the wrong reason.
    """
    reports = []
    for mutant in mutants:
        against_proof, bare = mutant_verdicts(task, toolchain, mutant.source,
                                              CheckConfig())
        reports.append({
            "name": mutant.name,
            "rule": mutant.rule,
            "intended_strong": mutant.strong,
            "tier": against_proof.tier,
            "tier_name": against_proof.tier_name,
            "caught": against_proof.tier != TIER_COMPLETE,
            "type_checks": bare.tier > TIER_NO_CHECK,
            "strong": (against_proof.tier != TIER_COMPLETE
                       and bare.tier > TIER_NO_CHECK),
            "proven": list(against_proof.proven),
        })
    return reports


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("tasks", nargs="*", help="task ids; default is all")
    parser.add_argument("--manifest", default=str(REPO_ROOT / "manifest.json"))
    parser.add_argument("--check", action="store_true",
                        help="run each mutant against the reference proof")
    parser.add_argument("--json", action="store_true")
    parser.add_argument("--quiet", action="store_true")
    args = parser.parse_args(argv)

    manifest = load_manifest(Path(args.manifest))
    tasks = [manifest.get(name) for name in args.tasks] if args.tasks else list(manifest)
    toolchain = Toolchain.load(manifest.bend_version or DEFAULT_VERSION) if args.check else None

    report: dict = {"tasks": {}}
    exit_code = 0
    for task in tasks:
        mutants = dedupe(mutants_of(task.reference_solution), task.reference_solution)
        paths = write_mutants(task, mutants)
        entry: dict = {"written": len(paths), "mutants": []}
        if args.check:
            entry["mutants"] = check_mutants(task, toolchain, mutants)
            strong = [m for m in entry["mutants"] if m["strong"]]
            escaped = [m for m in entry["mutants"] if not m["caught"]]
            entry["strong"] = len(strong)
            entry["escaped"] = [m["name"] for m in escaped]
            entry["weak"] = len(entry["mutants"]) - len(strong) - len(escaped)
            if escaped or not strong:
                exit_code = 1
            if not args.json and not args.quiet:
                verdict = "FAIL" if escaped or not strong else "ok  "
                print(f"[{verdict}] {task.task_id:24s} {len(entry['mutants'])} mutants: "
                      f"{len(strong)} strong, {entry['weak']} weak, "
                      f"{len(escaped)} escaped")
                for m in escaped:
                    print(f"    escaped (tier {m['tier']}): {m['name']} "
                          f"via {m['rule']}")
        elif not args.json and not args.quiet:
            print(f"[ok  ] {task.task_id:24s} {len(paths)} mutants written")
        report["tasks"][task.task_id] = entry

    if args.json:
        print(json.dumps(report, indent=2))
    else:
        total = sum(t["written"] for t in report["tasks"].values())
        print(f"\n{total} mutant file(s) over {len(tasks)} task(s)")
    return exit_code


if __name__ == "__main__":
    raise SystemExit(main())
