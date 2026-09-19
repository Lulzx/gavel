Implement `pad`, then prove all five laws.

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

The two remaining laws are the two halves of the step, and they are what keeps
a pad from rewriting the list it was handed. `pad_step` covers a cons: the head
survives and the pad continues on the tail, which is the statement that the
input is a prefix of the result -- without it a body that overwrote every
element with the filler satisfies both pins and the count. `pad_nil_step` covers
the other half, an *empty* list under a target that outruns it: there the count
fixes how many elements the answer has and nothing says which ones, so a body
that puts `P.max(k, x)` in front of the recursion instead of `x` -- the filler
replaced by the remaining count wherever that is larger -- satisfies all three
laws above and all of `pad_step`, proves them under the reference proof
unchanged, and answers `[1n, 0n]` where `pad(2n, 0n, Nil{})` should be
`[0n, 0n]`. Both are definitional: `pad`'s own two branches read back, closed by
`{==}`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.pad_nil(x, xs)`, `def L.pad_single(x)`, `def L.pad_len(n, x, xs)`,
`def L.pad_step(n, x, y, ys)` and `def L.pad_nil_step(n, x)`.
