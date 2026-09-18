Implement `any` on the prelude's `List<&2, Bool>`, then prove all three laws.

`any(xs)` answers whether any element of `xs` is `True{}`. The prelude is
immutable and already has the vocabulary the laws are stated in: `P.append`,
which is the only function the laws compare `any` against besides Base's
`Bool.or`. `List<&2, Bool>` is the list type here, and a law or helper written
over `List<Nat>` will not unify with these.

The two pins are definitional. `any_nil` fixes the empty answer, and `any_cons`
fixes one step of the search -- the head is folded into the search of the tail.
Both sides of each compute, so `{==}` closes them, and the reason they are worth
stating is that the head is a *variable* of type `Bool`: a body that ignored it
and searched only the tail comes out wrong for one of its two values, and a body
that answered its first element has nothing to answer with on the empty list.

The real work is `any_append`, and it needs an induction on the list. Its step
unfolds the left-hand side into a search of the tail, applies the hypothesis
there, and is left with `Bool.or` associated the other way round:

    case h <> t:
      -- goal: any(append(h <> t, ys)) == or(any(h <> t), any(ys))
      -- unfolds to: or(h, any(append(t, ys))) == or(or(h, any(t)), any(ys))
      -- the hypothesis rewrites the middle, and what is left is
      -- or(h, or(any(t), any(ys))) == or(or(h, any(t)), any(ys))

`Bool.or` is a definition, not an associative operator, so that last step needs a
helper of its own. `Bool.or` matches on its first argument, so with a variable on
the left the goal is stuck and the helper is a case analysis on both values
rather than an unfolding.

The helper belongs under the reserved `Policy.` namespace, which the gate ignores
and the credit path does not count. A helper may call `P.*`, `S.*` and other
`Policy.*`, but never a law, since a helper that cited one would make an isolated
law depend on a law that has not been credited yet and the credit for both would
be lost.

A variable is Lone by default -- usable live once per branch -- so the list of
the law is `for +xs` and the tail is rebound in the step before its second use,
or the checker reports `consumed more than once`.

The direction of every rewrite is the one that matters. A rewrite `%e : P` fills
the hole in the motive `P` at the position of the *right* side of `e`'s equation
and puts the left side there, so `P` is the goal with the hole exactly where the
term you want to replace sits, and `Equal.sym` is how a lemma that points the
other way is turned around. A motive with the hole anywhere else is rejected
with `expected`/`observed` about the hole's type, which reads like a bug in the
lemma and is not one.

The law file imports the prelude as `P` and the solution as `S`, and the solution
does not re-export the prelude, so a law that means the prelude's `append` must
say `P.append`; naming `S.append` gets `expected : a defined name / observed :
S.append`, which also reads like a proof bug and is not one.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.any_nil()`, `def L.any_cons(h, t)` and `def L.any_append(xs, ys)`,
and each may cite the earlier helpers but never one of the other laws. Write the
implementation in `solution.bend` and the proofs in `PROOF.bend`.
