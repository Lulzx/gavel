Implement `add` and `mul` on `Nat`, then prove the laws about `mul`.

`add(a, b)` must return the sum of `a` and `b`, recursing on the first
argument.

`mul(a, b)` must return the product of `a` and `b`. Recurse on the first
argument and build the step out of `add`: `0n` is the base case and the step is
`add(b, mul(p, b))`. That step names `b` twice, and a binder is consumed on
every use, so `b` is declared reusable with `+b`.

The law `mul_zero` says that multiplying by zero on the right gives zero. It is
inductive in `x`.

The law `mul_succ_left` is the step `mul` recurses with, for a successor on the
left: multiplying a successor is adding the other factor. Its right-hand side
uses Base's `+`, not `S.add`, which is what stops it from being satisfied by a
`mul` -- or by a pair of `mul` and `add` -- that ignores its arguments. The law
is closed by reduction on the left and by relating `S.add` to Base's `+` on the
right, so it needs an auxiliary lemma:

    def Policy.add_plus(x: Nat, y: Nat) -> {S.add(x, y) == x + y : Nat}:

A helper in `PROOF.bend` is a def named `Policy.` and, unlike a law, it must
carry its type. This one is inductive in `x`. The rewrite goes from the lemma's
right-hand side to its left, so leave `_` where the Base `+` term sits and write
the goal in `S.add` form. Note that `y` is named twice in the law's proof, once
by the lemma and once under `S.mul`; re-bind it reusable first with `+y = y`.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.mul_zero(x)` and `def L.mul_succ_left(x, y)`.
