import Base
import ./prelude.bend as P

# TODO(policy): implement. `zip_with_const(xs, k)` packs every element of `xs`
# with the constant `k`, in the order the elements came, so the answer has as
# many pairs as the input had elements and every second component is `k`.
#
# Recurse on the list: `Nil{}` answers `Nil{}`; a cons cell answers
# `P.MkPair{h, k}` -- its own element packed with the constant -- in front of
# the pairs of the tail. The constant is read twice in the step, once into the
# pair and once into the recursive call, so it is declared reusably (`+k`).
#
# `P.fsts` and `P.snds` read a list of pairs back as its two components,
# `P.len` counts a list of `Nat` and `P.repeat` builds the list of a constant
# repeated; the last two laws state the answer against those.
def zip_with_const(xs: List<Nat>, +k: Nat) -> List<&2, P.Pair>:
  ?TODO
