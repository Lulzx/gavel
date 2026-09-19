import Base
import ./prelude.bend as P

# An independently invented plausible-but-wrong body: `distinct` keeps its head
# but starts the walk with an empty seen set, forgetting that the head it just
# kept is itself something a later element can duplicate. The first element is
# kept twice whenever it occurs again, so `[1n, 2n, 1n]` answers `[1n, 2n, 1n]`.
# The walk itself is the reference's, so every law stated over the walk alone --
# its empty arm, its step, and the induction over lists of equal elements -- is
# still proved, and only the three laws that reach the answer of `distinct`
# catch it.
#
# Measured against this task's law set: tier 3, failing `distinct_cons`,
# `distinct_same` and `distinct_nonadjacent`. Tier 4 would mean the law set
# admits a wrong body; it does not.
def distinct_go(xs: List<&2, Nat>, +seen: List<&2, Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      P.skip_if(P.mem(seen, h), h, distinct_go(t, h <> seen))

def distinct(xs: List<&2, Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      h <> distinct_go(t, Nil{})
