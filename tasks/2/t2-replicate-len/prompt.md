Implement `replicate` on `Nat`, then prove both laws.

`replicate(n, x)` must return the list of `n` copies of `x`; recurse on `n`,
with no steps producing the empty list. Every element of the result is a copy
of `x`, so `x` is marked `+` -- duplicable -- in the signature the stub gives
you. `len` comes from the prelude.

`replicate_succ` says one more copy puts one more element in front; since
`replicate` steps on the count, it computes away by itself.

`replicate_len` says the result has as many elements as were asked for. That
one is inductive in `n` -- `len` matches on its first argument, so the goal
does not reduce on its own -- and its step case is the hypothesis at the
predecessor, under the `1n +` that `len` produced.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.replicate_succ(n, x)` and `def L.replicate_len(n, x)`.
