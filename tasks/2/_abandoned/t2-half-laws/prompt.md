Implement `half` on `Nat`, then prove the two laws about it.

`half(n)` is integer division by two, flooring. It steps two at a time: `0n`
answers `0n`, `1n` answers `0n`, and any larger odd number answers one plus the
halving of what is two below it. The prelude is empty; the laws are stated about
`half` alone.

The laws are the zero case and the even case:

    S.half(0n) == 0n
    S.half(1n + 1n + p) == 1n + S.half(p)

The first is the weak half: it is definitional, and the constant body `0n`
satisfies it. The second fixes the recursion.

ABANDONED, for the record. The second law is the definitional unfolding of
`half`: `1n + 1n + p` is constructor-headed, so `half` steps on it and both
sides normalise to the same term. Both proofs are therefore `{==}`, the corpus
carries no evidence of work, and the pipeline's V3 check refuses the task --
"reference+reflexive-proof proves every law -- the task's reward can be earned
without solving it". There is no repair available for this function: any law
whose argument is constructor-headed reduces away, and a law over a stuck
argument (`S.half(n + n) == n`) cannot be proved, because `half` only ever
steps on a constructor-headed argument. The task was replaced by
`t2-sum-half-laws`, which keeps `half` as a per-element operation under a list
aggregate, where the pinning law is stuck on a variable `xs`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.half_zero()` and `def L.half_succ(p)`.
