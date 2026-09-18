"""The verifier gate: everything that must be true before the checker runs.

Reward hacking against Gavel means getting the checker to accept without
proving the law. The checker has real holes -- ``@unsafe`` exits 0 with a
warning; a ``main`` in the submitted file executes and suppresses the success
line entirely -- and the gate is what closes them, on the token stream rather
than on the text, so that a construct inside a string or a comment is not
mistaken for the real thing (SPEC.md 7.2).
"""

from __future__ import annotations

import re
from dataclasses import dataclass

from .hashing import sha256_text
from .laws import (ImportSpec, alias_map, has_foreign_import, parse_imports,
                   split_top_level)
from .tasks import (HASH_KEYS, LAWS_FILE, PRELUDE_FILE, PROOF_FILE,
                    SOLUTION_FILE, Task)
from .verdict import GateFinding, GateResult

# Names a policy may introduce beyond the targets it was given. A reserved
# namespace keeps the allowlist checkable without a symbol table.
HELPER_PREFIX = "Policy."


@dataclass(frozen=True)
class GatePolicy:
    max_file_bytes: int = 64 * 1024
    """SPEC.md 7.6. The checker is fast partly because inputs are small."""

    def finding(self, code: str, message: str, file: str = "", line: int = 0) -> GateFinding:
        return GateFinding(code=code, message=message, file=file, line=line)


DEFAULT_POLICY = GatePolicy()

# The files a task owns and a policy must never submit.
_IMMUTABLE = (LAWS_FILE, PRELUDE_FILE)


def check(task: Task, files: dict[str, str],
          policy: GatePolicy = DEFAULT_POLICY) -> GateResult:
    """Scan a submission. Returns every finding, not just the first."""
    findings: list[GateFinding] = []

    for name in sorted(set(files) & set(_IMMUTABLE)):
        findings.append(policy.finding(
            "immutable-file",
            f"{name} belongs to the task and cannot be submitted", name))
    for name in sorted(set(files) - set(_IMMUTABLE) - {SOLUTION_FILE, PROOF_FILE}):
        findings.append(policy.finding(
            "unknown-file", f"{name} is not part of a submission", name))
    for name in (SOLUTION_FILE, PROOF_FILE):
        if name not in files:
            findings.append(policy.finding(
                "missing-file", f"{name} is required in a submission", name))

    for name in sorted(files):
        size = len(files[name].encode("utf-8"))
        if size > policy.max_file_bytes:
            findings.append(policy.finding(
                "size", f"{name} is {size} bytes; the limit is "
                        f"{policy.max_file_bytes}", name))

    findings.extend(_integrity(task))

    if SOLUTION_FILE in files:
        findings.extend(_scan(task, SOLUTION_FILE, files[SOLUTION_FILE], policy))
    if PROOF_FILE in files:
        findings.extend(_scan(task, PROOF_FILE, files[PROOF_FILE], policy))

    hashes = tuple((name, sha256_text(files[name])) for name in sorted(files))
    return GateResult(ok=not findings, findings=tuple(findings), hashes=hashes)


def _integrity(task: Task) -> list[GateFinding]:
    """The task's own files must match the hashes it was published with.

    A missing hash is not a finding -- a task published before hashes existed
    is not a modified task -- but a *present* one that disagrees is fatal.
    """
    expected = task.meta.get("hashes", {})
    out: list[GateFinding] = []
    for name, text in ((LAWS_FILE, task.laws_src), (PRELUDE_FILE, task.prelude_src)):
        want = expected.get(HASH_KEYS[name])
        if want and want != sha256_text(text):
            out.append(GateFinding(
                "integrity",
                f"{task.task_id}/{name} does not match its recorded hash; "
                f"the task itself has been modified", name))
    return out


