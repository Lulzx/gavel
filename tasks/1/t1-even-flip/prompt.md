Implement the parity predicate `even` on `Nat`, then prove the law about it.

`even(n)` must return `True{}` when `n` is even and `False{}` when it is odd.
Recurse on `n`: `0n` is the base case, and the step flips the answer for the
predecessor with `Bool.not`.

The law `even_flip` says that adding one flips the answer:

    S.even(x) == Bool.not(S.even(1n+x))

It is what pins `even`: a body that ignores `n` and returns `True{}` or
`False{}` makes the two sides differ. Note that the `x` in `1n+x` sits on the
right of the `+` — the argument position parity is defined to consume.

`1n+x` normalizes to `succ x`, so `S.even(1n+x)` reduces to
`Bool.not(S.even(x))` and the goal becomes the double negation

    S.even(x) == Bool.not(Bool.not(S.even(x)))

Closing it takes one auxiliary lemma:

    def Policy.not_not(b: Bool) -> {b == Bool.not(Bool.not(b)) : Bool}:

A helper in `PROOF.bend` is a def named `Policy.` and, unlike a law, it must
carry its type. This one is a case analysis on `b`.

A rewrite goes from the lemma's right-hand side to its left, so annotate the
step with the goal in which that right-hand side has been replaced by `_`.
`S.even(x)` is named in both the lemma's argument and the annotation, and a
binder is consumed on every use — re-bind it reusable first with
`+e = S.even(x)`.

Write the implementation in `solution.bend` and the proof in `PROOF.bend`, as
`def L.even_flip(x)`.
