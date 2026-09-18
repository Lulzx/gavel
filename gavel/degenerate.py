"""Submissions that are shaped like answers and prove nothing.

A task's laws are only worth training on if a proof that *looks* like a proof
cannot satisfy them. Each generator here produces such an attempt from the
task's own signatures and law binders, so the corpus follows the task rather
than needing to be hand-written per task.

These are deliberately mechanical. The interesting degenerate cases -- a proof
that is right for the wrong reason, a law that holds only for the base case --
are what ``tools/mutate.py`` is for; what lives here is the family of attempts
that any policy emits in its first hundred steps.
"""

from __future__ import annotations

import re
from dataclasses import dataclass

from .laws import split_top_level
from .tasks import PROOF_FILE, SOLUTION_FILE

# ``def name(a: Nat, b: List<Nat>) -> Nat:`` -- the stub's own spelling. A
# signature this fails to match is skipped rather than guessed at: the tool is
# allowed to be incomplete, but it is not allowed to be wrong.
_SIGNATURE = re.compile(
    r"^\s*def\s+([A-Za-z_][\w.]*)\s*\(([^)]*)\)\s*->\s*([^:]+):", re.M)


@dataclass(frozen=True)
class Degenerate:
    """One attempt, and what should happen to it."""

    name: str
    files: dict[str, str]
    must_be_gate_rejected: bool = False


def signatures(src: str) -> list[tuple[str, list[tuple[str, str]], str]]:
    """``(name, [(param, type)], return_type)`` for each def in ``src``.

    A def with an unannotated parameter is dropped rather than approximated:
    the generators rebuild the signature from what they parsed, so a guessed
    parameter list would produce a submission that fails for the wrong reason
    and make V3 look like it was doing its job.
    """
    out = []
    for match in _SIGNATURE.finditer(src):
        parts = [p for p in match.group(2).split(",") if p.strip()]
        params = []
        for part in parts:
            if ":" not in part:
                params = []
                break
            param, _, typ = part.partition(":")
            params.append((param.strip(), typ.strip()))
        if parts and not params:
            continue
        out.append((match.group(1), params, match.group(3).strip()))
    return out


def _render(name: str, params: list[tuple[str, str]], ret: str) -> str:
    declared = ", ".join(f"{param}: {typ}" for param, typ in params)
    return f"def {name}({declared}) -> {ret}:"


def _zero_of(typ: str) -> str | None:
    """The most obvious inhabitant of a type, or None if there is not one."""
    if typ == "Nat":
        return "0n"
    if typ.startswith("List<"):
        return "Nil{}"
    if typ == "Bool":
        return "False"
    return None


def laws_of(task) -> list[tuple[str, list[tuple[str, str]]]]:
    """``(law_name, [(binder, type)])`` from the task's LAWS.bend."""
    out = []
    for chunk in split_top_level(task.laws_src):
        if chunk.kind != "law":
            continue
        binders = []
        for line in chunk.text.splitlines():
            stripped = line.strip()
            if not stripped.startswith("for "):
                continue
            rest = stripped[len("for "):]
            if ":" not in rest:
                continue
            binder, _, typ = rest.partition(":")
            binders.append((binder.strip(), typ.strip().rstrip(":")))
        out.append((chunk.name, binders))
    return out


def _binders(binders: list[tuple[str, str]]) -> str:
    return ", ".join(name for name, _ in binders)


def corpus(task) -> list[Degenerate]:
    """Every degenerate attempt that makes sense for this task."""
    targets = signatures(task.stub_src)
    laws = laws_of(task)
    # The two files import differently: a solution.bend that carried the proof
    # header would import itself.
    header = task.proof_header.rstrip("\n")
    stub_imports = "\n".join(
        line for line in task.stub_src.splitlines()
        if line.strip().startswith("import")).rstrip("\n")

    out: list[Degenerate] = []

    # A solution that type-checks but ignores its arguments. This is the
    # commonest way a policy earns tier 2 for free, and it must never earn
    # more than that.
    identity = [stub_imports, ""]
    constant = [stub_imports, ""]
    for name, params, ret in targets:
        identity.append(_render(name, params, ret))
        identity.append(f"  {params[0][0] if params else '?'}")
        identity.append("")
        zero = _zero_of(ret)
        constant.append(_render(name, params, ret))
        constant.append(f"  {zero}" if zero else "  ?TODO")
        constant.append("")
    out.append(Degenerate("identity-solution",
                          {SOLUTION_FILE: "\n".join(identity),
                           PROOF_FILE: header}))
    out.append(Degenerate("constant-solution",
                          {SOLUTION_FILE: "\n".join(constant),
                           PROOF_FILE: header}))

    # A proof file that is syntactically complete and inductive in nothing.
    reflexive = [header, ""]
    for law, binders in laws:
        reflexive.append(f"def L.{law}({_binders(binders)}):")
        reflexive.append("  {==}")
        reflexive.append("")
    out.append(Degenerate("reflexive-proof",
                          {SOLUTION_FILE: task.reference_solution,
                           PROOF_FILE: "\n".join(reflexive)}))

    # The self-referential @unsafe def: exit 0, and worth nothing. The gate is
    # what has to stop it, since the checker does not.
    unsafe = [header, ""]
    for law, binders in laws:
        unsafe.append("@unsafe")
        unsafe.append(f"def L.{law}({_binders(binders)}):")
        unsafe.append(f"  L.{law}({_binders(binders)})")
        unsafe.append("")
    out.append(Degenerate("self-referential-unsafe",
                          {SOLUTION_FILE: task.reference_solution,
                           PROOF_FILE: "\n".join(unsafe)},
                          must_be_gate_rejected=True))

    # Every law named, none attempted.
    holed = [header, ""]
    for law, binders in laws:
        holed.append(f"def L.{law}({_binders(binders)}):")
        holed.append("  ?TODO")
        holed.append("")
    out.append(Degenerate("holed-proof",
                          {SOLUTION_FILE: task.reference_solution,
                           PROOF_FILE: "\n".join(holed)}))

    return out


__all__ = ["Degenerate", "corpus", "laws_of", "signatures"]
