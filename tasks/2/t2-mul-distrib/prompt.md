Implement `mul` on `Nat`, then prove the two laws about it.

`mul(a, b)` must return the product of `a` and `b`. Recurse on `a` and build the
step out of Base's `+`: `0n` is the base case and the step is `b + mul(p, b)`.
That step names `b` twice, and a binder is consumed on every use, so declare it
reusable with `+b`.

The laws are a left identity and left distributivity:

    S.mul(1n, x) == x
    S.mul(x + y, z) == S.mul(x, z) + S.mul(y, z)

Neither one pins `mul` on its own. `mul_one_left` is satisfied by the projection
`mul(a, b) = b`, and `mul_distrib` by the projection `mul(a, b) = a` — under
that one both sides of the distributive law are `x + y`. Both laws are needed:
`mul_one_left` rules out the first projection, and `mul_distrib` rules out
every constant.

Both proofs are inductions on `x`. `mul(1n, x)` reduces to `x + mul(0n, x)` and
then to `x + 0n`, so `mul_one_left` needs a helper for the right identity of
`+`:

    def Policy.add_zero_right(x: Nat) -> {x == x + 0n : Nat}:

Note the orientation: a rewrite goes from the lemma's right-hand side to its
left, so a helper is easiest to use when the term it eliminates is on the
right.

The step of `mul_distrib` has the goal

    z + S.mul(p + y, z) == (z + S.mul(p, z)) + S.mul(y, z)

after unfolding, and the inductive hypothesis is about `S.mul(p + y, z)`. It
appears under a `z + ...` on the left and must end up on the right after the
`z + ...` has been reassociated, so the hypothesis is consumed with
`Equal.sym` — which takes the type and both sides explicitly — and then the
reassociation is a second helper:

    def Policy.add_reassoc(a: Nat, b: Nat, c: Nat) ->
        {(a + b) + c == a + (b + c) : Nat}:

`Policy.add_zero_right` is inductive in `x`; `Policy.add_reassoc` is inductive
in `a`. A helper in `PROOF.bend` is a def named `Policy.` and, unlike a law,
must carry its type.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.mul_one_left(x)` and `def L.mul_distrib(x, y, z)`.
