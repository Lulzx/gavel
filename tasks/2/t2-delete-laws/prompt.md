Implement `delete` on lists of `Nat`, then prove the four laws about it.

`delete(x, xs)` removes the *first* element of `xs` that is `x` and keeps
everything else: `delete(5n, [4n, 5n, 5n, 6n])` is `[4n, 5n, 6n]`. The one
removed is the first, not every one and not the last. If `x` does not occur at
all, the whole list comes back in the order it was in. Recurse on the list: the
empty list has nothing to remove, and a cons cell is compared with `x` and
either answers its tail, dropping itself, or keeps its head and removes from the
tail.

`P.eq(a, b)` is the `Bool` comparison on `Nat` and `P.at_if(b, x, y)` is the
decision taken on it, answering `x` when `b` is `True{}` and `y` otherwise. The
decision has to be handed to a def rather than taken where it is made, because
of a Bend restriction rather than for convenience: **a `match` cannot scrutinise
a computed value**, so a cons step that needs two different answers picked by a
`Bool` it just computed is not a thing you can write inline. `P.inc_all(xs)`
steps every element of `xs` up by one, so none of its elements is `0n`.

The law `delete_nil` fixes the answer on the empty list. Both sides compute, so
it is definitional, and it is the law that pins the one input the three laws
below never reach -- they each name their list as a cons cell or as `inc_all` of
a variable.

The law `delete_step` is the unfolding of a cons cell: the head compared with
the target, and one of two answers, the tail or the head in front of the
recursion. A body that recursed on the wrong list, or that kept a head it had
just compared, does not have its two sides equal. It says nothing about a hit,
because `P.eq(k, k)` is stuck where both arguments are the same variable.

The law `delete_hit` is the one that says *first*: an element equal to the
target at the head is removed, and the tail survives as it stands, even when the
tail carries the target again. `delete_step` is stated for a variable head and a
variable target, so it never unfolds a comparison on its own; this is the law
that says the comparison decides `True{}` where the two sides are equal. Its
proof needs a fact about `P.eq` that the law's own left-hand side cannot step to
-- `P.eq` is equid on a variable only by induction on the variable -- so any
helper that facts goes under the reserved `Policy.` namespace, which the gate
ignores.

The law `delete_miss` is the not-found case. Nothing in `P.inc_all(xs)` is `0n`,
so there is nothing to remove and the whole list comes back. The list is a
variable, so this one is the induction on `xs`, and it is the law that pins the
*value* of a miss: a body that dropped its head on a miss, or that reordered the
list as it walked, keeps the two sides apart.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.delete_nil(x)`, `def L.delete_step(h, x, t)`, `def L.delete_hit(k, t)`
and `def L.delete_miss(xs)`.
