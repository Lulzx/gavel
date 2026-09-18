"""The runner and the check protocol, against the real pinned checker.

These are the tests that hold the design up: every claim PLAN.md makes about
what the checker does is asserted here against the vendored toolchain, so a
toolchain bump that invalidates one of them fails loudly instead of silently
turning into a reward-hacking path.
"""

from __future__ import annotations

import json
import shutil
from dataclasses import replace
from pathlib import Path

import pytest

from gavel.check import CheckConfig, check_submission
from gavel.runner import (PLAIN, SUCCESS_LINE, UNSAFE_MARK, BackendError,
                          BwrapBackend, Limits, run_check, scrub_env,
                          select_backend)
from gavel.tasks import (PROOF_FILE, SOLUTION_FILE, cleanup, prepare_workdir)
from gavel.toolchain import TOOLCHAIN_DIR, Toolchain, ToolchainError
from gavel.verdict import (TIER_CHECKS, TIER_COMPLETE, TIER_NO_CHECK,
                           TIER_PARTIAL, TIER_REJECTED, Verdict)

pytestmark = pytest.mark.checker


def reference_files(task, submission) -> dict[str, str]:
    submission[SOLUTION_FILE] = task.reference_solution
    submission[PROOF_FILE] = task.reference_proof
    return submission


@pytest.fixture
def run_dir(task):
    """Materialise a submission into a workdir the checker can be pointed at."""
    dirs = []

    def make(files: dict[str, str]):
        workdir = prepare_workdir(task, files)
        dirs.append(workdir)
        return workdir

    yield make
    for workdir in dirs:
        cleanup(workdir)


# --- the runner ---------------------------------------------------------------

def test_a_correct_proof_prints_the_success_line(toolchain, task, submission, run_dir):
    workdir = run_dir(reference_files(task, submission))
    result = run_check(toolchain, workdir, PROOF_FILE)
    assert result.ok
    assert result.success_line
    assert result.exit_code == 0
    assert not result.unsafe_warning
    assert result.stdout.strip() == "All terms check."


def test_a_self_referential_unsafe_proof_is_accepted_by_the_checker(
        toolchain, task, submission, run_dir):
    """The reward hack this whole design exists to close.

    With termination checking off, a def that calls itself inhabits its own
    goal type -- so this is a "proof" of x + 0 = x that proves nothing. The
    checker accepts it: exit 0, and the success line replaced by a warning.
    Keying reward on the exit code would pay out 1.0 for it.
    """
    submission[SOLUTION_FILE] = task.reference_solution
    submission[PROOF_FILE] = (task.proof_header +
                              "\n@unsafe\ndef L.add_succ(x, y):\n  L.add_succ(x, y)\n")
    workdir = run_dir(submission)
    result = run_check(toolchain, workdir, PROOF_FILE)
    assert result.exit_code == 0          # the exit code says fine
    assert not result.ok                  # ...and it is not fine
    assert result.unsafe_warning
    assert not result.success_line
    assert UNSAFE_MARK in result.stdout
    assert SUCCESS_LINE not in result.stdout


def test_a_submitted_main_replaces_the_success_line(toolchain, task, run_dir):
    workdir = run_dir({SOLUTION_FILE: "import Base\n\ndef main() -> u24:\n  return 0\n"})
    result = run_check(toolchain, workdir, SOLUTION_FILE)
    assert not result.success_line
    assert not result.ok


def test_a_hole_prints_a_todo_count(toolchain, task, submission, run_dir):
    # The reference solution, so the only hole is the one in the proof.
    submission[SOLUTION_FILE] = task.reference_solution
    submission[PROOF_FILE] = task.proof_header + "\ndef L.add_succ(x, y):\n  ?TODO\n"
    workdir = run_dir(submission)
    result = run_check(toolchain, workdir, PROOF_FILE)
    assert result.todo_count == 1
    assert not result.ok


def test_only_the_first_type_error_is_reported(toolchain, task, submission, run_dir):
    """Why partial credit needs isolation runs rather than one clever parse."""
    submission[SOLUTION_FILE] = (
        'import Base\n\ndef add(a: Nat, b: Nat) -> Nat:\n  "not a Nat"\n')
    submission[PROOF_FILE] = (
        task.proof_header + '\ndef L.add_succ(x, y):\n  "also not a proof"\n')
    workdir = run_dir(submission)
    result = run_check(toolchain, workdir, PROOF_FILE)
    assert not result.ok
    assert result.error_block is not None
    assert result.stderr.count("Error:") == 1


