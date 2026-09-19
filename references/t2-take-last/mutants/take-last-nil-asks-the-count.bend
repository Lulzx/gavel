import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `take_last_nil`. The law is definitional for every body
# that answers `Nil{}` there, and `Nil{}` is the only list an empty list can
# answer, so the body that breaks it is the one that does not answer *at all*
# yet: this one asks the same question the cons case asks -- is this list short
# enough to be the answer? -- of the empty list, and hands the answer to
# `P.keep_if`. The empty list is always short enough, but the comparison is not
# reducible while `k` is a variable, so the branch is a stuck call and not the
# empty list the law names. It is the shape a body written as one uniform rule
# per case has, and it is why the law is stated with a variable `k` rather than
# at a closed count.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i1.json check
# t2-take-last --solution <this file> --proof references/t2-take-last/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["take_last_nil",
# "take_last_long"]`. It is the only file in the corpus that separates
# `take_last_nil` at all -- without it the law is zero-kill -- and the second
# law falls with it because its `Nil{}` instance is the same empty list.
def take_last(xs: List<&2, Nat>, +k: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      P.keep_if(P.le(P.len(Nil{}), k), Nil{}, Nil{})
    case +h <> +t:
      P.keep_if(P.le(P.len(h <> t), k), h <> t, take_last(t, k))
