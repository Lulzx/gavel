Implement `add` on `Nat`, then prove the law about it.

`add(a, b)` must return the sum of `a` and `b`. Recurse on the first argument.

The law `add_plus` says that `add` agrees with Base's built-in `+`:

    S.add(x, y) == x + y

The `+` there is Base's addition, not `S.add`. It is inductive in `x`: at `0n`
the left side reduces to `y` and so does the right, and the step is the
induction hypothesis at `p`.

Note what the law is *not*. A law that compares two applications of `add`,
like `add(x, 1n+y) == 1n + add(x, y)`, does not pin the implementation down:
`add(a, b) = b` satisfies it, because with `1n+y` on the left the goal becomes
`1n+y == 1n+y`. Putting a term that does not mention `add` on the right is what
closes that off — `add(a, b) = b` then has to answer `y == x + y`.

Write the implementation in `solution.bend` and the proof in `PROOF.bend`, as
`def L.add_plus(x, y)`.
