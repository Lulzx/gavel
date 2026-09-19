Implement `add` and `mul` on `Nat`, then prove the three laws about `mul`.

`add(a, b)` must return the sum of `a` and `b`, recursing on the first
argument.

`mul(a, b)` must return the product of `a` and `b`. Recurse on the first
argument and build the step out of `add`: `0n` is the base case and the step is
`add(b, mul(p, b))`. That step names `b` twice, and a binder is consumed on
every use, so `b` is declared reusable with `+b`.

The law `mul_one` says that multiplying by one on the right changes nothing. It
is inductive in `x`.

The second law, `mul_succ`, is the step `mul` recurses with, with a successor on
the left. It closes by reduction, so `{==}` is its whole proof.

The third law, `mul_zero`, is the anchor the first two are missing. They pin
`mul` on the line `y == 1n` and along the recursion, and between them that fixes
the base case at exactly one point: `mul_succ` at `x == 0n` and `mul_one` at
`x == 1n` together give `P.add(1n, S.mul(0n, 1n)) == 1n`, so `mul(0n, 1n)` is
`0n` -- and nothing said what `mul(0n, y)` was for any other `y`. A body whose
`0n` case reads `b` and answers `1n` once `b` is at least `2n` satisfies both
laws above, satisfies them *under the reference proof unchanged*, and is not
multiplication. `mul_zero` is the missing point: `mul(0n, y)` is `0n` at every
`y`, and with the step above it determines `mul` by induction on the first
argument. It closes by reduction, so `{==}` is its proof too.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.mul_one(x)`, `def L.mul_succ(x, y)` and `def L.mul_zero(y)`.
