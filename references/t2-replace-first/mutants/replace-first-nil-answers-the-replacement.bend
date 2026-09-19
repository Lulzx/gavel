import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `replace_first_nil` (and, through it, the two other laws
# that reach the end of a walk). An empty list has nothing to replace, so the
# answer is `Nil{}`; this body answers the replacement in front of an empty list
# instead -- the reading that a replacement was still owed when the walk ran out
# of elements. It is the answer of the match's first case, which the generated
# corpus's step rewrites never reach; without it, `replace_first_nil` had no
# mutant failing it while every stage reported the task valid.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i1.json check
# t2-replace-first --solution <this file> --proof
# references/t2-replace-first/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["replace_first_nil", "replace_first_len",
# "replace_first_absent"]`. The first of those is the law with no other killer:
# the three are the laws that read the empty list.
def replace_first(xs: List<&2, Nat>, +k: Nat, +y: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      y <> Nil{}
    case +h <> +t:
      P.rp_branch(P.eq(h, k), h, y, t, replace_first(t, k, y))
