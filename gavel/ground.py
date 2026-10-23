"""Laws evaluated at points: does a law set reject a body, with no proof involved.

V2 asks whether a mutant fails the *reference proof*, and that conflates two
answers. A mutant the laws reject fails it, and so does a mutant the laws accept
but whose shape the reference proof does not fit -- a proof that rewrites a
subterm the reference body *is* cannot be replayed on any other body. The
second kind reads as a kill and is a hole: a policy that writes that body and
its own proof is paid in full for a function nobody asked for.
``t3-absdiff-comm``'s fifth law exists because one such body was found by hand.

This module answers the question V2 meant to ask, mechanically and without a
proof. Every law is instantiated at small closed values, and so is every
function the laws cite. One checker run evaluates all of it (``main.ts`` checks
the book and then prints ``main``'s normal form), and the comparison is done
here on the printed values:

    rejected     some instance of some law is false for the body
    hole         every instance holds, and the body differs from the reference
    equivalent   every instance holds, and it agrees with the reference
    unevaluable  the body does not type-check, or evaluation failed

A ``hole`` is a witness, not a suspicion: the instances the body satisfied and
the input it disagrees on are both in the report. ``equivalent`` is the honest
non-answer -- within the bound the body *is* the reference, so it says nothing
about the laws either way. ``rejected`` is a bounded claim: no instance
outside the grid was tried, and that is the price of not needing a proof.
"""

from __future__ import annotations

import random
import re
import zlib
from dataclasses import dataclass, field
from itertools import product
from math import prod
from pathlib import Path

from .degenerate import signatures
from .laws import split_top_level
from .runner import Limits, run_check, select_backend
from .tasks import PRELUDE_FILE, SOLUTION_FILE, Task, cleanup, prepare_workdir
from .toolchain import Toolchain

GROUND_FILE = "GROUND.bend"
REFERENCE_FILE = "reference.bend"

# Nat is unary, so a value is as expensive as it is large. Small enough that a
# law over three Nats stays cheap; large enough that 0, 1 and "more than one"
# are all present, which is where the bank's holes have been.
NAT_MAX = 3
LIST_MAX = 3
ADT_DEPTH = 2
# Instances per law, and inputs per cited function. Past this the product is
# sampled, smallest corners first, with a seed taken from the law's name so a
# report is reproducible.
INSTANCE_CAP = 48

GROUND_LIMITS = Limits(wall_ms=30_000, cpu_seconds=60, output_bytes=4 * 1024 ** 2)

_OPEN, _CLOSE = "([{", ")]}"


# --- types ----------------------------------------------------------------------

@dataclass(frozen=True)
class Ty:
    kind: str                 # nat | bool | list | adt
    arg: "Ty | None" = None   # the element type of a list
    name: str = ""            # an adt's name, as the law spells it (P.Tree)


@dataclass(frozen=True)
class Ctor:
    name: str
    fields: tuple[str, ...]   # field types, as written


def prelude_types(src: str) -> dict[str, list[Ctor]]:
    """``type Name is Data:`` blocks from the prelude, by unqualified name.

    A parameterised type is skipped: its values depend on an argument this
    module has no way to choose.
    """
    out: dict[str, list[Ctor]] = {}
    current: list[Ctor] | None = None
    for line in src.splitlines():
        head = re.match(r"^type\s+([A-Za-z_][\w.]*)\s+is\s+Data\s*:", line)
        if head:
            current = out.setdefault(head.group(1), [])
            continue
        if current is None:
            continue
        if line and not line[0].isspace():
            current = None
            continue
        ctor = re.match(r"^\s+([A-Za-z_]\w*)\{(.*)\}\s*$", line)
        if ctor:
            fields = tuple(part.split(":", 1)[1].strip()
                           for part in split_top(ctor.group(2)) if ":" in part)
            current.append(Ctor(ctor.group(1), fields))
    return out


