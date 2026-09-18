Implement truncated subtraction `sub` on `Nat`, then prove the two laws about
it.

`sub(a, b)` is `a - b`, stopping at zero. Match on both arguments at once:
`sub(0n, ...)` is `0n`, there is nothing left to take from, and the only case
that recurses is `sub(1n+ap, 1n+bp)`, which is `sub(ap, bp)`. `pred` comes from
the prelude.

The laws are the zero case and one step of the subtrahend:

    S.sub(x, 0n) == x
    S.sub(x, 1n+y) == P.pred(S.sub(x, y))

Neither one pins `sub` on its own. `sub_zero` is satisfied by the projection
`sub(a, b) = a`, which owes nothing for it; `sub_succ` is satisfied by the
constant body `0n`, since `pred(0n)` is `0n` and both sides are then `0n`. Both
are needed: `sub_zero` kills the constants, and `sub_succ` kills both
projections. Together they pin it: the zero law names every `sub(x, 0n)`, and
the successor law reduces `sub(x, 1n+y)` to `pred` of a smaller second
argument, so an induction on `y` reaches every value of it.

`sub_zero` is a split on `x`, and it is definitional in both branches: the
`0n` case is the first pattern of the match, and `sub(1n+p, 0n)` is the third.
`sub_succ` is an induction on `x`, and the cases under it need further splits
before the two sides meet: the match is on both arguments at once, so
`sub(p, 0n)` is stuck while `p` is a variable and `sub(0n, q)` is stuck while
`q` is one. The case where both arguments are successors -- and so both sides
have gone down a step -- is the hypothesis at the predecessor of each.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.sub_zero(x)` and `def L.sub_succ(x, y)`.
