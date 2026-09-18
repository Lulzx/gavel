Implement `add` and `mul` on `Nat`, then prove both laws about `mul`.

`add(a, b)` must return the sum of `a` and `b`; recurse on the first argument.
`mul(a, b)` must return the product of `a` and `b`; recurse on the first
argument as well, adding `b` once per step. Its second parameter has to stay
unrestricted (`+b: Nat`), because the proofs below name `b` more than once.

`mul_one_left` says one is a left identity for multiplication. It is inductive
in `x`, and `mul(1n, x)` unfolds to `add(x, 0n)`, so the step case is the fact
that `add(p, 0n)` is `p`, used in the direction that replaces it. `mul_succ`
says multiplying by a successor adds one more copy of the other factor. It is
inductive in `x` too, but its step case needs two facts about `add`: that
`add(x, 1n+y)` is `1n+add(x, y)`, and that `add` is associative. Prove those as
helpers first.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`,
as `def L.mul_one_left(x)` and `def L.mul_succ(x, y)`.
