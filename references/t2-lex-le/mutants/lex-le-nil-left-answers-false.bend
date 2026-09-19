import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `lex_le_nil_left`. The empty list is at or before every
# list, so the walk's `Nil{}` case answers `True{}`; this body answers `False{}`
# there instead. It is the answer of the match's first case, which the
# generator's rules do not rewrite -- the other eleven corpus entries fail to
# type-check instead -- and no other law applies `lex_le` to a `Nil{}` on the
# left, so this law has no kill without this file.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.h2.json check
# t2-lex-le --solution <this file> --proof references/t2-lex-le/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["lex_le_nil_left",
# "lex_le_self", "lex_le_append"]`. The two inductions go too, because both
# bottom out at a comparison of the empty list with itself.
def lex_le(xs: List<&2, Nat>, ys: List<&2, Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case +h <> t:
      match ys:
        case Nil{}:
          False{}
        case +k <> u:
          Bool.or(P.lt(h, k), Bool.and(P.eq(h, k), lex_le(t, u)))