def parse_type(text: str, adts: dict[str, list[Ctor]]) -> Ty | None:
    text = text.strip()
    if text == "Nat":
        return Ty("nat")
    if text == "Bool":
        return Ty("bool")
    found = re.fullmatch(r"List<\s*(?:&\d+\s*,\s*)?(.*)>", text)
    if found:
        inner = parse_type(found.group(1), adts)
        return Ty("list", arg=inner) if inner else None
    bare = text[2:] if text.startswith("P.") else text
    if bare in adts and adts[bare]:
        return Ty("adt", name="P." + bare)
    return None


def values(ty: Ty, adts: dict[str, list[Ctor]], depth: int = ADT_DEPTH) -> list[str]:
    """Closed terms of ``ty``, smallest first."""
    if ty.kind == "nat":
        return [f"{n}n" for n in range(NAT_MAX + 1)]
    if ty.kind == "bool":
        return ["False{}", "True{}"]
    if ty.kind == "list":
        elems = values(ty.arg, adts, max(depth - 1, 0))[:3]
        out = ["Nil{}"]
        for length in range(1, LIST_MAX + 1):
            for combo in product(elems, repeat=length):
                term = "Nil{}"
                for elem in reversed(combo):
                    term = f"({elem} <> {term})"
                out.append(term)
        return out
    return _adt_values(ty.name, adts, depth)


def _adt_values(name: str, adts: dict[str, list[Ctor]], depth: int) -> list[str]:
    ctors = adts[name[2:]]
    out: list[str] = []
    for ctor in ctors:
        domains = []
        for typ in ctor.fields:
            sub = parse_type(typ, adts)
            if sub is None:
                domains = None
                break
            recursive = sub.kind == "adt" or (sub.kind == "list" and sub.arg
                                              and sub.arg.kind == "adt")
            if recursive and depth == 0:
                domains = None
                break
            dom = values(sub, adts, depth - 1 if recursive else depth)
            # Field values are kept small: a tree of depth two with a field
            # domain of four is already hundreds of values.
            domains.append(dom[:3] if sub.kind == "nat" else dom[:4])
        if domains is None:
            continue
        for combo in product(*domains):
            out.append(f"P.{ctor.name}{{{', '.join(combo)}}}")
    return sorted(set(out), key=lambda term: (len(term), term))


# --- laws -----------------------------------------------------------------------

@dataclass(frozen=True)
class Equation:
    lhs: str
    rhs: str
    typ: str


@dataclass(frozen=True)
class Law:
    name: str
    data: tuple[tuple[str, str], ...]        # (binder, type) for value binders
    hyps: tuple[Equation, ...]                # equality-typed binders
    goal: Equation


def split_top(text: str, sep: str = ",") -> list[str]:
    """Split on ``sep`` where no bracket is open. ``<`` is not a bracket: the
    cons operator is ``<>``."""
    out, depth, start = [], 0, 0
    i = 0
    while i < len(text):
        char = text[i]
        if char in _OPEN:
            depth += 1
        elif char in _CLOSE:
            depth -= 1
        elif depth == 0 and text.startswith(sep, i):
            out.append(text[start:i])
            start = i + len(sep)
            i = start
            continue
        i += 1
    out.append(text[start:])
    return [part.strip() for part in out if part.strip()]


def parse_equation(text: str) -> Equation | None:
    """``{lhs == rhs : T}`` -> Equation. ``None`` for anything else."""
    text = text.strip()
    if not (text.startswith("{") and text.endswith("}")):
        return None
    inner = text[1:-1]
    sides = split_top(inner, "==")
    if len(sides) != 2:
        return None
    lhs, rest = sides
    parts = split_top(rest, ":")
    if len(parts) < 2:
        return None
    return Equation(lhs, ":".join(parts[:-1]).strip(), parts[-1])


def _strip_comments(text: str) -> str:
    return "\n".join(line.split("#", 1)[0].rstrip() for line in text.splitlines())


