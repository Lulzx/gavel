import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `lex_le_nil_right`. A non-empty list against the empty
# one is *not* at or before it, so the walk's inner `Nil{}` case answers
# `False{}`; this body answers `True{}` there instead -- the reading that says a
# list running out on the left makes it the smaller, applied to the wrong side.
# It is the only law whose left-hand side is ground in its second argument and
# the step law names a cons cell there, so no other law reaches this case: this
# law has no kill without this file.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.h2.json check
# t2-lex-le --solution <this file> --proof references/t2-lex-le/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["lex_le_nil_right"]`.
# One law, and no induction: both inductions compare a list with an extension of
# itself, so the second list never runs out under the walk.
def lex_le(xs: List<&2, Nat>, ys: List<&2, Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case +h <> t:
      match ys:
        case Nil{}:
          True{}
        case +k <> u:
          Bool.or(P.lt(h, k), Bool.and(P.eq(h, k), lex_le(t, u)))
