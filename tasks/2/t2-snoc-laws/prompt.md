Implement `snoc` on `List<Nat>`, then prove the two laws about it.

`snoc(xs, x)` appends `x` to the end of `xs`. Match on the list: `Nil{}` gives
the one-element list `x <> Nil{}`, and a cons cell conses its head onto the
`snoc` of its tail. `append` comes from the prelude.

The laws are the empty case and the append case:

    S.snoc(Nil{}, x) == x <> Nil{}
    S.snoc(P.append(xs, ys), x) == P.append(xs, S.snoc(ys, x))

The first is the weak half: it is definitional, and a body that ignores the list
and answers `x <> Nil{}` satisfies it. The second is the one that pins `snoc`:
the constant body fails it, and so does a body that puts `x` in front instead of
at the end. It is inductive in `xs` -- `append` matches on its first argument,
so with a variable `xs` the left-hand side does not reduce on its own.

The first law's proof is `{==}`. The second is an induction in `xs`: its
`Nil{}` case is definitional on both sides, and its cons case reduces both sides
to the same head consed onto the hypothesis at `t`. Annotate that step with the
goal in which the term the hypothesis rewrites has been replaced by `_`, and
close it with `{==}`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.snoc_nil(x)` and `def L.snoc_append(xs, ys, x)`.