def parse_laws(src: str) -> tuple[list[Law], list[str]]:
    """The task's laws, and the names of those this module cannot read."""
    laws, unread = [], []
    for chunk in split_top_level(src):
        if chunk.kind != "law":
            continue
        body = _strip_comments(chunk.text).split(":", 1)[1]
        data, hyps, goal = [], [], None
        rest = " ".join(body.split())
        ok = True
        while rest.startswith("for "):
            end = _binder_end(rest)
            binder = rest[len("for "):end]
            rest = rest[end:].strip()
            name, _, typ = binder.partition(":")
            name, typ = name.strip().lstrip("+-"), typ.strip()
            if typ.startswith("{"):
                hyp = parse_equation(typ)
                if hyp is None:
                    ok = False
                    break
                hyps.append(hyp)
            else:
                data.append((name, typ))
        goal = parse_equation(rest) if ok else None
        if goal is None:
            unread.append(chunk.name)
            continue
        laws.append(Law(chunk.name, tuple(data), tuple(hyps), goal))
    return laws, unread


def _binder_end(text: str) -> int:
    """Where the ``for`` binder at the start of ``text`` ends.

    ``text`` has its whitespace collapsed, because the bank writes binders one
    per line and also all on the law's own line. A binder's type ends where the
    next ``for`` or the goal's ``{`` begins at depth zero; an equality-typed
    binder is itself a ``{...}`` and ends at its close.
    """
    colon = text.find(":")
    if colon < 0:
        return len(text)
    start = colon + 1
    while start < len(text) and text[start] == " ":
        start += 1
    depth = 0
    for i in range(start, len(text)):
        char = text[i]
        if char in _OPEN:
            if depth == 0 and char == "{" and i > start:
                return i
            depth += 1
        elif char in _CLOSE:
            depth -= 1
            if depth == 0 and char == "}" and text[start] == "{":
                return i + 1
        elif depth == 0 and text.startswith(" for ", i):
            return i
    return len(text)


def substitute(term: str, binding: dict[str, str]) -> str:
    if not binding:
        return term
    pattern = re.compile(r"(?<![\w.])(" + "|".join(map(re.escape, binding))
                         + r")(?![\w])")
    return pattern.sub(lambda m: f"({binding[m.group(1)]})", term)


def assignments(names: list[str], domains: list[list[str]], seed: str,
                cap: int = INSTANCE_CAP) -> list[dict[str, str]]:
    """Up to ``cap`` assignments: every small corner, then a seeded sample."""
    if not names:
        return [{}]
    total = prod(len(d) for d in domains)
    if total <= cap:
        return [dict(zip(names, combo)) for combo in product(*domains)]
    chosen: list[tuple[int, ...]] = []
    seen: set[tuple[int, ...]] = set()
    corner = [min(2, len(d)) for d in domains]
    for idx in product(*(range(c) for c in corner)):
        if len(chosen) >= cap // 2:
            break
        seen.add(idx)
        chosen.append(idx)
    rng = random.Random(zlib.crc32(seed.encode()))
    tries = 0
    while len(chosen) < cap and tries < cap * 20:
        tries += 1
        idx = tuple(rng.randrange(len(d)) for d in domains)
        if idx not in seen:
            seen.add(idx)
            chosen.append(idx)
    return [{n: d[i] for n, d, i in zip(names, domains, idx)} for idx in chosen]


# --- the plan: what one run evaluates -------------------------------------------

@dataclass
class Instance:
    law: str
    binding: dict[str, str]
    lhs: str
    rhs: str
    hyps: list[tuple[str, str]]


@dataclass
class Probe:
    target: str
    args: tuple[str, ...]


@dataclass
class Plan:
    """Everything a task's laws say at points, built once per task."""

    laws: list[Law]
    instances: list[Instance]
    probes: list[Probe]
    returns: dict[str, str]                       # target -> return type
    unread: list[str] = field(default_factory=list)
    uncovered: list[str] = field(default_factory=list)
    flipped: set[int] = field(default_factory=set)
    """Components whose list level is spelled the other way; see ``_spell``."""

    def components(self) -> list[tuple[str, list[str]]]:
        """``(type, [term])`` lists, in the order ``main`` returns them."""
        out = []
        for law in self.laws:
            rows = [i for i in self.instances if i.law == law.name]
            if not rows:
                continue
            out.append((law.goal.typ, [r.lhs for r in rows]))
            out.append((law.goal.typ, [r.rhs for r in rows]))
            for k, hyp in enumerate(law.hyps):
                out.append((hyp.typ, [r.hyps[k][0] for r in rows]))
                out.append((hyp.typ, [r.hyps[k][1] for r in rows]))
        for target, typ in self.returns.items():
            rows = [p for p in self.probes if p.target == target]
            out.append((typ, [f"S.{target}({', '.join(p.args)})" for p in rows]))
            out.append((typ, [f"R.{target}({', '.join(p.args)})" for p in rows]))
        return out


