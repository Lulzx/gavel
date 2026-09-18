Implement `all_even` on `List<Nat>`, then prove the two laws about it.

`all_even(xs)` answers whether every element of `xs` is even, which the empty
list is, vacuously. Match on the list: `Nil{}` gives `True{}`, and a cons cell
ands its head's test into the answer for its tail. `append` and `is_even_b`
come from the prelude. `Bool.and` matches on its first argument, so the
recursion sits on the right of the `and`; with a variable head the `and` does
not step, which is what makes the second law below an induction rather than a
computation.

The laws are the empty case and the snoc case:

    S.all_even(Nil{}) == True{}
    S.all_even(P.append(xs, x <> Nil{})) == Bool.and(S.all_even(xs), P.is_even_b(x))

The first is the weak half: it is definitional, and the constant body `True{}`
satisfies it. The second is the one that pins `all_even`: the constant body
`False{}` satisfies it -- `and` absorbs `False{}` on either side -- and the
base law is what rules that body out, while the constant body `True{}` fails
it because the right-hand side is then `is_even_b(x)`, stuck on a variable
`x`. It is inductive in `xs`: `append` matches on its first argument, so with
a variable `xs` the left-hand side does not reduce on its own.

The first law's proof is `{==}`: the match steps on the cons cell and then
finds `True{}` for the tail. The second is an induction in `xs`. The `Nil{}`
case leaves `and(is_even_b(x), True{})` against `is_even_b(x)`; `and` is stuck
on the variable `is_even_b(x)`, so a helper lemma under the reserved `Policy.`
namespace proves `and(b, True{}) == b`, inductive in `b`. The cons case uses
the hypothesis flipped -- `Equal.sym` is the direction that matters, since the
goal has `all_even(append(t, x <> Nil{}))` on the left and the hypothesis
reads left to right -- and what is left is the head's test in the middle of a
conjunction, which a second `Policy.` helper brings out to the front; `and`'s
associativity is inductive in its first argument, and its other two binders
want to be erased, since they appear only in the statement and never in the
computation. Annotate each step with the goal in which the term being
rewritten has been replaced by `_`, and close it with `{==}`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.all_even_nil()` and `def L.all_even_snoc(xs, x)`.
