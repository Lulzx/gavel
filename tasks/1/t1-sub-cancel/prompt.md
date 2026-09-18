Implement saturating subtraction `sub` on `Nat`, then prove the law about it.

`sub(a, b)` must return `a - b`, stopping at `0n` instead of wrapping around.
Match on both arguments, so that `sub(1n+ap, 1n+bp)` reduces to `sub(ap, bp)`;
that is the case the induction step below needs.

The law `sub_cancel` says that subtracting a number from a sum that contains it
cancels it:

    S.sub(x + y, x) == y

The `+` is Base's addition, not a function you write. It is what pins `sub`: a
`sub` that returned one of its arguments, or a constant, makes the two sides
differ for some `x` and `y`.

Induct on `x`. In the base case `sub(0n + y, 0n)` reduces to `sub(y, 0n)`, so
you need one auxiliary lemma:

    def Policy.sub_zero_right(x: Nat) -> {S.sub(x, 0n) == x : Nat}:

A helper in `PROOF.bend` is a def named `Policy.` and, unlike a law, it must
carry its type. This one is inductive in `x`.

A rewrite goes from the lemma's right-hand side to its left, so annotate the
step with the goal in which that right-hand side has been replaced by `_`.

Write the implementation in `solution.bend` and the proof in `PROOF.bend`, as
`def L.sub_cancel(x, y)`.
