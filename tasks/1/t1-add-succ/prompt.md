Implement `add` on `Nat`, then prove the law about it.

`add(a, b)` must return the sum of `a` and `b`. Recurse on the first argument.

The law `add_succ` says that adding a successor on the right is the successor of
adding: `add(x, 1n+y)` equals `1n + add(x, y)`. It is inductive in `x`.

Write the implementation in `solution.bend` and the proof in `PROOF.bend`, as
`def L.add_succ(x, y)`.
