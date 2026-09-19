Implement `swap_adjacent`, which exchanges the elements of every neighbouring
pair, then prove the laws that pin it.

`swap_adjacent(xs)` must return `xs` with each pair of neighbours the other way
round, so `swap_adjacent(1n <> (2n <> (3n <> (4n <> Nil{}))))` is
`2n <> (1n <> (4n <> (3n <> Nil{})))`. Recurse on the list: `Nil{}` and a
one-element list have no pair to exchange and answer themselves, and a list of
two or more answers its second element in front of its first, in front of the
swaps of everything from the third element on. Count the input twice -- the odd
tail is *kept*, not dropped -- so a one-element list is not the empty list here.

The law `swap_adjacent_nil` fixes the answer on the empty list. It is the pin on
the case generated mutants reach least: the step law below names two elements or
more, so a body that answered a non-empty list at `Nil{}` is caught here and
nowhere else.

The law `swap_adjacent_single` fixes the answer on a one-element list: the
element is kept, and it is the only law that says so. The step law names lists
of two or more, so a body that dropped the odd element, or that answered the
empty list there, satisfies the step law and contradicts this one.

The law `swap_adjacent_cons` is the step. It says which element goes where: the
second in front of the first, in front of the swaps of the rest. It is the only
law that distinguishes this function from one that left the list alone.

The law `swap_adjacent_len` says the result has as many elements as the input.
It is inductive in the list, and it is the law that pins the count: a body that
dropped the odd tail, or that exchanged elements across pairs and lost one,
satisfies the step law and fails this one.

The law `swap_adjacent_involutive` says that swapping twice is the identity.
It is inductive too, and it is the law that pins the *shape* of the answer
rather than its contents: a body that reversed the list agrees with the step law
on the first two elements and disagrees here.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.swap_adjacent_nil()`, `def L.swap_adjacent_single(x)`,
`def L.swap_adjacent_cons(x, y, t)`, `def L.swap_adjacent_len(xs)` and
`def L.swap_adjacent_involutive(xs)`.
