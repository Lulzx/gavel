Implement `reverse` on `List<Nat>`, then prove the two laws about it.

`reverse(xs)` returns the elements of `xs` in the opposite order. Recurse on
`xs`: the empty list is the empty list, and a cons cell reverses its tail and
then puts its head at the end of that -- `append(reverse(t), h <> Nil{})`.
`append` and `snoc` come from the prelude.

The laws are the one-element case and the snoc case:

    S.reverse(h <> Nil{}) == h <> Nil{}
    S.reverse(P.snoc(xs, x)) == x <> S.reverse(xs)

The first is the weak half: it is definitional, and it is satisfied by the
identity body, which hands back the list it was given. The second is the one
that pins `reverse`: the identity body fails it -- `snoc(xs, x)` is not
`x <> xs` -- and the base law rules out the constant body. It is inductive in
`xs`.

The first law's proof is `{==}`. The second is an induction in `xs`. Its `Nil{}`
case is the one-element case of `reverse`; its cons case has to use the
hypothesis in the direction that turns `reverse(snoc(t, x))` into
`x <> reverse(t)`, and then reassociate `append` so that the head moves inside --
`append` is stuck on a variable first argument, so that reassociation is a lemma
of its own, under the reserved `Policy.` namespace.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.reverse_single(h)` and `def L.reverse_snoc(xs, x)`.
