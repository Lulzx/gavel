Implement `sq_inc_all` on `List<Nat>`, then prove the two laws about it.

`sq_inc_all(xs)` replaces every element with the square of the element plus one. Match on the list: `Nil{}` is
`Nil{}`, and a cons cell conses the square of the element plus one of the head onto the mapped tail.
`append` and `sq_inc` come from the prelude.

The laws are the one-element case and the append case:

    S.sq_inc_all(h <> Nil{}) == (P.sq_inc(h)) <> Nil{}
    S.sq_inc_all(P.append(xs, ys)) == P.append(S.sq_inc_all(xs), S.sq_inc_all(ys))

The first is the weak half: it is definitional, and it fixes one-element lists
only -- a body that mapped a singleton and did something else with longer lists
satisfies it. The second is the one that pins `sq_inc_all`: it is satisfied by the
identity body, which maps a concatenation to itself, and the base law is what
rules that body out. It is inductive in `xs` -- `append` matches on its first
argument, so with a variable `xs` the left-hand side does not reduce on its
own.

The first law's proof is `{==}`: the match steps on the cons cell and the tail
is `Nil{}`. The second is an induction in `xs`; its cons case puts the mapped
head outside on both sides, leaving the hypothesis at `t`. Annotate that step
with the goal in which the term the hypothesis rewrites has been replaced by
`_`, and close it with `{==}`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.sq_inc_all_single(h)` and `def L.sq_inc_all_append(xs, ys)`.
