Implement `fib_pair` and `sum_fib` on `Nat`, then prove the five laws that
relate them.

`fib_pair(n)` must answer a `P.Pair` of two consecutive Fibonacci numbers, the
earlier one first: `fib_pair(0n)` is `MkPair{0n, 1n}`, `fib_pair(1n)` is
`MkPair{1n, 1n}`, `fib_pair(2n)` is `MkPair{1n, 2n}`. Recursing on `n`, the
empty case is that first pair and the step hands the pair below it to
`P.advance`, which slides the window along by one.

`sum_fib(n)` must add up the Fibonacci numbers below `n`: `sum_fib(3n)` is
`0n + 1n + 1n`, which is `2n`. Recursing on `n`, the empty case adds nothing and
the step adds the earlier half of the pair below it -- `P.fst` names that half
-- to the total below it.

`P.advance`, `P.fst` and `P.snd` are supplied by the immutable prelude, so the
laws pin the numbers rather than the arithmetic on the pair.

`fib_pair_zero` and `sum_fib_zero` are the two pins. Each fixes the answer on
the smallest input, and each is definitional. The step laws below are stated at
`1n + k`, so neither reaches those inputs: a `fib_pair` that answered
`MkPair{0n, 0n}` at `0n` satisfies `fib_pair_succ`, and a `sum_fib` that
answered anything at all at `0n` satisfies `sum_fib_succ`.

`fib_pair_succ` and `sum_fib_succ` are the two steps, and both are
definitional. The first fixes which way the pair grows; the second fixes which
numbers are being added up. A body that summed the later halves instead of the
earlier ones, or that advanced the pair in the wrong direction, leaves one of
these two unconvertible.

`sum_fib_pair` is the interaction, and the reason the two functions are one
task. It is not definitional: with `n` a variable neither side computes, so the
induction is the proof. The step leaves the running total at `1n + k` against
`P.snd` of the pair at `1n + k`, which is `P.advance` of the pair at `k`; the
hypothesis at `k` states the total against the un-advanced pair, so the two
have to be brought into line first. It is the law that ties the two functions'
arguments together, since the two step laws above fix each function against
itself and say nothing about the two of them at the same `n`.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.fib_pair_zero()`, `def L.fib_pair_succ(k)`, `def L.sum_fib_zero()`,
`def L.sum_fib_succ(k)` and `def L.sum_fib_pair(n)`.

The proof of `sum_fib_pair` needs two facts the prelude does not state:

    P.snd(P.advance(p)) == P.fst(p) + P.snd(p)
    a + (b + c) == (a + b) + c

Write them in `PROOF.bend` as helpers named `Policy.advance_snd` and
`Policy.add_assoc`, not as laws, since a law that cited another law would make
the credit for both depend on the citation. `advance_snd` is definitional;
`add_assoc` is inductive in `a`. Note that a rewrite step goes from a helper's
right-hand side to its left, so a helper oriented the way the goal needs it may
have to be read backwards with `Equal.sym`, and annotate each step with the goal
in which the term being rewritten has been replaced by `_`.
