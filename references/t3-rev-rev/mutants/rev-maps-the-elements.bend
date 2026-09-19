import Base
import ./prelude.bend as P

# Wrong: the answer is a reversal, and every element comes back as the other one
# -- `swap01` is an involution, so the map is its own inverse and disappears
# under the double reversal. That makes the body an anti-automorphism of
# `append` that squares to the identity, which is exactly what `rev_append` and
# `rev_rev` ask for, and it has the right length for `rev_len`. The set as it
# stood said nothing about the element itself: `[0n, 1n]` reverses to
# `[1n, 0n]` and `[1n, 0n]` is what this body answers for `[0n, 1n]` too, so the
# two are indistinguishable under a permutation and a count. `rev_singleton` is
# the law that rules it out: on a one-element list there is no permutation to
# hide in, and `rev(0n <> Nil{})` here is `1n <> Nil{}`.
def Policy.swap01(x: Nat) -> Nat:
  match x:
    case 0n:
      1n
    case 1n+p:
      match p:
        case 0n:
          0n
        case 1n+q:
          1n + (1n + q)

def rev(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.snoc(rev(t), Policy.swap01(h))
