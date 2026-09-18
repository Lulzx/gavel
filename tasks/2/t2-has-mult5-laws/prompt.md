Implement `has_mult5` on `List<Nat>`, then prove the two laws about it.

`has_mult5(xs)` answers whether some element of `xs` is a multiple of five, which the empty list does not satisfy. Match
on the list: `Nil{}` gives `False{}`, and a cons
cell ors its head's test into the answer for its tail. `append` and
`is_mult5_b` come from the prelude. `Bool.or` matches on its first argument, so the
recursion sits on the right of the or; with a variable head the
or does not step, which is what makes the second law below an
induction rather than a computation.

The laws are the empty case and the snoc case:

    S.has_mult5(Nil{}) == False{}
    S.has_mult5(P.append(xs, x <> Nil{})) == Bool.or(S.has_mult5(xs), P.is_mult5_b(x))

The first is the weak half: it is definitional, and the constant body `False{}`
satisfies it. The second is the one that pins `has_mult5`: the constant body
`True{}` satisfies it -- `or` absorbs `True{}` on either
side -- and the base law is what rules that body out, while the constant body
`True{}` fails it because the right-hand side is then `is_mult5_b(x)`, stuck
on a variable `x`. It is inductive in `xs`: `append` matches on its first
argument, so with a variable `xs` the left-hand side does not reduce on its
own.

The first law's proof is `{==}`: the match steps on the cons cell and then
finds `False{}` for the tail. The second is an induction in `xs`. The `Nil{}`
case leaves `or(is_mult5_b(x), False{})` against `is_mult5_b(x)`;
`or` is stuck on the variable `is_mult5_b(x)`, so a helper lemma under the
reserved `Policy.` namespace proves `or(b, False{}) == b`, inductive in
`b`. The cons case uses the hypothesis flipped -- `Equal.sym` is the direction
that matters, since the goal has `has_mult5(append(t, x <> Nil{}))` on the left
and the hypothesis reads left to right -- and what is left is the head's test
in the middle of a disjunction, which a second
`Policy.` helper brings out to the front; `or`'s associativity is
inductive in its first argument, and its other two binders want to be erased,
since they appear only in the statement and never in the computation. Annotate
each step with the goal in which the term being rewritten has been replaced by
`_`, and close it with `{==}`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.has_mult5_nil()` and `def L.has_mult5_snoc(xs, x)`.
