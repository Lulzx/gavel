Implement `rotate` on lists of `Nat`, then prove all three laws.

`rotate(n, xs)` moves the first `n` elements of `xs` to the back, one at a time.
So `rotate(2n, [1n, 2n, 3n])` is `[3n, 1n, 2n]`. It rotates to the left: one
rotation takes the head off the list and puts it on the end of the tail, so
`rotate(1n, [1n, 2n, 3n])` is `[2n, 3n, 1n]`. Recurse on `n`: `0n` answers `xs`
itself, and `1n + p` moves the head to the back and recurses on `p`. The head
comes round to the end rather than falling off, so no element is ever lost and
the recursion is driven by `n` alone -- but the rotation can still run out of
list, and the empty list has nothing to move. That is why the `1n + p` case has
to look at `xs` before it recurses: `rotate(n, Nil{})` is `Nil{}` for every `n`.
The list argument is declared reusably (`+xs`) because the `0n` case reads it
and the successor case reads it again.

`P.append(xs, ys)` is `xs` followed by `ys`, and it is given in `prelude.bend`.

`rotate_zero` fixes the answer at `0n`, and it is a pin: the step law below is
stated at `1n + n`, so it never reaches the input where nothing is rotated, and
a body whose `0n` case dropped the list would be caught only here.

`rotate_succ` is the step, and it is the law that says where the elements go:
one rotation cuts the head off and appends it to the tail, and the remaining `n`
rotations carry on from the resulting list. The list is named as `x <> t` rather
than left as a variable, because a rotation of a variable list has no first
element to move. Both sides compute, so it is definitional. A body that appended
the head to the *front*, or that recursed on `t` -- dropping the head and with
it an element -- leaves the two sides unconvertible here.

`rotate_nil` is the empty-list half, and it is the one law here that is not
definitional: `n` is a variable, so `rotate` cannot take a step and the two
sides do not compute. The induction on `n` is the proof, and neither case needs
the hypothesis -- the `0n` case is the list itself and the successor case finds
nothing to move. It pins the input the step law cannot reach, since that law is
stated at `x <> t` and so constrains only non-empty lists.

Together the three determine `rotate` on every input, by induction on `n`: at
`0n` the answer is `rotate_zero`, at `1n + p` it is `rotate_succ` applied to
`p`, which is smaller, and the empty list is `rotate_nil` at every `n`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.rotate_zero(xs)`, `def L.rotate_succ(n, x, t)` and
`def L.rotate_nil(n)`.
