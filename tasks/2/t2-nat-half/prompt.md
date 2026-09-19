Implement `half` on `Nat`, the halving of a number, then prove the laws that
pin it.

`half(n)` must return `n` divided by two, rounding down. Recurse on `n`: `0n`
is the base case and returns `0n`; `1n` also returns `0n`, because a single unit
has nothing to halve into; and `1n + (1n + p)` returns `1n + half(p)`, because
dropping two from the input drops one from the answer. So the walk takes two
units at a time and rounds down on the way.

The law `half_zero` fixes the answer the recursion reaches on nothing, and
`half_one` fixes the other answer the match gives without recursing. The second
is not implied by the first: it is the case a body that rounded up would get
wrong while every recursive step still agreed, which is why it is here. Both
left-hand sides are ground terms, so both sides compute and each is
definitional.

The law `half_step` is the recursion written out. It is definitional, and it is
what says the walk goes two at a time: a body that dropped one unit per call, or
that added nothing, does not have these two sides equal.

The law `half_double` says that halving undoes doubling. It is the work, and it
is absolute: `Nat.double` is in `Base` and steps two at a time, exactly as your
`half` does, so the successor case of the induction hands `half` an argument one
pair further along and the hypothesis at the previous number is the only thing
that can rewrite it. Nothing is divided -- `Nat.double` is unfolded and what is
left is `1n + p` on both sides.

The law `half_double_succ` is the odd companion: halving `1n + Nat.double(n)`
gives `n`. It is not a consequence of `half_double`, because the two together
cover every number and this is the one that fixes what the match's `1n` answer
is worth at every larger odd number. A body that rounded the odds up rather than
down satisfies `half_double` and fails this one.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.half_zero()`, `def L.half_one()`, `def L.half_step(n)`,
`def L.half_double(n)` and `def L.half_double_succ(n)`.
