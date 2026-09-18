Implement `add` and `mul` on `Nat`, then prove the three laws about them.

`add(a, b)` must return the sum of `a` and `b`, recursing on the first
argument.

`mul(a, b)` must return the product of `a` and `b`. Recurse on the first
argument and build the step out of `add`: `0n` is the base case and the step is
`add(b, mul(p, b))`. That step names `b` twice, and a binder is consumed on
every use, so `b` is declared reusable with `+b`.

The law `mul_two` says that multiplying by two is adding a number to itself:

    S.mul(2n, x) == x + x

The `+` there is Base's addition, not `S.add`, which is what makes closing it a
question about how `S.add` relates to Base's `+` rather than a computation.

It does not, by itself, determine `mul` — and this is worth saying plainly,
because the obvious reading is that it does. `mul(2n, x)` names its first
argument as a literal, so `mul(a, b) = b + b` satisfies it. Two more laws close
that off, and each is one line:

    law mul_zero:  for x: Nat  {S.mul(0n, x) == 0n : Nat}
    law add_zero:  for x: Nat  {S.add(x, 0n) == x : Nat}

`mul_zero` is definitional: `mul` matches on its first argument and that
argument is `0n`, so `{==}` is the whole proof. `add_zero` is the second lemma
below — the goal is exactly what that lemma proves.

`mul` recurses on its first argument, so `mul(2n, x)` reduces all the way to
`add(x, add(x, 0n))` and the goal is a rewrite rather than an induction. Closing
it means relating `S.add` to Base's `+`, which takes two auxiliary lemmas:

    def Policy.add_plus(x: Nat, y: Nat) -> {S.add(x, y) == x + y : Nat}:
    def Policy.add_zero(x: Nat) -> {S.add(x, 0n) == x : Nat}:

A helper in `PROOF.bend` is a def named `Policy.` and, unlike a law, it must
carry its type. Both of these are inductive in `x`.

A rewrite goes from the lemma's right-hand side to its left, so annotate the
step with the goal written in `S.add` form and leave `_` where the Base `+` term
being replaced sits. Note that `x` is named more than once in `L.mul_two`, and a
binder is consumed on every use: re-bind it reusable first with `+x = x`.

Write the implementations in `solution.bend` and the proof in `PROOF.bend`, as
`def L.mul_two(x)`, `def L.mul_zero(x)` and `def L.add_zero(x)`.
