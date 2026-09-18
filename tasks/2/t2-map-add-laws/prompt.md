Implement `map_add` on `List<Nat>`, then prove the two laws about it.

`map_add(xs, n)` adds `n` to every element of `xs`. Match on the list: `Nil{}`
is `Nil{}`, and a cons cell conses `h + n` onto the result for the tail. The
count `n` is carried along unchanged. `append` comes from the prelude.

The step names `n` twice -- once for the head and once for the recursive call --
and a binder is consumed on every use, so re-bind it reusable inside the step
with `+k = n`.

The laws are the one-element case and the append case:

    S.map_add(h <> Nil{}, n) == (h + n) <> Nil{}
    S.map_add(P.append(xs, ys), n) == P.append(S.map_add(xs, n), S.map_add(ys, n))

The first is the weak half: it is definitional, and it fixes one-element lists
only -- a body that maps a singleton and does something else with longer lists
satisfies it. The second is the one that pins `map_add`: it is satisfied by the
identity body, which maps a concatenation to itself, and the base law is what
rules that body out. It is inductive in `xs`, and `n` is the same in every
instance -- `append` matches on its first argument, so with a variable `xs` the
left-hand side does not reduce on its own.

The first law's proof is `{==}`: the match steps on the cons cell and the tail
is `Nil{}`. The second is an induction in `xs`; its cons case puts `h + n`
outside on both sides, leaving the hypothesis at `(t, n)`. Annotate that step
with the goal in which the term the hypothesis rewrites has been replaced by
`_`, and close it with `{==}`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.map_add_single(h, n)` and `def L.map_add_append(xs, ys, n)`.
