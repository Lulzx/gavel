Implement `min_all` on `List<Nat>`, then prove the two laws about it.

`min_all(xs, n)` caps every element above `n` down to `n`, `P.min(h, n)`.
Match on the list: `Nil{}` is `Nil{}`, and a cons cell conses the capped head
onto the capped tail. `append` and `min` come from the prelude.

The step names `n` twice, and a binder is consumed on every use, so re-bind it
reusable inside the step with `+k = n`.

The laws are the one-element case and the append case:

    S.min_all(h <> Nil{}, n) == P.min(h, n) <> Nil{}
    S.min_all(P.append(xs, ys), n) == P.append(S.min_all(xs, n), S.min_all(ys, n))

The first is the weak half: it is definitional, and it fixes one-element lists
only -- a body that caps a singleton and does something else with longer lists
satisfies it. The second is the one that pins `min_all`: it is satisfied by the
identity body, which maps a concatenation to itself, and the base law is what
rules that body out. It is inductive in `xs` -- `append` matches on its first
argument, so with a variable `xs` the left-hand side does not reduce on its own.

The first law's proof is `{==}`: the match steps on the cons cell and the tail
is `Nil{}`. The second is an induction in `xs`; its cons case puts the capped
head outside on both sides, leaving the hypothesis at `t` and `n`. Annotate that
step with the goal in which the term the hypothesis rewrites has been replaced
by `_`, and close it with `{==}`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.min_all_single(h, n)` and `def L.min_all_append(xs, ys, n)`.