def test_the_wall_clock_kills_a_checker_that_never_returns(toolchain, task, tmp_path):
    """The timeout, tested against a checker that provably does not return.

    Driving this with a real Bend file would mean depending on whichever input
    happens to hang 2.0.5 today -- the timeout would then be untested the
    moment that input stopped hanging. A stand-in that sleeps tests the
    mechanism itself: the wait, the kill, and the group signal.
    """
    slow = tmp_path / "bun"
    # An absolute path: the runner scrubs PATH down to the bun directory, so a
    # bare `sleep` really does not resolve. (It failed that way first.)
    slow.write_text("#!/bin/sh\nexec /bin/sleep 60\n")
    slow.chmod(0o755)
    workdir = prepare_workdir(task, {
        SOLUTION_FILE: "import Base\n", PROOF_FILE: task.proof_header})
    try:
        result = run_check(replace(toolchain, bun=slow), workdir, PROOF_FILE,
                           Limits(wall_ms=800))
    finally:
        cleanup(workdir)
    assert result.timed_out
    assert result.exit_code is None
    assert not result.ok
    assert result.ms < 10_000              # it was killed, not waited out


def test_the_environment_is_scrubbed(toolchain, tmp_path):
    env = scrub_env(tmp_path, toolchain.bun)
    assert env["HOME"] == str(tmp_path)
    assert env["TMPDIR"] == str(tmp_path)
    assert env["LANG"] == "C"
    assert env["LC_ALL"] == "C"
    assert env["PATH"] == str(toolchain.bun.parent)
    assert env["BEND_HUB"] == "http://127.0.0.1:9"


# --- the backend ---------------------------------------------------------------

def test_every_verdict_names_the_isolation_it_ran_under(toolchain, task,
                                                        submission):
    """A reward is only as trustworthy as the process that produced it.

    With the sandbox only in the caller's configuration, a verdict computed
    unsandboxed is indistinguishable from one that was not -- and that is the
    distinction a training run needs in its log. The backend is named
    explicitly here so the assertion is about the plumbing rather than about
    which platform the suite happens to be running on.
    """
    config = CheckConfig(backend="plain")
    verdict = check_submission(task, toolchain, reference_files(task, submission),
                               config)
    assert verdict.checks
    assert {check.backend for check in verdict.checks} == {"plain"}
    assert verdict.checks[0].to_json()["backend"] == "plain"


def test_the_plain_backend_is_marked_dev_only():
    assert PLAIN.dev_only and PLAIN.name == "plain"
    assert not BwrapBackend(bwrap=Path("/usr/bin/bwrap")).dev_only


def test_the_sandbox_argv_binds_the_root_read_only_and_the_workdir_writable(
        toolchain, tmp_path):
    """The two binds are the whole boundary, and their order is the boundary.

    Everything outside the check is read-only and the check's own directory is
    bound back over it; several of these flags are load-bearing -- without
    ``--unshare-all`` there is no network namespace, and the gate's hub-import
    rule would be the only thing standing between a policy and the internet.
    """
    argv = BwrapBackend(bwrap=Path("/usr/bin/bwrap")).argv(
        toolchain, tmp_path, "PROOF.bend")
    assert argv[0] == "/usr/bin/bwrap"
    assert "--unshare-all" in argv and "--die-with-parent" in argv
    root = argv.index("--ro-bind")
    assert argv[root + 1:root + 3] == ["/", "/"]
    work = argv.index("--bind")
    assert argv[work + 1:work + 3] == [str(tmp_path), str(tmp_path)]
    assert work > root                      # the writable bind must win
    assert argv[-3:] == [str(toolchain.bun), str(toolchain.main_ts), "PROOF.bend"]


def test_asking_for_the_sandbox_without_it_is_an_error_not_a_downgrade(
        monkeypatch):
    """Silently falling back would be the worst outcome: the run would look
    sandboxed in every field except the one nobody reads."""
    monkeypatch.setattr("shutil.which", lambda _: None)
    with pytest.raises(BackendError, match="bubblewrap"):
        select_backend("bwrap")


def test_an_unknown_backend_is_refused():
    with pytest.raises(BackendError, match="unknown backend"):
        select_backend("chroot")


