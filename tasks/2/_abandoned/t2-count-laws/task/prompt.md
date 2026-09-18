Implement `count` on `List<Nat>`, then prove the two laws about it.

`count(xs, n)` is the number of elements of `xs` that equal `n`. Match on the
list: `Nil{}` counts none, and a cons cell adds `P.eq(h, n)` -- which is `1n` or
`0n` -- to the count of its tail. `append` and `eq` come from the prelude.

The step names `n` twice, and a binder is consumed on every use, so re-bind it
reusable inside the step with `+k = n`.

The laws are the empty case and the snoc case:

    S.count(Nil{}, n) == 0n
    S.count(P.append(xs, x <> Nil{}), n) == S.count(xs, n) + P.eq(x, n)

The first is the weak half: it is definitional, and the constant body `0n`
satisfies it. The second is the one that pins `count`: the constant body `0n`
fails it, because the right-hand side is then `eq(x, n)`, stuck on a variable
`x`, and a body that counted elements rather than occurrences fails it too, for
the same reason -- `1n` is not `eq(x, n)`. It is inductive in `xs`: `append`
matches on its first argument, so with a variable `xs` the left-hand side does
not reduce on its own.

The first law's proof is `{==}`. The second joins the two halves with two
lemmas under the reserved `Policy.` namespace, both of them about `Nat` addition
and both inductive in their first argument: `+` does not reduce on the right or
in the middle. `add_zero` moves a trailing `+ 0n` out of the way, and
`add_assoc` reassociates -- the head's contribution arrives in the middle of a
sum and has to come out to the front. The second lemma's other two binders are
erased: they appear only in the statement, never in the computation, which is
what keeps the induction variable to a single live use.

The `Nil{}` case of the second law leaves `eq(x, n) + 0n` against `eq(x, n)`,
which `add_zero` settles. The cons case flips the hypothesis with `Equal.sym` --
the goal has `count(append(t, x <> Nil{}), n)` on the left and the hypothesis
reads left to right -- and then reassociates with `add_assoc`. Annotate each
step with the goal in which the term being rewritten has been replaced by `_`,
and close it with `{==}`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.count_nil(n)` and `def L.count_snoc(xs, x, n)`.
