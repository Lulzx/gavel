Implement `init` on `List<Nat>`, then prove the two laws about it.

`init(xs)` is `xs` without its last element. Match on the list: `Nil{}` gives
`Nil{}`, and a cons cell looks at its tail -- the one-element list has nothing
before its last element, so it gives `Nil{}` too, and a longer list keeps its
head and repeats on the tail. `append` comes from the prelude.

The laws are the one-element case and the append case:

    S.init(h <> Nil{}) == Nil{}
    S.init(P.append(xs, x <> Nil{})) == xs

The first is the weak half: it is definitional, and the constant body `Nil{}`
satisfies it. The second is the one that pins `init`: the constant body fails it
-- the right-hand side is `xs`, not `Nil{}` -- and the identity body, which
hands back the list it was given, fails the base law. It is inductive in `xs`:
`append` matches on its first argument, so with a variable `xs` the left-hand
side does not reduce on its own.

The first law's proof is `{==}`: the match steps on the cons cell and then finds
`Nil{}` for the tail. The second is an induction in `xs`, and each case splits
the tail `t` as well -- with `t` a variable, `init`'s own match on it has
nothing to step on, and both sides stay stuck. The one-element case is
definitional once the tail is `Nil{}`; the longer case keeps its head and hands
the hypothesis the tail. Annotate that step with the goal in which the term the
hypothesis rewrites has been replaced by `_`, and close it with `{==}`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.init_single(h)` and `def L.init_snoc(xs, x)`.
