Implement `dup_all` on `List<Nat>`, then prove the two laws about it.

`dup_all(xs)` repeats every element twice, so the result is twice as long as
its input. Match on the list: `Nil{}` is `Nil{}`, and a cons cell conses its
head twice in front of the duplicated tail. `append` comes from the prelude.

The step names the head twice, and a binder is consumed on every use, so
re-bind it reusable inside the step with `+h2 = h`.

The laws are the one-element case and the append case:

    S.dup_all(h <> Nil{}) == h <> (h <> Nil{})
    S.dup_all(P.append(xs, ys)) == P.append(S.dup_all(xs), S.dup_all(ys))

The first is the weak half: it is definitional, and it fixes one-element lists
only -- a body that duplicates a singleton and does something else with longer
lists satisfies it. The second is the one that pins `dup_all`: it is satisfied
by the identity body, which maps a concatenation to itself, and the base law is
what rules that body out. It is inductive in `xs` -- `append` matches on its
first argument, so with a variable `xs` the left-hand side does not reduce on
its own.

The first law's proof is `{==}`: the match steps on the cons cell and the tail
is `Nil{}`. The second is an induction in `xs`; its cons case puts the two
copies of the head outside on both sides, leaving the hypothesis at `t` under
the same pair of `<>`s. Annotate that step with the goal in which the term the
hypothesis rewrites has been replaced by `_`, and close it with `{==}`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.dup_all_single(h)` and `def L.dup_all_append(xs, ys)`.
