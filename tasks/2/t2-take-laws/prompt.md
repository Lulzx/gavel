Implement `take` on lists of `Nat`, then prove both laws.

`take(n, xs)` must keep the first `n` elements of `xs`; recurse on `n`, with no
steps keeping nothing, and a list that runs out before the count does
contributing nothing more. `append` and `len` come from the prelude.

`take_succ` is the successor case: one step of the count keeps one cons cell;
since `take` steps on the count, it computes away by itself.

`take_append_len` says keeping as many elements as `xs` has takes all of `xs`,
whenever `ys` is what follows it. That one is inductive in `xs` -- `len` and
`append` both match on their first argument, so the goal does not reduce on its
own -- and its step case is the hypothesis at the tail of `xs`, under the cons
cell that `len` counted and `append` put back.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.take_succ(h, k, xs)` and `def L.take_append_len(xs, ys)`.
