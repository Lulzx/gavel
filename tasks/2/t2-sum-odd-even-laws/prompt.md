Implement `sum_odd` and `sum_even` on `Nat`, then prove the five laws that
relate them.

`sum_odd(n)` adds up the first `n` odd numbers, `1n + 3n + ... + (2n - 1n)`:
`sum_odd(0n)` is `0n`, `sum_odd(1n)` is `1n`, `sum_odd(2n)` is `4n`. Recursing on
`n`, the empty case adds nothing and the step adds the next odd number, which is
`k + k + 1n` when the sum below carries `k` terms.

`sum_even(n)` adds up the first `n` even numbers, `0n + 2n + ... + (2n - 2n)`:
`sum_even(1n)` is `0n`, `sum_even(2n)` is `2n`, `sum_even(3n)` is `6n`. The
empty case adds nothing and the step adds the next even number, `k + k`.

Both functions take their step from the term below them, so both `k`s are used
more than once in the step and the pattern that binds them has to say so.

`sum_odd_zero` and `sum_even_zero` are the two pins. Each fixes the answer on
the smallest input, and each is definitional. The step laws below are stated at
`1n + k`, so neither reaches those inputs: a `sum_odd` that answered `1n` at
`0n` satisfies `sum_odd_succ`.

`sum_odd_succ` and `sum_even_succ` are the two steps, and both are
definitional. They are what keeps the two functions apart -- a body that gave
`sum_even` the odd step satisfies `sum_odd_succ` and fails `sum_even_succ`.

`sum_odd_sum_even` is the interaction, and the reason the two functions are one
task. It says the odd total is the even total plus one for every term. It is not
definitional: with `n` a variable neither side computes, so the induction is the
proof. The step has `sum_odd(k) + (k + k + 1n)` against
`(sum_even(k) + (k + k)) + (1n + k)`, and the hypothesis relates `sum_odd(k)` to
`sum_even(k) + k` -- after which the two sides are the same four numbers under
different groupings, with the literal `1n` on the inside on one side and on the
outside on the other. It is the law that ties the two functions' arguments
together, since the two step laws above fix each function against itself and say
nothing about the two of them at the same `n`.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.sum_odd_zero()`, `def L.sum_odd_succ(k)`, `def L.sum_even_zero()`,
`def L.sum_even_succ(k)` and `def L.sum_odd_sum_even(n)`.

The interaction needs two facts about `+` that the prelude does not state. `+`
is `Nat.add`, which matches on its *left* argument:

    (a + b) + c == a + (b + c)
    a + 1n == 1n + a

The first is how the two sides are brought to the same shape; the second is how
the `1n` crossed. Write them in `PROOF.bend` as helpers named
`Policy.add_assoc` and `Policy.succ_right`, not as laws, since a law that cited
another law would make the credit for both depend on the citation. `add_assoc`
is inductive in `a`; `succ_right` is inductive in `a` too, and its step is where
the direction of a rewrite decides the proof.

A term is never rewritten from the left of a helper to its right. To replace a
term `B` in the goal you supply a proof of `{B' == B}`, with `B'` what you want
in its place, so a helper stated the other way round has to be wrapped in
`Equal.sym` -- and annotate each step with the goal in which the term being
rewritten has been replaced by `_`.
