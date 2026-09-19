import Base
import ./prelude.bend as P
import ./solution.bend as S

# The laws are the specification of `sum_adjacent`. The answer is read off the
# successive pairs of the input: the empty list and a one-element list have no
# pair and answer `Nil{}`, and from two elements on the answer is the sum of the
# first two in front of the sums of everything from the second on. The answer is
# therefore one element shorter than the input, and its `i`th element is the sum
# of the `i`th and `i+1`th elements of the input.

# The anchor at the bottom of the input: no elements, no successive pair. Both
# sides compute, and the right-hand side calls no target; this is the one law
# whose left-hand side is a ground term and whose answer is not read off
# another.
law sum_adjacent_nil:
  {S.sum_adjacent(Nil{}) == Nil{} : List<&2, Nat>}

# The other anchor: one element has no *successive* pair either, so the answer
# is `Nil{}` and not the element itself. Both sides compute, and the right-hand
# side calls no target. This is the law that separates a body which read the
# first element as a pair with nothing -- or which answered the input's head
# when there is no pair at all -- from the walk here.
law sum_adjacent_single:
  for x: Nat
  {S.sum_adjacent(x <> Nil{}) == Nil{} : List<&2, Nat>}

# The step, and the law that says *which* sums come out and where the recursion
# restarts. From two elements on, the answer starts with the sum of the first
# two and continues with the sums of everything from the second element on --
# not from the third, and not with the pair's second element alone. A body that
# summed the wrong neighbours, or that dropped a cell, has a different unfolding
# here.
law sum_adjacent_cons:
  for h: Nat
  for +k: Nat
  for +u: List<&2, Nat>
  {S.sum_adjacent(h <> (k <> u)) == h + k <> S.sum_adjacent(k <> u) : List<&2, Nat>}

# Content, at the shortest input that has a pair, with both elements variables:
# the answer of a two-element list is exactly the one sum, and not that sum
# followed by anything. This is the law that pins the answer's *tail* at a pair
# whose values are not known, which no closed law can.
law sum_adjacent_pair:
  for +x: Nat
  for +y: Nat
  {S.sum_adjacent(x <> (y <> Nil{})) == (x + y) <> Nil{} : List<&2, Nat>}

# Content, and the count half of the pair above: the answer is exactly one
# element shorter than the input, whatever the input is. It is the law that is
# not definitional -- `sum_adjacent` is stuck on a variable `x` on the front and
# on a variable tail, so the induction is the proof -- and it is what separates
# a body that answered one sum too many, or that kept one element of the input
# as well as its sums.
law sum_adjacent_len:
  for xs: List<&2, Nat>
  for x: Nat
  {P.len(S.sum_adjacent(x <> xs)) == P.len(xs) : Nat}

# Content, at a closed input of three elements: the sums are `1n + 2n` and
# `2n + 3n`, in that order. A body that answered them in the other order, or
# that answered only the first, is separated here. Both sides are closed and the
# left-hand side is a ground term.
law sum_adjacent_three:
  {S.sum_adjacent(1n <> (2n <> (3n <> Nil{}))) == 3n <> (5n <> Nil{}) : List<&2, Nat>}
