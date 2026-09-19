Implement `indices_of` on a list of `Nat`, then prove all four laws.

`indices_of(xs, k)` is the list of every position at which `xs` holds `k`,
ascending from `0n`:

    indices_of([5n, 7n, 5n], 5n)  ==  [0n, 2n]
    indices_of([5n, 7n, 5n], 9n)  ==  []

Recurse on the list: `Nil{}` answers the empty list, and a cons cell compares
its head with the target and either conses the position `0n` onto the positions
of the tail or answers the positions of the tail alone. Either way the tail's
positions are *shifted*: every one of them sits one place further along than it
did in the tail, so the answer ascends. The list is the argument that shrinks,
and in Bend the shrinking argument has to come before an argument that is only
read, so the list comes first and the target second.

The comparison is the prelude's `P.eq` and the decision is taken by
`P.cons_if`, which matches on the value it is handed and either conses `0n` onto
an answer or leaves it alone. A match cannot scrutinise a computed value where
it is written, so the comparison is passed to `P.cons_if` rather than matched on
in place; that is the only reason the two definitions exist. The target is read
twice in the step, once into the comparison and once into the recursive call, so
it is declared reusably (`+k`).

The prelude is immutable and already has the vocabulary the laws are stated in:
`P.eq`, the comparison; `P.cons_if`, the decision; and `P.inc_all`, which steps
every element up by one, so that a list it is applied to has no `0n` in it at
all.

`indices_of_nil` pins the empty input. It is the only law whose left-hand side
is a closed list, and it fixes the answer there, which the step law below never
reaches.

`indices_of_step` is the step, and it is definitional: the head is compared with
the target, and the two answers are `0n` consed onto the shifted tail and the
shifted tail alone. It is the law that says the answer counts positions -- the
head is the element compared, and everything behind it is one further along.

`indices_of_hit` is the found-at-head case: an element at the head is at
position `0n`, and the rest of the answer is the shifted tail. The step law is
stated for a variable `k`, so it never unfolds a comparison on its own --
`P.eq(k, k)` is stuck where the two arguments are the same variable -- and this
is the law that says the comparison decides `True{}` there, and that a hit
contributes `0n` in front and nothing else.

`indices_of_miss` is the no-occurrence case. Searching a list in which nothing
is `0n` finds nothing, so the answer is the empty list. This is the induction,
and it fixes what a miss contributes: the step law leaves the answer at the
empty list free, and a body that answered a position at a miss -- or a constant
of the wrong shape at the empty list -- satisfies neither of the two laws above
nor this one.

Together the laws determine the body: the empty list is fixed, the step says
what a cons cell becomes, the hit says the comparison is not reversed and that
the position comes first, and the miss says a miss contributes no position.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.indices_of_nil(k)`, `def L.indices_of_step(h, k, t)`, `def
L.indices_of_hit(k, t)` and `def L.indices_of_miss(xs)`.