def test_run_check_reads_the_same_opt_out_a_config_does(monkeypatch):
    """There is one ``GAVEL_BACKEND`` and two ways to ask for a backend.

    ``CheckConfig`` read the variable and ``run_check``'s default did not, so a
    job that opted out was still asking the machine for a sandbox. Off Linux
    that is invisible -- ``auto`` resolves to ``plain`` there anyway -- and on
    Linux without bubblewrap it is the difference between the opt-out the
    variable exists for and a hard failure.
    """
    monkeypatch.setenv("GAVEL_BACKEND", "bwrap")
    monkeypatch.setattr("shutil.which", lambda _: None)
    with pytest.raises(BackendError, match="bubblewrap"):
        run_check(Toolchain.load(), Path("."), PROOF_FILE)


def test_a_job_can_opt_out_of_isolation_once(monkeypatch):
    """``GAVEL_BACKEND`` is read when a config is built, not when a check runs.

    So ``auto`` keeps its single meaning -- the strongest backend the machine
    has -- and the opt-out is a decision made where it can be seen, rather than
    a third branch hidden inside the resolver.
    """
    monkeypatch.delenv("GAVEL_BACKEND", raising=False)
    assert CheckConfig().backend == "auto"
    monkeypatch.setenv("GAVEL_BACKEND", "plain")
    assert CheckConfig().backend == "plain"
    assert CheckConfig(backend="auto").backend == "auto"


# --- the protocol -------------------------------------------------------------

def test_the_reference_reaches_tier_four_in_one_run(toolchain, task, submission):
    verdict = check_submission(task, toolchain, reference_files(task, submission))
    assert verdict.tier == TIER_COMPLETE
    assert verdict.reward == 1.0
    assert verdict.proven == task.laws
    assert verdict.failed == ()
    assert verdict.solved
    assert len(verdict.checks) == 1        # the one-run fast path


def test_the_stub_does_not_type_check(toolchain, task):
    stub = {SOLUTION_FILE: task.stub_src, PROOF_FILE: task.proof_header}
    verdict = check_submission(task, toolchain, stub)
    assert verdict.tier == TIER_NO_CHECK
    assert verdict.reward == 0.0


def test_a_well_typed_solution_with_no_proof_is_tier_two(toolchain, task, submission):
    submission[SOLUTION_FILE] = task.reference_solution
    submission[PROOF_FILE] = task.proof_header
    verdict = check_submission(task, toolchain, submission)
    assert verdict.tier == TIER_CHECKS
    assert verdict.reward == pytest.approx(0.1)
    assert verdict.proven == ()
    assert len(verdict.checks) == 1


def test_a_well_typed_but_wrong_solution_earns_tier_two(toolchain, task, submission):
    # `0n` checks; it just does not satisfy the law. Tier 1 is reserved for
    # submissions that do not type-check at all, so this is progress, not
    # failure -- which is the difference between a dense signal and a cliff.
    submission[SOLUTION_FILE] = "import Base\n\ndef add(a: Nat, b: Nat) -> Nat:\n  0n\n"
    verdict = check_submission(task, toolchain, submission)
    assert verdict.tier == TIER_CHECKS
    assert verdict.proven == ()


def test_the_gate_stops_the_checker_from_running_at_all(toolchain, task, submission):
    submission[PROOF_FILE] = (task.proof_header +
                              "\n@unsafe\ndef L.add_succ(x, y):\n  {==}\n")
    verdict = check_submission(task, toolchain, submission)
    assert verdict.tier == TIER_REJECTED
    assert verdict.checks == ()            # no subprocess was started
    assert verdict.reward == 0.0


def test_the_verdict_records_what_it_was_computed_from(toolchain, task, submission):
    verdict = check_submission(task, toolchain, reference_files(task, submission))
    assert verdict.toolchain_hash == toolchain.tree_hash
    assert verdict.task_hash == task.hash
    assert verdict.submission_hash
    assert verdict.n_laws == len(task.laws)
    assert verdict.ms > 0


def test_a_verdict_round_trips_through_json(toolchain, task, submission):
    verdict = check_submission(task, toolchain, reference_files(task, submission))
    blob = json.loads(json.dumps(verdict.to_json()))
    assert blob["task_id"] == task.task_id
    assert blob["tier"] == TIER_COMPLETE
    assert blob["laws_proven"] == list(task.laws)


def test_a_verdict_survives_json_and_back_unchanged(toolchain, task, submission):
    """Not just the shape: the same object, field for field.

    The cache stores verdicts as JSON and hands them back in place of a run, so
    a field that ``to_json`` forgets is a field the cached verdict quietly
    loses -- and the reward is computed from what comes back, not from what
    went in.
    """
    verdict = check_submission(task, toolchain, reference_files(task, submission))
    restored = Verdict.from_json(json.loads(json.dumps(verdict.to_json())))
    assert restored == verdict


