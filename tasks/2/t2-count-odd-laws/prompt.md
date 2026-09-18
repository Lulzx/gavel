Implement `count_odd` on `List<Nat>`, then prove the two laws about it.

`count_odd(xs)` counts how many elements of `xs` are odd. Match on the list:
`Nil{}` counts none, and a cons cell adds `P.is_odd(h)` -- which is `1n` or
`0n` -- to the count of its tail. `append` and `is_odd` come from the prelude.
`is_odd` recurses two at a time: `0n` is not odd, `1n` is, and any other odd
number steps to the number below it. `+` matches on its first argument, so the
recursion sits on the right of the `+`; with a variable head the sum does not
step, which is what makes the second law below an induction rather than a
computation.

The laws are the empty case and the snoc case:

    S.count_odd(Nil{}) == 0n
    S.count_odd(P.append(xs, x <> Nil{})) == S.count_odd(xs) + P.is_odd(x)

The first is the weak half: it is definitional, and the constant body `0n`
satisfies it. The second is the one that pins `count_odd`: the constant body
`0n` fails it, because the right-hand side is then `is_odd(x)`, stuck on a
variable `x`, and a body that counted elements rather than odd ones fails it
too, for the same reason -- `1n` is not `is_odd(x)`. It is inductive in `xs`:
`append` matches on its first argument, so with a variable `xs` the left-hand
side does not reduce on its own.

The first law's proof is `{==}`. The second joins the two halves with two lemmas
under the reserved `Policy.` namespace, both of them about `Nat` addition and
both inductive in their first argument: `+` does not reduce on the right or in
the middle. `add_zero` moves a trailing `+ 0n` out of the way, and `add_assoc`
reassociates -- the head's contribution arrives in the middle of a sum and has
to come out to the front. The second lemma's other two binders are erased: they
appear only in the statement, never in the computation, which is what keeps the
induction variable to a single live use.

The `Nil{}` case of the second law leaves `is_odd(x) + 0n` against `is_odd(x)`,
which `add_zero` settles. The cons case flips the hypothesis with `Equal.sym` --
the goal has `count_odd(append(t, x <> Nil{}))` on the left and the hypothesis
reads left to right -- and then reassociates with `add_assoc`. Annotate each
step with the goal in which the term being rewritten has been replaced by `_`,
and close it with `{==}`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.count_odd_nil()` and `def L.count_odd_snoc(xs, x)`.
