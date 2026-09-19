Implement `add` and `mul` on `Nat`, then prove the three laws about them.

`add(a, b)` must return the sum of `a` and `b`; recurse on the first argument.
`mul(a, b)` must return the product of `a` and `b`; recurse on the first
argument as well, adding `b` once per step. Its second parameter has to stay
unrestricted (`+b: Nat`), because the proofs below name `b` more than once.

The first law, `add_plus`, is `add` against Base's `+`, and it is what makes
`add` an obligation at all. The two `mul` laws reach `add` only through
`mul_succ`'s right-hand side, and only at the pairs `(mul(x, y), x)`, so an
`add` that agrees with `+` there and nowhere else satisfies them both. Written
the other way round, `x + y` is Base's addition and `S.add` is the policy's. It
is inductive in `x` and its step closes by reduction, so it is a helper lemma
(`Policy.add_plus`, the same text `t1-mul-zero` uses) plus one citation.

`mul_one_left` says one is a left identity for multiplication. It is inductive
in `x`, and `mul(1n, x)` unfolds to `add(x, 0n)`, so the step case is the fact
that `add(p, 0n)` is `p`, used in the direction that replaces it. `mul_succ`
says multiplying by a successor adds one more copy of the other factor. It is
inductive in `x` too, but its step case needs two facts about `add`: that
`add(x, 1n+y)` is `1n+add(x, y)`, and that `add` is associative. Prove those as
helpers first.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`,
as `def L.add_plus(x, y)`, `def L.mul_one_left(x)` and `def L.mul_succ(x, y)`.
