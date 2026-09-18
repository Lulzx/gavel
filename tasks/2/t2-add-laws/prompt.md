Implement `add` on `Nat`, then prove both laws about it.

`add(a, b)` must return the sum of `a` and `b`. Recurse on the first argument.

`add_zero` says adding zero on the right changes nothing. `add_succ` says
adding a successor on the right is the successor of adding. Both are inductive
in `x`, so both proofs have the same shape.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`,
as `def L.add_zero(x)` and `def L.add_succ(x, y)`.
