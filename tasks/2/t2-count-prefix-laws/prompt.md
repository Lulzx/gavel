Implement `count_odd_prefix` on `Nat` and `List<Nat>`, then prove the two laws
about it.

`count_odd_prefix(n, xs)` counts the odd numbers among the first `n` elements
of `xs`, so it is `0n` once either the count or the list runs out. `n` is the
argument that gets consumed: `0n` is the base case, and the step splits the
list -- `Nil{}` counts none, and a cons cell adds `P.is_odd(h)` to
`count_odd_prefix(k, t)`. `len`, `is_odd` and `count_odd` come from the
prelude.

The laws are the empty-count case and the length case:

    S.count_odd_prefix(0n, xs) == 0n
    S.count_odd_prefix(P.len(xs), xs) == P.count_odd(xs)

The first is the weak half: the constant body `0n` satisfies it, and so does a
body that ignores the list and hands back its count. The second is the one that
pins `count_odd_prefix`: a body that ignored the count would have to be `0n` for
every list -- from the base law -- and equal to `count_odd(xs)` for every list,
and a body that ignored the list would have to hand back `count_odd(xs)` without
ever looking at an element. It is inductive in `xs`: `len` and `count_odd` both
match on their first argument, so with a variable `xs` the left-hand side does
not reduce on its own.

The first law's proof is `{==}`: the match steps on `0n` and answers `0n`
without needing to look at the list. The second is an induction in `xs`. Its
`Nil{}` case is `0n` on both sides; its cons case reduces both sides to
`P.is_odd(h)` added to the hypothesis at `t`. Annotate that step with the goal
in which the term the hypothesis rewrites has been replaced by `_`, and close it
with `{==}`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.count_odd_prefix_zero(xs)` and `def L.count_odd_prefix_len(xs)`.
