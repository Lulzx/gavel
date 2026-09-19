# HAND MUTANT (2026-09-19, tag g1). Target: `dot_nil_left`. The first list
# running out ends the walk, and this is the branch that says the answer there is
# `0n`; this body answers `1n` instead, which is the mistake that reads the empty
# list as one pair rather than none. The generator rewrites a *step*, and the
# empty case is an answer reached by a match that has already stopped, so no
# generated mutant reaches it.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g1.json check
# t2-dot-laws --solution <this file> --proof references/t2-dot-laws/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["dot_nil_left",
# "dot_nil_right"]` -- the second because `dot(xs, Nil{})` reaches `Nil{}` for
# `xs` on the way down as well.
import Base
import ./prelude.bend as P

def dot(xs: List<Nat>, ys: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case h <> t:
      match ys:
        case Nil{}:
          0n
        case k <> u:
          Nat.mul(h, k) + dot(t, u)
