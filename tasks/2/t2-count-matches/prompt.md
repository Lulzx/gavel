Implement `count_matches` on lists of `Nat`, then prove the four laws about it.

`count_matches(xs, ys)` counts the positions where the two lists agree,
stopping at whichever list runs out first. Recurse on both lists. Either list
running out gives `0n`, so both `Nil{}` cases are base cases. Two cons cells
weigh the head's agreement with `k` and add it to the tail's count: the weight
is `P.pick(P.eq(h, k), 1n, 0n)`, and the rest is the count of the two tails.
`P.eq`, `P.pick` and `P.len` come from the prelude.

`P.eq(a, b)` steps one successor off both of its arguments at once, so
`P.eq(x, x)` on a variable `x` is stuck -- that it is `True{}` is a fact about
`x`, not an unfolding. `P.pick` matches on its first argument and `P.len`
matches on its own, so neither reduces on a variable either.

The law `count_matches_nil` fixes the answer on an empty first list. It is the
weak half: it is definitional, and the constant body `0n` satisfies it.

The law `count_matches_nil_right` fixes the other stopped match, where it is
`ys` that has run out. Its left-hand side is ground in that argument --
`count_matches` steps on the cons cell and then finds `Nil{}` where it wants a
second element -- and the cons law names its second argument as a cons cell, so
no other law here reaches that answer. It is the law that rules out a body
whose stopped match answers anything but zero.

The law `count_matches_cons` is the step, and it is definitional: it is the
definition written out, and it says *which* elements are compared. A body that
weighed the head against the wrong element, or that recursed on the wrong tail,
does not have its two sides equal. It is satisfied by every body of the right
shape, so it is not enough on its own.

The law `count_matches_self` is the one with content, and it is the reason this
task exists: a list agrees with itself at every position, so its self-count is
its length. It is inductive in `xs`. `P.eq(x, x)` on a variable does not
reduce, so the step has to establish that the head agrees with itself before
`P.pick` yields its weight, and the hypothesis carries the tail. The constant
body `0n` fails it, because the right-hand side is the length, and a body that
always answered the length fails `count_matches_cons`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.count_matches_nil(ys)`, `def L.count_matches_nil_right(h, t)`,
`def L.count_matches_cons(h, k, t, u)` and `def L.count_matches_self(xs)`.
