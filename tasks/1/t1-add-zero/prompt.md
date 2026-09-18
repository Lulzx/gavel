Implement `add` on `Nat` so that adding zero on the right changes nothing.

`add(a, b)` must return the sum of `a` and `b`. The law `add_zero` requires
that for every `x`, `add(x, 0n)` equals `x`. Recurse on the first argument.

Prove the law in `PROOF.bend` as `def L.add_zero(x)`.