def test_a_rejected_submission_round_trips_too(toolchain, task):
    """The gate path, where there are no checks to carry the reward."""
    verdict = check_submission(task, toolchain, {
        SOLUTION_FILE: "import Base\n@unsafe\ndef add(a: Nat, b: Nat) -> Nat:\n  add(a, b)\n",
        PROOF_FILE: task.proof_header})
    assert verdict.gate is not None and not verdict.gate.ok
    restored = Verdict.from_json(json.loads(json.dumps(verdict.to_json())))
    assert restored == verdict
    assert restored.gate.findings


# --- partial credit ------------------------------------------------------------

@pytest.fixture(scope="session")
def two_law(manifest):
    return manifest.get("t2-add-laws")


ADD_ZERO_PROOF = (
    "\ndef L.add_zero(x):\n"
    "  match x:\n"
    "    case 0n:\n"
    "      {==}\n"
    "    case 1n+p:\n"
    "      %L.add_zero(p) : {1n+S.add(p, 0n) == 1n+_ : Nat}\n"
    "      {==}\n")


def test_a_proof_that_fills_some_laws_credits_exactly_those(toolchain, two_law):
    laws = two_law.laws
    files = {
        SOLUTION_FILE: two_law.reference_solution,
        PROOF_FILE: two_law.proof_header + ADD_ZERO_PROOF,   # add_succ left open
    }
    verdict = check_submission(two_law, toolchain, files)
    # One run is enough: a hole anywhere would inflate the TODO count, so a
    # single open law means every def that is present checked.
    assert len(verdict.checks) == 1
    assert verdict.tier == TIER_PARTIAL
    assert verdict.proven == (laws[0],)
    assert verdict.failed == (laws[1],)
    assert verdict.reward == pytest.approx(0.1 + 0.5 * 0.5)


def test_a_def_that_is_present_but_holed_proves_nothing(toolchain, two_law):
    """Having a def for a law is not the same as proving it."""
    files = {
        SOLUTION_FILE: two_law.reference_solution,
        PROOF_FILE: two_law.proof_header + "\ndef L.add_zero(x):\n  ?TODO\n",
    }
    verdict = check_submission(two_law, toolchain, files)
    assert verdict.proven == ()
    assert verdict.tier == TIER_CHECKS


def test_a_broken_proof_of_one_law_still_credits_the_other(toolchain, two_law):
    """The fixed point, which is the only reason partial credit is sound.

    The full run stops at the first type error, so it cannot say that the
    other law was fine. Isolating each law does -- and a law is credited only
    when an isolation run leaves exactly the uncredited laws open.
    """
    laws = two_law.laws
    files = {
        SOLUTION_FILE: two_law.reference_solution,
        PROOF_FILE: two_law.proof_header + (
            "\ndef L.add_zero(x):\n"
            "  match x:\n"
            "    case 0n:\n"
            "      {==}\n"
            "    case 1n+p:\n"
            "      %L.add_zero(p) : {1n+S.add(p, 0n) == 1n+_ : Nat}\n"
            "      {==}\n"
            # wrong: the goal is not reflexive, so this is a type error rather
            # than a hole -- which is what forces the isolation runs
            "\ndef L.add_succ(x, y):\n  {==}\n"),
    }
    verdict = check_submission(two_law, toolchain, files)
    assert verdict.tier == TIER_PARTIAL
    assert verdict.proven == (laws[0],)
    assert verdict.reward == pytest.approx(0.35)
    assert len(verdict.checks) > 1


def test_two_laws_that_prove_each_other_are_neither_credited(toolchain, two_law):
    """A circular pair cannot earn credit, because order forbids it.

    book_valid registers each def only after checking it, so a def may cite
    only laws declared earlier. Each isolation run therefore fails: whichever
    law is being credited cites one that is not. Soundness does not depend on
    the fixed point noticing the cycle -- it cannot arise.
    """
    laws = two_law.laws
    files = {
        SOLUTION_FILE: two_law.reference_solution,
        PROOF_FILE: two_law.proof_header + (
            "\ndef L.add_zero(x):\n"
            "  %L.add_succ(x, 0n) : {S.add(x, 0n) == _ : Nat}\n"
            "\ndef L.add_succ(x, y):\n"
            "  %L.add_zero(x) : {S.add(x, 1n+y) == _ : Nat}\n"),
    }
    verdict = check_submission(two_law, toolchain, files)
    assert verdict.proven == ()


