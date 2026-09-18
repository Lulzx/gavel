Implement `sub_all` on `List<Nat>`, then prove the two laws about it.

`sub_all(xs, n)` subtracts `n` from every element, `P.sub(h, n)`. Match on the
list: `Nil{}` is `Nil{}`, and a cons cell conses the reduced head onto the
reduced tail. `append` and `sub` come from the prelude.

The step names `n` twice, and a binder is consumed on every use, so re-bind it
reusable inside the step with `+k = n`.

The laws are the one-element case and the append case:

    S.sub_all(h <> Nil{}, n) == P.sub(h, n) <> Nil{}
    S.sub_all(P.append(xs, ys), n) == P.append(S.sub_all(xs, n), S.sub_all(ys, n))

The first is the weak half: it is definitional, and it fixes one-element lists
only -- a body that reduces a singleton and does something else with longer
lists satisfies it. The second is the one that pins `sub_all`: it is satisfied
by the identity body, which maps a concatenation to itself, and the base law is
what rules that body out. It is inductive in `xs` -- `append` matches on its
first argument, so with a variable `xs` the left-hand side does not reduce on
its own.

The first law's proof is `{==}`: the match steps on the cons cell and the tail
is `Nil{}`. The second is an induction in `xs`; its cons case puts the reduced
head outside on both sides, leaving the hypothesis at `t` and `n`. Annotate that
step with the goal in which the term the hypothesis rewrites has been replaced
by `_`, and close it with `{==}`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.sub_all_single(h, n)` and `def L.sub_all_append(xs, ys, n)`.
