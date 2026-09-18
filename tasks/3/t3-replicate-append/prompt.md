Implement `replicate` on `Nat` and `List<Nat>`, then prove all four laws.
`replicate(n, x)` returns the list of `n` copies of `x`, and it recurses on the
count.

The prelude is immutable and already has the vocabulary: `P.append(xs, ys)`,
`P.len(xs)`, `P.snoc(xs, y)` and `P.rev(xs)`, each matching on its first
argument, with `rev` built on `snoc` so that reversing a cons puts its head on
the right of the reversal of the tail.

`replicate_append` is where the recursion shape has to be respected: `replicate`
recurses on the count, so the second count is a parameter of the induction
rather than a literal, and the left-hand side only unfolds because a
successor-added count still reduces -- `(1n + p) + m` folds to `1n + (p + m)`
before `replicate` steps on it, while the appended tail is split off by `append`
at the same moment.

`replicate_len` and `replicate_single` are the induction over that count and the
literal case: `len` folds over a `replicate` that is one turn away from being a
cons, and one copy is the literal count `1n`, on which both sides compute
straight to `x <> Nil{}`.

`rev_replicate` is the law that needs a lemma of its own. Its step case reverses
a cons, which begins a `snoc` of the shorter run, and the fact that a `snoc` of a
run of `x` is one more copy of `x` is not definitional: it is an induction in its
own right, and the step cannot be closed without it. That lemma is also why the
law cannot carry the induction on its own sleeve: a law-filling def binds bare
names, and this step consults `x` twice, so the induction that needs both uses
belongs in a helper, where the binders may be marked non-linear.

The direction of each rewrite is the one that matters: to replace a term `O` in
the goal you supply a proof of `{R == O}` with `R` the term you want, which is
`Equal.sym` around a lemma that points the other way.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.replicate_len(n, x)`, `def L.replicate_append(n, m, x)`,
`def L.replicate_single(x)` and `def L.rev_replicate(n, x)`, in that order. Any
helpers you need go under the reserved `Policy.` namespace, which the gate
ignores, and none of them may cite a law -- a helper that did would make an
isolated law depend on a law that has not been credited yet, and the credit for
both would be lost.
