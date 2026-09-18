Implement `sum_pow2` on `List<Nat>`, then prove the two laws about it.

`sum_pow2(xs)` adds up two to the power of the element for every element of `xs`. Match on the list:
`Nil{}` adds nothing, and a cons cell adds two to the power of the element to the sum for its tail.
`append` and `pow2` come from the prelude. `+` matches on its first argument,
so the recursion sits on the right of the `+`; with a variable head the sum
does not step, which is what makes the second law below an induction rather
than a computation.

The laws are the empty case and the snoc case:

    S.sum_pow2(Nil{}) == 0n
    S.sum_pow2(P.append(xs, x <> Nil{})) == S.sum_pow2(xs) + P.pow2(x)

The first is the weak half: it is definitional, and the constant body `0n`
satisfies it. The second is the one that pins `sum_pow2`: a body that added up the
elements themselves fails it, because the right-hand side would have to be
`pow2(x)` on the nose and `x` is stuck, and the constant body `0n` fails it for
the same reason. It is inductive in `xs`: `append` matches on its first
argument, so with a variable `xs` the left-hand side does not reduce on its
own.

The first law's proof is `{==}`. The second joins the two halves with two
lemmas under the reserved `Policy.` namespace, both of them about `Nat`
addition and both inductive in their first argument: `+` does not reduce on the
right or in the middle. `add_zero` moves a trailing `+ 0n` out of the way, and
`add_assoc` reassociates -- the head's contribution arrives in the middle of a
sum and has to come out to the front. The second lemma's other two binders are
erased: they appear only in the statement, never in the computation, which is
what keeps the induction variable to a single live use.

The `Nil{}` case of the second law leaves `pow2(x) + 0n` against `pow2(x)`,
which `add_zero` settles. The cons case flips the hypothesis with `Equal.sym`
-- the goal has `sum_pow2(append(t, x <> Nil{}))` on the left and the hypothesis
reads left to right -- and then reassociates with `add_assoc`. Annotate each
step with the goal in which the term being rewritten has been replaced by `_`,
and close it with `{==}`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.sum_pow2_nil()` and `def L.sum_pow2_snoc(xs, x)`.
