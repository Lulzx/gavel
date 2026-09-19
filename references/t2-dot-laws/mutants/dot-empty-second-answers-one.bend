# HAND MUTANT (2026-09-19, tag g1). Target: `dot_nil_right`. The second list
# running out ends the walk too, and this body answers `1n` at that branch
# instead of `0n` -- the mistake that charges for the pair it never formed. This
# is the branch the step law `dot_cons` cannot reach, because `dot_cons` names
# its second argument as a cons cell; with the first list a variable, the outer
# match is stuck and the answer is reached by the induction, not by a rewrite.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g1.json check
# t2-dot-laws --solution <this file> --proof references/t2-dot-laws/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["dot_nil_right"]` -- one
# law, the one named above. `dot_shorter` survives it: at `xs = Nil{}` both sides
# reduce through `P.take(0n, ys) = Nil{}` and then through the empty-first branch
# this mutant leaves alone.
import Base
import ./prelude.bend as P

def dot(xs: List<Nat>, ys: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      match ys:
        case Nil{}:
          1n
        case k <> u:
          Nat.mul(h, k) + dot(t, u)