def _scan(task: Task, name: str, src: str, policy: GatePolicy) -> list[GateFinding]:
    findings: list[GateFinding] = []

    try:
        chunks = split_top_level(src)
    except Exception as exc:  # a malformed file is the checker's to reject
        return [GateFinding("unparsable", f"{name} could not be tokenized: {exc}", name)]

    for chunk in chunks:
        if chunk.unsafe:
            findings.append(policy.finding(
                "unsafe",
                "@unsafe switches off the termination checker, so a "
                "non-terminating term can inhabit any type", name, chunk.line))
        if chunk.kind == "law":
            findings.append(policy.finding(
                "law", "a submission may not declare or redeclare a law",
                name, chunk.line))
        if chunk.name == "main":
            findings.append(policy.finding(
                "main",
                "a main in the submitted file runs during checking: its side "
                "effects execute and its output replaces the success line",
                name, chunk.line))

    foreign, line = has_foreign_import(src)
    if foreign:
        findings.append(policy.finding(
            "foreign-import",
            'import "…" declares a foreign effect, which escapes the type system',
            name, line))

    imports = parse_imports(src)
    findings.extend(_imports(task, name, imports, policy))
    findings.extend(_names(task, name, src, imports, policy))
    return findings


def _imports(task: Task, name: str, imports: list[ImportSpec],
             policy: GatePolicy) -> list[GateFinding]:
    allowed = {f"./{LAWS_FILE}", f"./{PRELUDE_FILE}", f"./{SOLUTION_FILE}"}
    out: list[GateFinding] = []
    for imp in imports:
        if imp.is_base:
            continue
        if imp.path is None:
            out.append(policy.finding(
                "import", f"malformed import line: {imp.raw!r}", name, imp.line))
            continue
        if imp.is_hub:
            out.append(policy.finding(
                "hub-import",
                f"{imp.path} fetches a package over the network and pins it to "
                f"a hash the policy chose", name, imp.line))
            continue
        if imp.path not in allowed:
            out.append(policy.finding(
                "import",
                f"a submission may import only Base and the task's own files; "
                f"got {imp.path}", name, imp.line))
    return out


def _names(task: Task, name: str, src: str, imports: list[ImportSpec],
           policy: GatePolicy) -> list[GateFinding]:
    """Every top-level name must be one the policy was asked to write.

    Belt and braces over the checker's own duplicate detection: a name that
    collides with a prelude, law or Base declaration is rejected here rather
    than left to a parse error the policy could read as a hint.
    """
    aliases = alias_map(imports)
    law_module = _law_module(imports)
    allowed_targets = set(task.policy_targets)
    out: list[GateFinding] = []

    for chunk in split_top_level(src):
        written = chunk.name
        if written.startswith(HELPER_PREFIX):
            continue
        if name == SOLUTION_FILE:
            if written in allowed_targets:
                continue
        else:
            head, dot, tail = written.partition(".")
            module = aliases.get(head, head if not dot else None)
            if module is not None and module == law_module and tail in set(task.laws):
                continue
        out.append(policy.finding(
            "name",
            f"{written!r} is not a name this submission may declare; allowed: "
            f"{sorted(allowed_targets)} and {HELPER_PREFIX}*"
            + (f", plus each law as <alias>.<law>" if name == PROOF_FILE else ""),
            name, chunk.line))
    return out


def _law_module(imports: list[ImportSpec]) -> str:
    """The namespace this file's import of LAWS.bend binds."""
    for imp in imports:
        if imp.path is not None and imp.path.endswith("/" + LAWS_FILE):
            return imp.module or "LAWS"
    return "LAWS"


def law_definitions(src: str, laws: tuple[str, ...] | list[str]) -> dict[str, "object"]:
    """Written proof-def name -> declaration chunk, for the laws a file fills."""
    imports = parse_imports(src)
    aliases = alias_map(imports)
    law_module = _law_module(imports)
    found: dict[str, object] = {}
    for chunk in split_top_level(src):
        if chunk.kind != "def":
            continue
        head, dot, tail = chunk.name.partition(".")
        if not dot:
            continue
        module = aliases.get(head, head)
        if module == law_module and tail in set(laws):
            found[tail] = chunk
    return found
