import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a list with nothing in it has no blocks, whatever the size. The empty
# list is the first arm of the entry point, so this is definitional, and it is
# the pin: nothing else here applies either function to `Nil{}`.
law chunks_nil:
  for n: Nat
  {S.chunks(Nil{}, n) == Nil{} : List<&2, List<&2, Nat>>}

# LAW: a size of `0n` forms no blocks, whatever the list. It is the pin on the
# other arm the recursion stops at, and it is an induction in `xs`, because the
# entry point looks at the list before it looks at the size.
law chunks_zero:
  for xs: List<&2, Nat>
  {S.chunks(xs, 0n) == Nil{} : List<&2, List<&2, Nat>>}

# LAW: one element split by a size of one is one block holding that element.
# This is the first law whose two sides are both values rather than calls, so it
# is the first that says where an element *lands* rather than how many blocks
# there are.
law chunks_single:
  for x: Nat
  {S.chunks(x <> Nil{}, 1n) == (x <> Nil{}) <> Nil{} : List<&2, List<&2, Nat>>}

# LAW: a closed value. Three elements split by two is one full block and then a
# short one, and the two sides are both literals, so the checker computes them.
# A cardinality cannot see a placement -- "two blocks, the last one shorter"
# is also true of a body that put the first two elements in the wrong order,
# or that dropped the last block and split the first three the other way -- and
# this law is the one that does see it, because both sides are written out.
law chunks_three_by_two:
  {S.chunks(1n <> (2n <> (3n <> Nil{})), 2n)
     == (1n <> (2n <> Nil{})) <> ((3n <> Nil{}) <> Nil{}) : List<&2, List<&2, Nat>>}

# LAW: an element with a slot left joins the block being built. This is the
# first of the two laws about the worker, and it fixes what the recursion does
# while the block is not yet full -- `1n + k` is a successor, so the match takes
# that arm, and both sides are the same self-call.
law chunks_go_fill:
  for x: Nat
  for xs: List<&2, Nat>
  for n: Nat
  for k: Nat
  for cur: List<&2, Nat>
  for out: List<&2, List<&2, Nat>>
  {S.chunks_go(x <> xs, n, 1n + k, cur, out) == S.chunks_go(xs, n, k, P.snoc(cur, x), out) : List<&2, List<&2, Nat>>}

# LAW: an element with no slot left closes the block being built and opens a new
# one, which is what makes a block exactly `n` elements long. `0n` is the arm
# the match takes here, and the size below it is what the new block has left.
# Together with the law above this fixes the worker on every input: one of the
# two arms is taken for every `k`.
law chunks_go_close:
  for x: Nat
  for xs: List<&2, Nat>
  for n: Nat
  for cur: List<&2, Nat>
  for out: List<&2, List<&2, Nat>>
  {S.chunks_go(x <> xs, n, 0n, cur, out) == S.chunks_go(xs, n, Nat.sub(n, 1n), x <> Nil{}, P.push(out, cur)) : List<&2, List<&2, Nat>>}
