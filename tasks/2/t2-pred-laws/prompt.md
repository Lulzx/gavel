Implement `pred` and `add` on `Nat`, then prove both laws.

`pred(n)` must return the predecessor of `n`, and `0n` when `n` is `0n`. It is
the deconstructor of `Nat`, so it matches rather than recurses. `add(a, b)`
must return the sum of `a` and `b`; recurse on the first argument.

`pred_succ` says the predecessor of a successor is the number itself, which
`pred` already computes. `pred_add_succ` says that when the second summand ends
in a successor, the predecessor just drops it. It splits on `x`, and its
successor case needs the fact that `add(x, 1n+y)` is `1n+add(x, y)`.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`,
as `def L.pred_succ(x)` and `def L.pred_add_succ(x, y)`.
