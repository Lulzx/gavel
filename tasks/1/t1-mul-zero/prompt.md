Implement `add` and `mul` on `Nat`, then prove the law about `mul`.

`add(a, b)` must return the sum of `a` and `b`, recursing on the first
argument.

`mul(a, b)` must return the product of `a` and `b`. Recurse on the first
argument and build the step out of `add`: `0n` is the base case and the step is
`add(b, mul(p, b))`. That step names `b` twice, and a binder is consumed on
every use, so `b` is declared reusable with `+b`.

The law `mul_zero` says that multiplying by zero on the right gives zero. It is
inductive in `x`.

The second law, `mul_one_left`, multiplies by one on the left. It is inductive
in `x` too: the step reduces to `1n + add(p, 0n)`, which the hypothesis turns
into `1n + p`.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.mul_zero(x)` and `def L.mul_one_left(x)`.
