import Base
import ./prelude.bend as P

# PROBE. The plausible wrong answer: a body that treats two heads as a tie
# whenever the first is not strictly below the second, so the comparison falls
# through to the tails without ever asking whether the heads are equal. It is
# the reading a policy that took `P.lt` for the whole decision would write --
# the equality test looks like a redundant restatement of "not less" -- and it
# is the body the `lex_le_cons` law exists to separate. Read the verdict: **tier
# 3** means the law set catches it; tier 4 means the task pays full reward for
# it and the law set has a hole.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.h2.json check
# t2-lex-le --solution <this file> --proof references/t2-lex-le/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["lex_le_cons",
# "lex_le_self", "lex_le_append"]`. No hole: the two anchor laws survive -- the
# body still answers `True{}` to the empty list and `False{}` to a list that
# runs out on the right -- and the `lex_le_cons` law is the one that exists to
# catch it.
def lex_le(xs: List<&2, Nat>, ys: List<&2, Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      match ys:
        case Nil{}:
          False{}
        case k <> u:
          Bool.or(P.lt(h, k), lex_le(t, u))
