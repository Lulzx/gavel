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

# Just the name. Used to notice a def the signature pattern missed entirely,
# which is the other way the corpus can silently shrink.
_DEF_NAME = re.compile(r"^\s*def\s+([A-Za-z_][\w.]*)", re.M)

_OPEN, _CLOSE = "<({[", ">)}]"


def _split_params(text: str) -> list[str]:
    """Split on the commas that separate parameters, and only those.

    ``def sum(xs: List<&2, Nat>, ys: Nat) -> Nat`` has one parameter. Splitting
    it on a bare comma yields ``xs: List<&2`` and ``Nat>``, the first of which
    parses as a parameter of type ``List<&2`` and the second of which has no
    type at all -- so the def is dropped, the corpus rebuilds a stub missing a
    function its laws call, and every degenerate attempt fails to type-check.
    V3 then passes having tested nothing. Measured on ``t2-sum-laws``, which is
    why it now uses ``List<Nat>``: the same trap under a spelling the tool
    happened to parse.
    """
    out: list[str] = []
    depth, start = 0, 0
    for at, char in enumerate(text):
        if char in _OPEN:
            depth += 1
        elif char in _CLOSE:
            depth -= 1
        elif char == "," and depth == 0:
            out.append(text[start:at])
            start = at + 1
    out.append(text[start:])
    return [part.strip() for part in out if part.strip()]


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
        parts = _split_params(match.group(2))
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


def unmodelled(src: str) -> list[str]:
    """Defs the stub declares that :func:`signatures` could not rebuild.

    A stub def this function names is one the corpus cannot model, and the
    consequence is silent: the generated solutions omit a function the laws
    call, so every degenerate attempt is a type error and V3 passes without
    having asked anything. The list is returned rather than raised because a
    task with one unparseable signature is not *wrong*, it is unguaranteed --
    which is what ``tools.validate`` needs to say out loud.
    """
    declared = [m.group(1) for m in _DEF_NAME.finditer(src)]
    parsed = {name for name, _, _ in signatures(src)}
    seen: dict[str, None] = {}
    for name in declared:
        if name not in parsed:
            seen[name] = None
    return list(seen)


def _render(name: str, params: list[tuple[str, str]], ret: str) -> str:
    declared = ", ".join(f"{param}: {typ}" for param, typ in params)
    return f"def {name}({declared}) -> {ret}:"


def _zero_of(typ: str) -> str | None:
    """The most obvious inhabitant of a type, or None if there is not one.

    The spelling matters more than it looks: ``Bool``'s values are ``False{}``
    and ``True{}`` (base.bend:13), and a bare ``False`` is a type error. A
    generator that emitted ``False`` would produce a submission that fails
    before any law is consulted, so V3 would pass on every Bool-valued task
    having tested none of them -- which is exactly the vacuity the last clause
    of :func:`_ignore_arguments` exists to avoid.
    """
    if typ == "Nat":
        return "0n"
    if typ.startswith("List<"):
        return "Nil{}"
    if typ == "Bool":
        return "False{}"
    return None


def _ignore_arguments(params: list[tuple[str, str]], ret: str) -> str | None:
    """A body that mentions none of its arguments and still type-checks.

    A parameter whose type is the return type can be handed back unchanged;
    ``len(xs: List<Nat>) -> Nat`` cannot, because returning ``xs`` would be a
    type error and a solution that fails to type-check says nothing about the
    law. Those fall back to the zero of the return type, which is the other way
    to ignore the arguments, and to ``?TODO`` when the type has no obvious
    inhabitant.
    """
    for name, typ in params:
        if typ == ret:
            return name
    return _zero_of(ret)


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


def _reflexive_proof(laws, header: str) -> str:
    """A proof that claims every law is true by definition."""
    lines = [header, ""]
    for law, binders in laws:
        lines += [f"def L.{law}({_binders(binders)}):", "  {==}", ""]
    return "\n".join(lines)


def corpus(task) -> list[Degenerate]:
    """Every degenerate attempt that makes sense for this task.

    The submissions that matter most are the *cross products* of a degenerate
    solution and a degenerate proof. Pairing a wrong solution with the
    reference proof only asks whether the reference proof is brittle; it says
    nothing about whether the laws pin the solution down. A law of the form
    ``f(x, e) == x`` is satisfied by the projection ``f(a, b) = a`` proved with
    ``{==}`` -- full reward for a function nobody implemented. Holding the
    proof fixed would never have shown that.
    """
    targets = signatures(task.stub_src)
    laws = laws_of(task)
    # The two files import differently: a solution.bend that carried the proof
    # header would import itself.
    header = task.proof_header.rstrip("\n")
    stub_imports = "\n".join(
        line for line in task.stub_src.splitlines()
        if line.strip().startswith("import")).rstrip("\n")

    out: list[Degenerate] = []

    # Solutions that type-check and ignore their arguments.
    identity = [stub_imports, ""]
    constant = [stub_imports, ""]
    for name, params, ret in targets:
        identity.append(_render(name, params, ret))
        identity.append(f"  {_ignore_arguments(params, ret) or '?TODO'}")
        identity.append("")
        zero = _zero_of(ret)
        constant.append(_render(name, params, ret))
        constant.append(f"  {zero}" if zero else "  ?TODO")
        constant.append("")
    solutions = {"identity-solution": "\n".join(identity),
                 "constant-solution": "\n".join(constant)}

    # Only the reflexive proof is worth crossing with. A hole cannot prove a
    # law, so `+no-proof` is tier 2 and `+holed-proof` is tier 3 at best --
    # neither can reach tier 4, and each cross product is two checker runs.
    for solution_name, solution in solutions.items():
        out.append(Degenerate(f"{solution_name}+reflexive-proof",
                              {SOLUTION_FILE: solution,
                               PROOF_FILE: _reflexive_proof(laws, header)}))

    # The reference solution against a proof that proves nothing. This isolates
    # the proof, since the cross products above can fail for either reason, and
    # is also what establishes the tier-2 floor for a well-typed solution.
    out.append(Degenerate("reference+reflexive-proof",
                          {SOLUTION_FILE: task.reference_solution,
                           PROOF_FILE: _reflexive_proof(laws, header)}))
    out.append(Degenerate("reference+no-proof",
                          {SOLUTION_FILE: task.reference_solution,
                           PROOF_FILE: header + "\n"}))
    holed = [header, ""]
    for law, binders in laws:
        holed += [f"def L.{law}({_binders(binders)}):", "  ?TODO", ""]
    out.append(Degenerate("reference+holed-proof",
                          {SOLUTION_FILE: task.reference_solution,
                           PROOF_FILE: "\n".join(holed)}))

    # The self-referential @unsafe def: exit 0, and worth nothing. The gate is
    # what has to stop it, since the checker does not.
    unsafe = [header, ""]
    for law, binders in laws:
        unsafe += ["@unsafe", f"def L.{law}({_binders(binders)}):",
                   f"  L.{law}({_binders(binders)})", ""]
    out.append(Degenerate("self-referential-unsafe",
                          {SOLUTION_FILE: task.reference_solution,
                           PROOF_FILE: "\n".join(unsafe)},
                          must_be_gate_rejected=True))

    return out


__all__ = ["Degenerate", "corpus", "laws_of", "signatures", "unmodelled"]
