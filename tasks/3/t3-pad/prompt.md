Implement `pad`, then prove all three laws.

`pad(n, x, xs)` lengthens `xs` to `n` elements by adding copies of `x` on the
right, and returns it unchanged when it is already that long. The target length
is what runs out first in the recursion, so the definition steps on `n` and
then on the list; if the list is empty before the count is, the recursion
continues on an empty list. The prelude is immutable and already has `P.len`
and `P.max`.

`pad_nil` and `pad_single` are definitional and fix the empty cases, which the
length law cannot see: on its own it is satisfied by a pad that fills with any
element at all.

`pad_len` is the induction and the only real proof. Each of its two list cases
unfolds to `1n + P.len(S.pad(k, x, ...))`, applies the hypothesis at the tail
count, and is left with `1n + P.max(k, P.len(...))` against
`P.max(1n + k, ...)`. In the case where the list is a cons those two compute to
the same term. In the case where the list is empty, the right-hand side is
`1n + k` and the left is `1n + P.max(k, 0n)` -- and `P.max(k, 0n)` with a
variable on the left does not reduce, so that is a lemma of its own, an
induction on `k`.

Two restrictions to keep in mind. A variable is **Lone** by default -- usable
live once -- whether it is bound by a pattern or declared as a parameter, and
the ways to say otherwise are the `+` marker (`case +k <> t:`, `x: Nat` written
`+x: Nat`) and a rebinding line at the top of a branch, `+k = k`. The empty
case of `pad_len` needs it, because the hypothesis and the `P.max` lemma both
mention `k`; and the reference `pad` declares its filler `+x` for the same
reason. Second, no law's proof may cite another law; helpers live under
`Policy.` and are the only things you may call besides `S.` and `P.`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.pad_nil(x, xs)`, `def L.pad_single(x)` and `def L.pad_len(n, x, xs)`.
