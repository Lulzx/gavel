import Base
import ./prelude.bend as P

# `zip_with_const` packs a pair at the empty list instead of answering nothing:
# the cons case is the reference's, and the empty case answers the constant
# packed with a zero.
#
# This file exists for a law that no other mutant fails. `zip_with_const_nil` is
# the only law whose left-hand side is the ground `Nil{}`, so it is the one law
# a walk of the list never reaches: the generated `constant-body` mutant copies
# the empty case's answer into the cons case and leaves the empty case alone, so
# it satisfies the pin, and every other generated rewrite stops before the base
# case. The constant is still read exactly once here, so the signature is the
# reference's and the body type-checks.
#
# Measured against this task's law set: tier 3, failing `zip_with_const_nil`,
# `zip_with_const_fsts` and `zip_with_const_snds`. The last two go with the pin:
# at the empty list the answer now holds a pair, so `P.fsts` of it is `0n <> Nil{}`
# rather than `Nil{}` and `P.snds` of it is `k <> Nil{}` rather than the `P.repeat`
# of a zero length.
def zip_with_const(xs: List<Nat>, +k: Nat) -> List<&2, P.Pair>:
  match xs:
    case Nil{}:
      P.MkPair{0n, k} <> Nil{}
    case h <> t:
      P.MkPair{h, k} <> zip_with_const(t, k)
