Implement `pow` on `Nat`, then prove the two laws about it.

`pow(a, b)` must return `a` raised to the power `b`. `b` is the argument that
gets consumed: `0n` is the base case and returns `1n`, and the step is
`Nat.mul(a, pow(a, p))`. That step names `a` twice, and a binder is consumed on
every use, so re-bind it reusable inside the step with `+x = a`.

The laws are the two obvious facts about exponents:

    S.pow(x, 0n) == 1n
    S.pow(x, 1n) == x

Neither one pins `pow` on its own. `pow_zero` is satisfied by the constant body
that returns `1n` for every input, and `pow_one` by the projection
`pow(a, b) = a`. Both are needed: `pow_zero` rules out the projection, and
`pow_one` rules out every constant.

`pow_zero` holds by definition. For `pow_one`, `pow(x, 1n)` reduces to
`Nat.mul(x, pow(x, 0n))` and then to `Nat.mul(x, 1n)`, so you need one
auxiliary lemma:

    def Policy.mul_one_right(x: Nat) -> {Nat.mul(x, 1n) == x : Nat}:

A helper in `PROOF.bend` is a def named `Policy.` and, unlike a law, it must
carry its type. This one is inductive in `x`.

A rewrite goes from the lemma's right-hand side to its left, so annotate the
step with the goal in which that right-hand side has been replaced by `_`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.pow_zero(x)` and `def L.pow_one(x)`.
