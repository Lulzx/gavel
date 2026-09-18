Implement `filter` and `len` on lists of `Nat`, then prove all three laws.

`filter(xs, n)` returns the elements of `xs` that are at most `n`, in order.
`len(xs)` returns how many elements `xs` has. Both recurse on `xs`.

The prelude is immutable and already has the vocabulary: `P.le(a, b)` is the
`Bool` comparison, `P.below_count(xs, n)` counts the elements of `xs` that are
at most `n`, and `P.filter_put(h, r, k)` is the cons step of a filter with the
decision exposed as an argument. That last one is there because of a Bend
restriction rather than for convenience: **a `match` cannot scrutinise a
computed value**, so `case P.le(h, n):` inside `filter` is not a thing you can
write, and neither is a `filter` whose cons case needs two different answers
picked by a `Bool` you just computed. Recursing on `xs` and deferring the
decision is the way through.

`filter_len` is the length bound, stated exactly: the length of the result is
`P.below_count(xs, n)`, not merely at most `len(xs)`. That is an induction on
`xs`, and its step case is the whole task. Both sides compute one turn, giving
`S.len(P.filter_put(h, r, k))` against `P.below_put(c, k)` where `k` is
`P.le(h, n)` -- and the `True{}` side needs `1n + c` moved past the two lengths
before the induction hypothesis applies. `S.len(r) == c` and `1n + S.len(r) ==
1n + c` are not the same proposition, and `+` is stuck on a variable, so that
reassociation is a lemma of its own. Split on `k` and it is a short one, but
the split has to happen somewhere a `match` can reach, which is a def of its
own rather than inline.

`filter_keep` and `filter_drop` are the two cons cases, one for each answer the
predicate can give. Both are a single rewrite once you have the corresponding
fact about `P.le`: it is reflexive, and no successor is at most what it
succeeds. The first of those is itself an induction -- `P.le(a, a)` steps one
successor off each side of the same variable -- so `{==}` will not do for it
either. Both rewards pay attention to the direction of the rewrite: to replace
a term `B` in the goal you supply a proof of `{B' == B}` with `B'` the term you
want, which for these two means wrapping the lemma in `Equal.sym`. Once the
decision is a literal, `P.filter_put` computes and the goal closes by
definition.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.filter_len(xs, n)`, `def L.filter_keep(h, t)` and
`def L.filter_drop(h, y, t, e)`. Any helpers you need go under the reserved
`Policy.` namespace, which the gate ignores, and none of them may cite a law --
a helper that did would make an isolated law depend on a law that has not been
credited yet, and the credit for both would be lost.
