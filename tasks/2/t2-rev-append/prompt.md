Implement `rev_append` on lists of `Nat`, then prove both laws.

`rev_append(xs, ys)` must return `xs` reversed in front of `ys`; recurse on
`xs`, with the empty list leaving the accumulator alone. `append` comes from
the prelude.

`rev_append_single` says reversing a one-element list onto an accumulator puts
that element in front of it; since `rev_append` steps on the cons cell, it
computes away by itself. `rev_append_append` says reversing a concatenation
onto an accumulator is reversing the two pieces onto it in turn, the second
piece outermost. That one is inductive in `xs`, and its step case is the
hypothesis at the tail of `xs` with the head carried onto the accumulator.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.rev_append_single(h, ys)` and `def L.rev_append_append(xs, ys, zs)`.
