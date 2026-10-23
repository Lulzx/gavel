"""Check problem statements, and evaluate terms against a task's reference.

    uv run python -m tools.prompts check                    # every task
    uv run python -m tools.prompts check t2-sum-prefix-laws
    uv run python -m tools.prompts eval t2-sum-prefix-laws "S.sum_prefix(2n, [4n, 1n, 7n])"

``check`` is the prompt contract validation enforces (``_posed`` in
``gavel/validate.py``): every law named, any stated law count right, no line of
the reference body, no proof strategy. It also evaluates the prompt's worked
examples. An indented line of the form ``f(args) == value``, with ``f`` one of
the task's targets, is run against the reference with one checker run per task,
and an example the reference disagrees with is reported. An example is the one
part of a statement a policy will take literally.

``eval`` prints the reference's value for each term, with ``S`` the reference
and ``P`` the prelude, for writing those examples in the first place.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from gavel.degenerate import signatures  # noqa: E402
from gavel.ground import GROUND_LIMITS, _spell, parse_output, split_top  # noqa: E402
from gavel.runner import run_check  # noqa: E402
from gavel.tasks import PRELUDE_FILE, SOLUTION_FILE, cleanup, load_manifest, prepare_workdir  # noqa: E402
from gavel.toolchain import DEFAULT_VERSION, Toolchain  # noqa: E402
from gavel.validate import TaskReport, _posed  # noqa: E402

REPO_ROOT = Path(__file__).resolve().parent.parent
BOOK = "EXAMPLES.bend"

_EXAMPLE = re.compile(r"^ {4,}([A-Za-z_]\w*)\((.*)\)\s*==\s*(.+?)\s*$")


def examples(task) -> list[tuple[str, str, str]]:
    """``(call, expected, return type)`` for each worked example in the prompt."""
    returns = {name: ret for name, _, ret in signatures(task.stub_src)}
    out = []
    for line in task.prompt.splitlines():
        found = _EXAMPLE.match(line)
        if found and found.group(1) in returns:
            call = f"S.{found.group(1)}({found.group(2)})"
            out.append((call, found.group(3), returns[found.group(1)]))
    return out


def evaluate(task, toolchain, terms: list[tuple[str, str]]) -> list[str] | str:
    """Values of ``(term, type)`` under the reference, or the checker's error."""
    if not terms:
        return []
    flipped: set[int] = set()
    workdir = prepare_workdir(task, {SOLUTION_FILE: task.reference_solution})
    try:
        # The same respelling search as ``gavel.ground.evaluate``: a list level
        # the checker refuses inside one of our defs is ours to change.
        for _ in range(len(terms) + 1):
            (Path(workdir) / BOOK).write_text(_book(task, terms, flipped))
            result = run_check(toolchain, workdir, BOOK, GROUND_LIMITS)
            where = re.fullmatch(r"G\.c(\d+)", result.error_location or "")
            if (result.exit_code == 0 or where is None or "List<" not in result.stderr
                    or int(where.group(1)) in flipped):
                break
            flipped.add(int(where.group(1)))
    finally:
        cleanup(workdir)
    rows = parse_output(result.stdout, len(terms)) if result.exit_code == 0 else None
    if rows is None:
        return " ".join((result.stderr or result.stdout).split())[:300]
    return [row[0] if row else "" for row in rows]


def _book(task, terms: list[tuple[str, str]], flipped: set[int]) -> str:
    header = ["import Base"]
    if task.prelude_src.strip():
        header.append(f"import ./{PRELUDE_FILE} as P")
    header += [f"import ./{SOLUTION_FILE} as S", ""]
    lines, types = header, []
    for k, (term, typ) in enumerate(terms):
        spelled = _spell(typ, k in flipped)
        types.append(spelled)
        lines += [f"def G.c{k}() -> {spelled}:", f"  [{term}]", ""]
    typ, term = types[-1], f"G.c{len(types) - 1}()"
    for k in range(len(types) - 2, -1, -1):
        typ, term = f"({types[k]} & {typ})", f"(G.c{k}(), {term})"
    return "\n".join(lines + [f"def main() -> {typ}:", f"  {term}", ""])


def check(task, toolchain) -> list[str]:
    report = TaskReport(task_id=task.task_id, tier=task.tier, laws=task.laws, hash="")
    _posed(task, report)
    problems = list(report.problems)
    found = examples(task)
    if found:
        # Each example is evaluated twice over: the call, and the value the
        # prompt claims, so `[4n, 1n]` and `4n <> 1n <> Nil{}` compare equal.
        terms = []
        for call, expected, typ in found:
            terms += [(call, typ), (expected, typ)]
        values = evaluate(task, toolchain, terms)
        if isinstance(values, str):
            problems.append(f"examples: could not evaluate them: {values}")
        else:
            for k, (call, expected, _) in enumerate(found):
                got, want = values[2 * k], values[2 * k + 1]
                if got != want:
                    problems.append(f"examples: {call[2:]} is {got}, "
                                    f"and the prompt says {expected}")
    return problems


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--manifest", default=str(REPO_ROOT / "manifest.json"))
    sub = parser.add_subparsers(dest="cmd", required=True)
    p_check = sub.add_parser("check")
    p_check.add_argument("tasks", nargs="*")
    p_eval = sub.add_parser("eval")
    p_eval.add_argument("task")
    p_eval.add_argument("terms", nargs="+", help="Bend terms; S is the reference")
    p_eval.add_argument("--type", default=None,
                        help="the terms' type (default: the first target's return type)")
    args = parser.parse_args(argv)

    manifest = load_manifest(Path(args.manifest))
    toolchain = Toolchain.load(manifest.bend_version or DEFAULT_VERSION)

    if args.cmd == "eval":
        task = manifest.get(args.task)
        typ = args.type or signatures(task.stub_src)[0][2]
        values = evaluate(task, toolchain, [(t, typ) for t in args.terms])
        if isinstance(values, str):
            print(values, file=sys.stderr)
            return 1
        for term, value in zip(args.terms, values):
            print(f"{term} = {value}")
        return 0

    tasks = [manifest.get(t) for t in args.tasks] if args.tasks else list(manifest)
    failed = 0
    for task in tasks:
        problems = check(task, toolchain)
        n = len(examples(task))
        print(f"[{'FAIL' if problems else 'ok  '}] {task.task_id:28s} "
              f"{n} example(s) checked")
        for problem in problems:
            print(f"        {problem}")
        failed += bool(problems)
    print(f"\n{len(tasks) - failed}/{len(tasks)} prompts meet the contract")
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
