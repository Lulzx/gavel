import Base
import ./prelude.bend as P

# TODO(policy): implement. `zl_pad_left(ys, d)` is the walk for the case where
# the second list still has elements and the first has run out: every element of
# `ys` is paired with `d` on its left. It answers `Nil{}` when there is nothing
# left to pad, and otherwise emits `MkPair{d, h}` in front of the walk on the
# tail. It is a separate function rather than a branch of `zip_longest` because
# a recursive call is only accepted when the argument it matches on is the one
# that shrinks, and `zip_longest(Nil{}, t, d)` shrinks the *second* argument;
# splitting the padding off keeps every self-call shrinking the first.
#
# `d` is read twice in the step -- once in the pair and once by the recursive
# call -- so it is declared reusable.
def zl_pad_left(ys: List<&2, Nat>, +d: Nat) -> List<&2, P.Pair>:
  ?TODO

# TODO(policy): implement. `zl_pad_right(xs, d)` is the same walk for the other
# side: `xs` still has elements and the second list has run out, so every
# element of `xs` is paired with `d` on its right. The step emits
# `MkPair{h, d}` -- the mirror of the pair above -- in front of the walk on the
# tail.
#
# `d` is read twice in the step, so it is declared reusable.
def zl_pad_right(xs: List<&2, Nat>, +d: Nat) -> List<&2, P.Pair>:
  ?TODO

# TODO(policy): implement. `zip_longest(xs, ys, d)` is the answer: the two lists
# zipped together, running to the end of the longer one, with `d` standing in
# for the element of whichever list ran out. Step on the first list and then on
# the second. While both have elements the two heads are packed together and the
# walk continues on both tails. When the first runs out the second is padded on
# its left; when the second runs out the first is padded on its right.
#
# Only the first list is matched by this function, so a self-call on the two
# tails shrinks the argument it matches on and is accepted. `d` is read twice in
# the branch where the second list has run out, so it is declared reusable.
def zip_longest(xs: List<&2, Nat>, ys: List<&2, Nat>, +d: Nat) -> List<&2, P.Pair>:
  ?TODO
