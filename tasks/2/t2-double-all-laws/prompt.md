Implement `double_all` on `List<Nat>`, then prove the two laws about it.

`double_all(xs)` replaces every element with its own double, `h + h`. Match on
the list: `Nil{}` is `Nil{}`, and a cons cell conses the doubled head onto the
doubled tail. `append` comes from the prelude.

The step names the head twice, and a binder is consumed on every use, so
re-bind it reusable inside the step with `+h2 = h`.

The laws are the one-element case and the append case:

    S.double_all(h <> Nil{}) == (h + h) <> Nil{}
    S.double_all(P.append(xs, ys)) == P.append(S.double_all(xs), S.double_all(ys))

The first is the weak half: it is definitional, and it fixes one-element lists
only -- a body that doubles a singleton and does something else with longer
lists satisfies it. The second is the one that pins `double_all`: it is
satisfied by the identity body, which maps a concatenation to itself, and the
base law is what rules that body out. It is inductive in `xs` -- `append`
matches on its first argument, so with a variable `xs` the left-hand side does
not reduce on its own.

The first law's proof is `{==}`: the match steps on the cons cell and the tail
is `Nil{}`. The second is an induction in `xs`; its cons case puts the doubled
head outside on both sides, leaving the hypothesis at `t`. Annotate that step
with the goal in which the term the hypothesis rewrites has been replaced by
`_`, and close it with `{==}`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.double_all_single(h)` and `def L.double_all_append(xs, ys)`.