def test_a_proof_that_needs_a_law_it_has_not_credited_is_not_credited(
        toolchain, two_law):
    """Partial credit must not be transitive through an unproven law."""
    laws = two_law.laws
    files = {
        SOLUTION_FILE: two_law.reference_solution,
        PROOF_FILE: two_law.proof_header + (
            # add_succ leans on add_zero; add_zero is never written
            "\ndef L.add_succ(x, y):\n"
            "  %L.add_zero(x) : {S.add(x, 1n+y) == _ : Nat}\n"),
    }
    verdict = check_submission(two_law, toolchain, files)
    assert verdict.proven == ()


def test_deriving_every_law_but_via_a_hole_earns_nothing(toolchain, two_law):
    files = {
        SOLUTION_FILE: two_law.reference_solution,
        PROOF_FILE: two_law.proof_header + (
            "\ndef L.add_zero(x):\n  ?TODO\n"
            "\ndef L.add_succ(x, y):\n  ?TODO\n"),
    }
    verdict = check_submission(two_law, toolchain, files)
    assert verdict.proven == ()
    assert verdict.tier == TIER_CHECKS
    assert verdict.reward == pytest.approx(0.1)


# --- the mutant tripwire --------------------------------------------------------

@pytest.fixture
def self_mutated(make_task, tmp_path, task):
    """A task whose mutant corpus contains its own reference solution.

    That is the shape a checker soundness bug takes: the laws accept a solution
    the author already recorded as wrong. V2 rejects such a task at authoring
    time; this asks what the episode does if one gets through anyway.
    """
    references = tmp_path / "references"
    (references / "mutants").mkdir(parents=True)
    (references / SOLUTION_FILE).write_text(task.reference_solution)
    (references / PROOF_FILE).write_text(task.reference_proof)
    (references / "mutants" / "the-reference.bend").write_text(
        task.reference_solution)
    return make_task(references=references)


def test_a_mutant_that_scores_keeps_its_tier_and_loses_its_reward(
        toolchain, self_mutated):
    files = {SOLUTION_FILE: self_mutated.reference_solution,
             PROOF_FILE: self_mutated.reference_proof}
    verdict = check_submission(self_mutated, toolchain, files)
    # The tier is the evidence, so it is left as computed; only the reward is
    # withheld. Filing the case needs to say how far the bug got.
    assert verdict.tier == TIER_COMPLETE
    assert verdict.reward == 0.0
    assert verdict.incident is not None
    assert "the-reference.bend" in verdict.incident
    assert verdict.to_json()["incident"] == verdict.incident


def test_matching_a_mutant_without_proving_anything_is_not_an_incident(
        toolchain, self_mutated):
    """A mutant that proves nothing has not got past the laws."""
    files = {SOLUTION_FILE: self_mutated.reference_solution,
             PROOF_FILE: self_mutated.proof_header}
    verdict = check_submission(self_mutated, toolchain, files)
    assert verdict.tier < TIER_PARTIAL
    assert verdict.incident is None


def test_a_solution_that_is_not_a_mutant_is_never_flagged(toolchain, task):
    """The comparison is on the whole file, so a near miss is just a submission."""
    files = {SOLUTION_FILE: task.reference_solution + "\n",
             PROOF_FILE: task.reference_proof}
    verdict = check_submission(task, toolchain, files)
    assert verdict.incident is None


# --- the pin -------------------------------------------------------------------

def test_the_toolchain_matches_its_pin(toolchain):
    recorded = (TOOLCHAIN_DIR / f"{toolchain.version}.sha256").read_text().split()[0]
    assert toolchain.tree_hash == recorded


def test_a_modified_toolchain_is_refused(toolchain, tmp_path):
    root = tmp_path / "toolchain"
    shutil.copytree(toolchain.root, root / toolchain.version)
    (root / f"{toolchain.version}.sha256").write_text(toolchain.tree_hash + "\n")
    shutil.copy(TOOLCHAIN_DIR / "bun.version", root / "bun.version")
    Toolchain.load(toolchain.version, root=root)      # unmodified: fine
    victim = root / toolchain.version / "bend2" / "bend.ts"
    victim.write_text(victim.read_text() + "\n// tampered\n")
    with pytest.raises(ToolchainError, match="does not match its pin"):
        Toolchain.load(toolchain.version, root=root)