def plan(task: Task) -> Plan:
    adts = prelude_types(task.prelude_src)
    laws, unread = parse_laws(task.laws_src)
    usable, instances, uncovered = [], [], []
    for law in laws:
        types = [parse_type(t, adts) for _, t in law.data]
        if any(t is None for t in types):
            uncovered.append(f"law {law.name}: binder type "
                             + ", ".join(t for (_, t), p in zip(law.data, types) if p is None))
            continue
        names = [n for n, _ in law.data]
        doms = [values(t, adts) for t in types]
        usable.append(law)
        for binding in assignments(names, doms, law.name):
            instances.append(Instance(
                law.name, binding,
                substitute(law.goal.lhs, binding), substitute(law.goal.rhs, binding),
                [(substitute(h.lhs, binding), substitute(h.rhs, binding))
                 for h in law.hyps]))

    body = _strip_comments(task.laws_src)
    cited = set(re.findall(r"\bS\.([A-Za-z_]\w*)", body))
    probes, returns = [], {}
    for name, params, ret in signatures(task.stub_src):
        if name not in cited:
            continue
        types = [parse_type(t, adts) for _, t in params]
        if any(t is None for t in types) or parse_type(ret, adts) is None:
            uncovered.append(f"function {name}: a parameter or return type")
            continue
        names = [p.lstrip("+-") for p, _ in params]
        doms = [values(t, adts) for t in types]
        returns[name] = ret
        for binding in assignments(names, doms, "probe:" + name):
            probes.append(Probe(name, tuple(binding[n] for n in names)))
    return Plan(usable, instances, probes, returns, unread, uncovered)


def render(plan: Plan, task: Task) -> str:
    components = plan.components()
    header = ["import Base"]
    if task.prelude_src.strip():
        header.append(f"import ./{PRELUDE_FILE} as P")
    header += [f"import ./{SOLUTION_FILE} as S", f"import ./{REFERENCE_FILE} as R", ""]
    # One def per component, so that a type error names the component it is in
    # (``Location: G.c3``) rather than ``main``, and ``evaluate`` can respell it.
    lines = header
    types = []
    for k, (typ, rows) in enumerate(components):
        spelled = _spell(typ, k in plan.flipped)
        types.append(spelled)
        lines += [f"def G.c{k}() -> {spelled}:", f"  [{', '.join(rows)}]", ""]
    typ, term = types[-1], f"G.c{len(types) - 1}()"
    for k in range(len(types) - 2, -1, -1):
        typ, term = f"({types[k]} & {typ})", f"(G.c{k}(), {term})"
    return "\n".join(lines + [f"def main() -> {typ}:", f"  {term}", ""])


def _spell(typ: str, flipped: bool) -> str:
    """The list type that holds values of ``typ``.

    ``List<&2, T>`` holds data, and a list of lists has to leave the level to
    the checker, which rejects ``List<&2, List<Nat>>`` as Type-not-Data. The
    level is not always what the law says, either: ``t2-delete-laws`` states
    ``: List<&2, Nat>`` about a function the stub declares ``-> List<Nat>``,
    which the checker accepts inside an equality and refuses inside a list. So
    the spelling a component needs is found by trying, and ``flipped`` is the
    other one: the element's own level dropped or added.
    """
    if flipped:
        found = re.fullmatch(r"List<\s*&\d+\s*,\s*(.*)>", typ)
        typ = f"List<{found.group(1)}>" if found else (
            f"List<&2, {typ[5:-1]}>" if typ.startswith("List<") else typ)
    return f"List<{typ}>" if typ.startswith("List<") else f"List<&2, {typ}>"


