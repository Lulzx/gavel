Implement `pred` and `add` on `Nat`, then prove both laws.

`pred(n)` must return the predecessor of `n`, and `0n` when `n` is `0n`. It is
the deconstructor of `Nat`, so it matches rather than recurses. `add(a, b)`
must return the sum of `a` and `b`; recurse on the first argument.

`pred_succ` says the predecessor of a successor is the number itself, which
`pred` already computes. `add_one` says that adding one on the right is the same
as adding one on the left; it is inductive in `x`, and its step case rewrites
with the induction hypothesis at `p`.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`,
as `def L.pred_succ(x)` and `def L.add_one(x)`.
