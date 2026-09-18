Implement `max_prefix` on `Nat` and `List<Nat>`, then prove the two laws about
it.

`max_prefix(n, xs)` is the largest of the first `n` elements of `xs`, and `0n`
once either the count or the list runs out. `n` is the argument that gets
consumed: `0n` is the base case, and the step splits the list -- `Nil{}` is
`0n`, and a cons cell takes `P.max(h, max_prefix(k, t))`. `len` and `max_list`
come from the prelude.

The laws are the empty-count case and the length case:

    S.max_prefix(0n, xs) == 0n
    S.max_prefix(P.len(xs), xs) == P.max_list(xs)

The first is the weak half: the constant body `0n` satisfies it, and so does a
body that ignores the list and hands back its count. The second is the one that
pins `max_prefix`: a body that ignored the count would have to be `0n` for every
list -- from the base law -- and equal to `max_list(xs)` for every list, and a
body that ignored the list would have to hand back `max_list(xs)` without ever
looking at an element. It is inductive in `xs`: `len` and `max_list` both match
on their first argument, so with a variable `xs` the left-hand side does not
reduce on its own.

The first law's proof is `{==}`: the match steps on `0n` and answers `0n`
without needing to look at the list. The second is an induction in `xs`. Its
`Nil{}` case is `0n` on both sides; its cons case reduces both sides to `max` of
the same head and the hypothesis at `t`. Annotate that step with the goal in
which the term the hypothesis rewrites has been replaced by `_`, and close it
with `{==}`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.max_prefix_zero(xs)` and `def L.max_prefix_len(xs)`.
