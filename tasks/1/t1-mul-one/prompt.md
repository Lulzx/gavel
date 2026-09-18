Implement `add` and `mul` on `Nat`, then prove the law about `mul`.

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

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.mul_one(x)` and `def L.mul_succ(x, y)`.
