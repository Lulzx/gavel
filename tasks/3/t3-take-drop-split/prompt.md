Implement `take` and `drop` on lists of `Nat`, then prove all three laws.

`take(n, xs)` returns the first `n` elements of `xs` and `drop(n, xs)` returns
everything after them. Both count up from zero, so both step on the count and
look at the list only to see whether anything is left.

The prelude is immutable and already has the vocabulary: `P.append`, `P.len`
and `P.min`. `P.min` steps on its first argument and then on its second, in the
same order `take` runs out of count and list, and that is what makes the length
law a single induction rather than a case split over which side ran out first.

All three proofs are inductions on the count, with the list as the second case
of each count step, and each one closes with a single use of the hypothesis.
That single use is not a stylistic choice. A variable is **Lone** by default
-- it may be used live once -- and that holds for a parameter of a `def` just
as much as for a pattern binder. The ways to say otherwise are the `+` marker
(`+p: Nat` in a signature, `case +h <> t:` in a pattern) and a rebinding line
at the top of a branch, `+p = p`, which makes an unrestricted copy. A `Nat`
pattern binder is one the checker will accept that marker on, `case +k <> t:`
or a `+k = k` line at the top of the branch, which is what `drop_drop`'s step
needs for the two counts; a list binder is not -- `+t = t` is rejected with
`expected : Data, observed : Type` --
so for the two laws that destructure the list, the hypothesis has to be the
only live mention of the tail, and any other fact about the tail has to be
stated so that the tail can be passed in an erased position. That is the shape
of `Policy.add_assoc` in the corpus, not of these.

Two places where the goal does not compute on its own:

- `drop_drop`'s `Nil{}` case. The left-hand side is `S.drop(m, Nil{})` with `m`
  a variable, and `drop` matches on its count, so it is stuck; the right-hand
  side computes to `Nil{}`. That stuck term is not a fact you can unfold your
  way past -- it wants a lemma of its own, an induction on `m`, and there is no
  way to state it without one.
- The `1n + k` case of the same law, where `(1n + k) + m` has to be seen as
  `1n + (k + m)` before `drop` will step. `+` is `Nat.add` and it matches on
  its left argument, so that reassociation is definitional -- but check it in
  the direction you need, because the other one is not.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.take_drop(n, xs)`, `def L.drop_drop(n, m, xs)` and `def L.take_len(n, xs)`.
Any helpers you need go under the reserved `Policy.` namespace, which the gate
ignores, and none of them may cite a law -- a helper that did would make an
isolated law depend on a law that has not been credited yet, and the credit for
both would be lost.
