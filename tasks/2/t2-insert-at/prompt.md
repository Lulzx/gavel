Implement `insert_at` on lists of `Nat`, then prove the four laws about it.

`insert_at(n, xs, y)` puts `y` into `xs` at position `n`, counting from the
front, and leaves the order of everything else alone. `insert_at(2n, [1n, 2n,
3n], 9n)` is `[1n, 2n, 9n, 3n]`. Recurse on the count: `0n` puts `y` in front of
the whole list, and `1n + p` keeps the head it passed and recurses on the tail at
`p`. The count can run past the end of the list, and then there is no element
for `y` to stand in front of, so `y` goes on the end: `insert_at(9n, [1n],
9n)` is `[1n, 9n]`. `P.append`, `P.take` and `P.drop` come from the prelude.

`P.take(n, xs)` and `P.drop(n, xs)` match on their first argument, the count,
and only then on the list, so `take(0n, xs)` answers `Nil{}` whatever `xs` is
and a successor count against a variable list does not step.

The law `insert_at_zero` fixes the answer at position zero. Its left-hand side
is ground in the count, so it is the case no step law reaches, and it is the
law that rules out a body whose `0n` case dropped `y`.

The law `insert_at_nil` fixes the other case where a match has already stopped:
a count past the end of the list. The cons law names its list as `h <> t`, so
neither it nor `insert_at_zero` covers this answer, and a body that answered
`Nil{}` here would satisfy the other three while throwing `y` away.

The law `insert_at_cons` is the step, and it is definitional: it is the
definition written out, and it is what makes the count mean a position.

The law `insert_at_take_drop` is the one with content: inserting at `n` is the
first `n` elements, then the new element, then everything the list had left. It
is inductive in the count. `take` and `drop` match on their first argument, so
with a variable count the right-hand side does not reduce on its own, and the
hypothesis has to be applied at the predecessor and the tail. A body that
ignored `n` and consed `y` onto the front -- or onto the end -- satisfies every
other law here and fails this one.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.insert_at_zero(xs, y)`, `def L.insert_at_nil(n, y)`,
`def L.insert_at_cons(n, h, t, y)` and
`def L.insert_at_take_drop(n, xs, y)`.
