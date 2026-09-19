Implement `count_inv` on lists of `Nat`, then prove the four laws about it.

`count_inv(xs)` counts the *inversions* of `xs`: the pairs of positions `i < j`
whose elements are out of order, that is, the pairs with `xs[i] > xs[j]`. It is
a `Nat`, not a list and not a prefix length. `count_inv([3n, 1n, 2n])` is `2n`,
because the `3n` is greater than both of the elements that follow it while the
`1n` and the `2n` are in order, and `count_inv([1n, 2n, 3n])` is `0n`. A list
with no repeated element and no descent has no inversions at all.

Recurse on `xs`: `Nil{}` answers `0n`, and a cons cell answers the number of
elements of its tail that are strictly below the head, plus the number of
inversions inside that tail -- every inversion either has the head as its
earlier element or it does not. The tail is read twice, by that count and by the
recursion, so the cons pattern marks it reusable and the list type is
`List<&2, Nat>`.

The prelude is immutable and already has the vocabulary the laws are stated in:
`P.is_lt(a, b)` is `1n` when `a` is strictly below `b` and `0n` otherwise, and
`P.count_gt(x, ys)` counts the elements of `ys` that are strictly below `x`.
The comparison is strict on purpose: two equal elements are in order, so a pair
of equal neighbours is not an inversion. `P.replicate(n, x)` is the list of `n`
copies of `x`.

The law `count_inv_nil` fixes the empty answer at `0n`. Both sides compute, so
it is definitional, and it is the anchor: the step law names its argument as a
cons cell, so nothing else here reaches the empty input.

The law `count_inv_single` fixes the one-element answer at `0n` too, and it is
the other half of the anchor: the smallest input the step law can build is a
cons cell with a variable tail, so the singleton is where the step's answer
first has to agree with the empty case's. With only one element there is no pair
of positions at all, and a body that charges for a lone element is separated
here. Note that a body cannot single the singleton out by code -- a `match` on a
variable bound by a cons pattern is rejected by the checker -- so a mutant for
this law is a body that breaks the empty case instead, and this law fails with
it.

The law `count_inv_cons` is the step, and it says both what is being counted and
which way the comparison points: the tail's own count plus the tail's elements
below the head. Both sides compute, and it is the law a body that counted
elements rather than pairs, or that compared non-strictly, fails.

The law `count_inv_replicate` is about the strictness rather than about one
step: a run of copies has no inversions whatever its length, because no element
of it is below any other. It is inductive in `n`, and it is the law a body that
let equal elements count leaves unconvertible.

Together the four determine `count_inv` on every input, by induction on the
length: the first two fix the empty and the one-element answers, and the step
law fixes every longer list from its tail.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.count_inv_nil()`, `def L.count_inv_single(x)`, `def L.count_inv_cons(h,
t)` and `def L.count_inv_replicate(n, a)`. Helpers go under the reserved
`Policy.` namespace, which the gate ignores, and none of them may cite a law.
