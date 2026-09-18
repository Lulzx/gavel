Implement `add` on `Nat`, then prove both laws about it.

`add(a, b)` must return the sum of `a` and `b`. Recurse on the first argument.

`add_one` says that adding one on the right is the same as adding one on the
left. `add_assoc` says addition is associative. Both are inductive in `x`, and
both proofs have the same shape: the step case rewrites with the induction
hypothesis at `p` and then closes.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`,
as `def L.add_one(x)` and `def L.add_assoc(x, y, z)`.
