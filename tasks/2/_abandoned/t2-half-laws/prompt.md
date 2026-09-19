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
without solving it". The task was replaced by `t2-sum-half-laws`, which keeps
`half` as a per-element operation under a list aggregate, where the pinning law
is stuck on a variable `xs`.

CORRECTED 2026-09-19. The paragraph above used to end "there is no repair
available for this function", and that was wrong. It reached for a law over
`S.half(n + n) == n`, where `n + n` is a `+` on a variable and therefore stuck,
and concluded that since `half` only steps on a constructor-headed argument no
such law could be proved. The law does not have to be written with `+`.
`t2-nat-half` carries `S.half(Nat.double(n)) == n` -- the same statement, with
`Nat.double(n)` in place of `n + n` -- and it *is* provable: the induction's
successor case unfolds `Nat.double(p)` into `1n + (1n + Nat.double(p))`, which
is constructor-headed, so `half` steps on it and the hypothesis at the previous
number rewrites the rest. Its odd companion `S.half(1n + Nat.double(n)) == n`
does the same job for the numbers in between. **The mistake was reading "the
argument is stuck" as a property of the value rather than of the way it was
built**: `Nat.double(n)` is just as stuck as `n + n`, and it is a single call
that an induction can unfold, which is the whole difference. The function is
solved after all, in the task named above, and the laws it is solved with are
the ones this record claimed did not exist.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.half_zero()` and `def L.half_succ(p)`.