# --- running it -----------------------------------------------------------------

@dataclass
class Report:
    outcome: str                                   # rejected|hole|equivalent|unevaluable
    violations: list[str] = field(default_factory=list)
    differences: list[str] = field(default_factory=list)
    vacuous: list[str] = field(default_factory=list)
    error: str | None = None
    instances: int = 0
    probes: int = 0


def parse_output(text: str, n: int) -> list[list[str]] | None:
    text = text.strip()
    if n > 1:
        if not (text.startswith("(") and text.endswith(")")):
            return None
        parts = split_top(text[1:-1])
    else:
        parts = [text]
    if len(parts) != n:
        return None
    out = []
    for part in parts:
        if not (part.startswith("[") and part.endswith("]")):
            return None
        out.append(split_top(part[1:-1]))
    return out


def evaluate(task: Task, toolchain: Toolchain, candidate: str,
             the_plan: Plan | None = None, backend: str | None = None,
             limits: Limits = GROUND_LIMITS) -> Report:
    the_plan = the_plan or plan(task)
    components = the_plan.components()
    if not components:
        return Report("unevaluable", error="no law or function could be instantiated")
    workdir = prepare_workdir(task, {SOLUTION_FILE: candidate})
    try:
        (Path(workdir) / REFERENCE_FILE).write_text(task.reference_solution)
        for _ in range(len(components) + 1):
            (Path(workdir) / GROUND_FILE).write_text(render(the_plan, task))
            result = run_check(toolchain, workdir, GROUND_FILE, limits,
                               select_backend(backend) if backend else None)
            # A list-level mismatch inside one of our own defs is a spelling
            # this module chose, not a fact about the candidate: respell that
            # component and run again. The plan keeps the spelling, so only
            # the first body evaluated against a task pays for the search.
            where = re.fullmatch(r"G\.c(\d+)", result.error_location or "")
            if (result.exit_code == 0 or where is None or "List<" not in result.stderr
                    or int(where.group(1)) in the_plan.flipped):
                break
            the_plan.flipped.add(int(where.group(1)))
    finally:
        cleanup(workdir)
    report = Report("unevaluable", instances=len(the_plan.instances),
                    probes=len(the_plan.probes))
    rows = parse_output(result.stdout, len(components)) if result.exit_code == 0 else None
    if rows is None:
        detail = (result.stderr or result.stdout).strip().splitlines()
        report.error = ("timed out" if result.timed_out
                        else " ".join(detail[:4]) or f"exit {result.exit_code}")
        return report

    cursor = 0
    for law in the_plan.laws:
        mine = [i for i in the_plan.instances if i.law == law.name]
        if not mine:
            continue
        lhs, rhs = rows[cursor], rows[cursor + 1]
        cursor += 2
        hyps = []
        for _ in law.hyps:
            hyps.append((rows[cursor], rows[cursor + 1]))
            cursor += 2
        held = 0
        for k, inst in enumerate(mine):
            if any(hl[k] != hr[k] for hl, hr in hyps):
                continue
            held += 1
            if lhs[k] != rhs[k]:
                where = ", ".join(f"{n}={v}" for n, v in inst.binding.items())
                report.violations.append(
                    f"{law.name}({where}): {lhs[k]} != {rhs[k]}")
        if held == 0:
            report.vacuous.append(law.name)
    for target in the_plan.returns:
        mine = [p for p in the_plan.probes if p.target == target]
        got, want = rows[cursor], rows[cursor + 1]
        cursor += 2
        for k, probe in enumerate(mine):
            if got[k] != want[k]:
                report.differences.append(
                    f"{target}({', '.join(probe.args)}) = {got[k]}, "
                    f"reference {want[k]}")
    report.outcome = ("rejected" if report.violations
                      else "hole" if report.differences else "equivalent")
    return report


__all__ = ["GROUND_FILE", "INSTANCE_CAP", "Law", "Plan", "Report", "evaluate",
           "parse_laws", "plan", "prelude_types", "render", "values"]
