# HAND MUTANT (2026-09-19, tag f1). Target: `count_runs_single`. A one-element
# list is one run, and this is the branch that says so; this body answers `0n`
# there instead, which is the mistake that counts only the boundaries and forgets
# that the elements themselves are a run. The empty list is untouched and the
# two-elements-and-more branch is untouched, so the three other laws survive it:
# `count_runs_same` and `count_runs_diff` are stated at two or more elements, and
# `count_runs_nil` is the other case.
#
# Measured 2026-09-19: **tier 3**, `laws_failed = ["count_runs_single"]` -- one
# law, the one named above, and the refutation is definitional: `1n` against `0n`.
import Base
import ./prelude.bend as P

def count_runs(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      match t:
        case Nil{}:
          0n
        case +h2 <> t2:
          P.nsub(1n, P.is_eq(h, h2)) + count_runs(h2 <> t2)
