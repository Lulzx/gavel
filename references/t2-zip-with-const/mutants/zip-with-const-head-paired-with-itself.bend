import Base
import ./prelude.bend as P

# `zip_with_const` builds each pair out of the element alone: the second
# component is the element rather than the constant, so the answer is a list of
# doubled elements. The empty case is the reference's.
#
# This file exists because the generated corpus's one well-typed mutant -- the
# `constant-body` rewrite, which copies the empty answer into every case -- is
# the only other card played against the step, and it is the empty answer: on an
# empty list a doubled list is empty too, so nothing here distinguishes the
# second component. This body reads the constant exactly once, in the recursive
# call, so the signature is the reference's and it type-checks, and it does
# distinguish: the element is in the second component where the constant belongs.
#
# Measured against this task's law set: tier 3, failing `zip_with_const_step`
# and `zip_with_const_snds`. The `fsts` law survives it, since the first
# component is still the element.
def zip_with_const(xs: List<Nat>, +k: Nat) -> List<&2, P.Pair>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> t:
      P.MkPair{h, h} <> zip_with_const(t, k)
