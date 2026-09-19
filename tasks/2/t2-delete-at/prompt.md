Implement `delete_at` on lists of `Nat`, then prove the four laws about it.

`delete_at(n, xs)` drops the element at position `n` and keeps everything else:
`delete_at(1n, [4n, 5n, 6n])` is `[4n, 6n]`. Positions count from zero, so `0n`
drops the head. Recurse on `n`: at `0n` the answer is the tail of `xs`, and at
`1n + p` the head survives and the element is dropped from the tail. The count
can be larger than the list -- there is nothing there to drop -- and both of the
places the list can run out answer `Nil{}`, which is what makes the last law
below hold at every count. `P.take` and `P.drop` come from the prelude.

`P.take(n, xs)` keeps the first `n` elements and `P.drop(n, xs)` throws them
away; both match on `n` first and then on `xs`. `P.append(xs, ys)` matches on
its first argument.

The law `delete_at_zero` fixes the answer at a count of `0n`, where the match
inside `delete_at` has already stopped on the cons cell. It is definitional, and
it is the law that rules out a body whose `0n` case answered the whole list,
which `delete_at_succ` cannot see, because that one names its count as
`1n + n`.

The law `delete_at_nil` fixes the other place the recursion stops, where it is
the list that has run out. It is ground in that argument, and it is not
definitional: with a variable `n` the match inside `delete_at` has nothing to
step on, so this law is itself an induction in `n`.

The law `delete_at_succ` is the step, and it is definitional: it says the answer
is *built out of* the head. A body that recursed on the wrong list, or that
dropped the head instead of keeping it, does not have its two sides equal. It
says nothing about where the recursion stops, which is why the two laws above
are not optional.

The law `delete_at_take_drop` is the one with real content: dropping the element
at position `n` is the same as keeping the `n` elements in front of it and the
elements behind it, the second `drop` stepping one more element off the list the
first one left. It is inductive in `n`, with a split on `xs` in both cases. A
body that ignored its count, or that dropped the element *after* the one asked
for, keeps the two sides apart at every length the count and the list both
reach.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.delete_at_zero(h, t)`, `def L.delete_at_nil(n)`,
`def L.delete_at_succ(n, h, t)` and `def L.delete_at_take_drop(n, xs)`.
