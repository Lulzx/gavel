Implement `sum_acc` on lists of `Nat`, then prove both laws.

`sum_acc(xs, acc)` must add the elements of `xs` to `acc`; recurse on `xs`,
adding the head to the accumulator before its tail is walked. `append` comes
from the prelude.

`sum_acc_single` says the sum of a one-element list onto a zero accumulator is
that element. `sum_acc` computes it to `h + 0n`, so that proof needs the fact
that adding zero on the right is the identity, as a lemma of your own under the
reserved `Policy.` namespace.

`sum_acc_append` says summing a concatenation onto an accumulator is summing
the two pieces onto it in turn, the second piece innermost. That one is
inductive in `xs`, and its step case is the hypothesis at the tail of `xs` with
the head folded into the accumulator.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.sum_acc_single(h)` and `def L.sum_acc_append(xs, ys, acc)`.
