Implement `min` on `Nat`, then prove the two laws about it.

`min(a, b)` must return the smaller of `a` and `b`. Match on both arguments:
`0n` in either position is already the answer, and the only case that has to
recurse is `min(1n+ap, 1n+bp)`, which is `1n + min(ap, bp)`.

The laws are self and commutativity:

    S.min(x, x) == x
    S.min(x, y) == S.min(y, x)

Neither one pins `min` on its own. `min_self` is satisfied by the projection
`min(a, b) = a` (and by `= b`), and `min_comm` by every constant body. Both are
needed: `min_self` rules out the constants, and `min_comm` rules out the
projections, which disagree as soon as the two arguments differ.

`min_self` is an induction on `x`, reusing itself at `p`. `min_comm` needs two
nested inductions — on `x` and then on `y` — and only the
`1n+p` / `1n+q` case is not immediate; there it reuses itself at `(p, q)`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.min_self(x)` and `def L.min_comm(x, y)`.
