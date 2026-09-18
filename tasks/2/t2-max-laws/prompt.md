Implement `max` on `Nat`, then prove the two laws about it.

`max(a, b)` must return the larger of `a` and `b`. Match on both arguments:
`0n` in either position decides the answer without any recursion, and the only
case that recurses is `max(1n+ap, 1n+bp)`, which is `1n + max(ap, bp)`.

The laws are the self case and commutativity:

    S.max(x, x) == x
    S.max(x, y) == S.max(y, x)

Neither one pins `max` on its own. `max_self` is satisfied by the projection
`max(a, b) = a` (and by `= b`), which does not look at the other argument, and
`max_comm` is satisfied by every constant body, since a constant does not
depend on the order. Both are needed: `max_self` kills the constants -- a
constant cannot hand back its argument -- and `max_comm` kills both
projections, which disagree as soon as the two arguments differ.

`max_self` is an induction in `x`. Its `0n` case is the first pattern of the
match, and its `1n+p` case is the fourth, `max(1n+p, 1n+p)`, which is
`1n + max(p, p)` -- the hypothesis turns that back into `1n+p`. `max_comm`
needs two nested inductions, on `x` and then on `y`. Three of the four cases
reduce to a common term on both sides; the `1n+p` / `1n+q` case gives
`1n + max` on both sides and reuses the hypothesis at `(p, q)`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.max_self(x)` and `def L.max_comm(x, y)`.
