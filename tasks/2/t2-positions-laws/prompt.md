Implement `positions` on lists of `Nat`, then prove the four laws about it.

`positions(x, xs)` collects the positions at which `x` occurs in `xs`, counting
from `0n` and in the order the occurrences come: `positions(5n, [5n, 4n, 5n])`
is `[0n, 2n]`, and `positions(5n, [4n, 6n])` is `Nil{}`. Recurse on the list:
the empty list has no positions, and a cons cell either has its head at position
`0n` -- followed by the positions of the tail, each shifted along by one -- or
has nothing at `0n` and is the shifted positions of the tail alone.

`P.eq(a, b)` is the `Bool` comparison on `Nat` and `P.at_if(b, x, y)` is the
decision taken on it, answering `x` when `b` is `True{}` and `y` otherwise. The
decision has to be handed to a def rather than taken where it is made, because
of a Bend restriction rather than for convenience: **a `match` cannot scrutinise
a computed value**, so a cons step that needs two different answers picked by a
`Bool` it just computed is not a thing you can write inline. `P.inc_all(xs)`
steps every element of `xs` up by one, which is what moves a list of positions
along when an element in front of them is counted.

The law `positions_nil` fixes the answer on the empty list. Both sides compute,
so it is definitional, and it is the law that pins the one input the three laws
below never reach -- they each name their list as a cons cell or as `inc_all` of
a variable.

The law `positions_step` is the unfolding of a cons cell: the head compared with
the target, and one of two answers, `0n` in front of the shifted tail or the
shifted tail alone. This is the law that says the order is the order the
occurrences come in -- the head's position is the smallest one and it is
recorded at the front. It says nothing about a hit, because `P.eq(k, k)` is
stuck where both arguments are the same variable.

The law `positions_hit` is the one that says a hit *contributes a position*
rather than merely not being excluded: an element equal to the target at the
head is at `0n`, and the rest of the answer is the tail's positions shifted
along. `positions_step` is stated for a variable head and a variable target, so
it never unfolds a comparison on its own. Its proof needs a fact about `P.eq`
that the law's own left-hand side cannot step to -- `P.eq` is equid on a
variable only by induction on the variable -- so any def stating that fact goes
under the reserved `Policy.` namespace, which the gate ignores.

The law `positions_miss` is the not-found case. Nothing in `P.inc_all(xs)` is
`0n`, so the target occurs at no position and the answer is the empty list --
the same answer the empty list itself gives, reached the same way. The list is a
variable, so this one is the induction on `xs`, and it is the law that pins the
*value* of a miss: a body that recorded a position for every element, or that
counted from `1n`, keeps the two sides apart.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.positions_nil(x)`, `def L.positions_step(h, x, t)`,
`def L.positions_hit(k, t)` and `def L.positions_miss(xs)`.
