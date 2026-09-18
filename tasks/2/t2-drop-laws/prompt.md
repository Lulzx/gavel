Implement `drop` on lists of `Nat`, then prove both laws.

`drop(n, xs)` must remove the first `n` elements of `xs`; recurse on `n`, with
no steps leaving the list alone. A list that runs out before the count does is
empty. `append` and `len` come from the prelude.

`drop_succ` is the successor case: one step of the count removes one cons cell;
since `drop` steps on the count, it computes away by itself.

`drop_append_len` says dropping as many elements as `xs` has leaves the rest of
`xs <> ys`, namely `ys`. That one is inductive in `xs` -- `len` and `append`
both match on their first argument, so the goal does not reduce on its own --
and its step case is the hypothesis at the tail of `xs`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.drop_succ(k, h, t)` and `def L.drop_append_len(xs, ys)`.
