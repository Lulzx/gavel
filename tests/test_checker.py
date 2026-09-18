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

import pytest

from gavel.check import check_submission
from gavel.runner import SUCCESS_LINE, UNSAFE_MARK, Limits, run_check, scrub_env
from gavel.tasks import (PROOF_FILE, SOLUTION_FILE, cleanup, prepare_workdir)
from gavel.toolchain import TOOLCHAIN_DIR, Toolchain, ToolchainError
from gavel.verdict import (TIER_CHECKS, TIER_COMPLETE, TIER_NO_CHECK,
                           TIER_PARTIAL, TIER_REJECTED)

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
                              "\n@unsafe\ndef L.add_zero(x):\n  L.add_zero(x)\n")
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
    submission[PROOF_FILE] = task.proof_header + "\ndef L.add_zero(x):\n  ?TODO\n"
    workdir = run_dir(submission)
    result = run_check(toolchain, workdir, PROOF_FILE)
    assert result.todo_count == 1
    assert not result.ok


def test_only_the_first_type_error_is_reported(toolchain, task, submission, run_dir):
    """Why partial credit needs isolation runs rather than one clever parse."""
    submission[SOLUTION_FILE] = (
        'import Base\n\ndef add(a: Nat, b: Nat) -> Nat:\n  "not a Nat"\n')
    submission[PROOF_FILE] = (
        task.proof_header + '\ndef L.add_zero(x):\n  "also not a proof"\n')
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
                              "\n@unsafe\ndef L.add_zero(x):\n  {==}\n")
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
