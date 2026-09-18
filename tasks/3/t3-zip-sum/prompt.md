Implement `zip_sum`, then prove all four laws.

`zip_sum(xs, ys)` adds the two lists element by element and stops when the
shorter one runs out. The prelude is immutable and already has `P.len`,
`P.min` and `P.double_all`.

The two `nil` laws are definitional and are there to fix the answer where
either list is empty; they matter because a body that recursed on its second
list instead of its first would satisfy neither.

`zip_sum_len` is the induction, and its step case is the whole task. In the
`h1 <> t1` / `h2 <> t2` case the goal has `1n + P.len(S.zip_sum(t1, t2))` on
one side and `P.min(1n + P.len(t1), 1n + P.len(t2))` on the other; `P.min`
steps on both of its arguments, so those two are the same term and the step
closes with the hypothesis alone. In the two cases where a list is empty, both
sides compute to `0n` -- but only after `P.min` has seen a literal in both
positions, so check the order of the cases in your definition against the order
`P.min` steps in.

`zip_sum_self` is the law that pins the elements. Its step unfolds the two
matches, and the hypothesis is at `(t, t)`; the only thing to watch is that a
variable bound by `case h <> t:` may be used live **once** per branch
(`expected : t / observed : t (consumed more than once)` otherwise), so the
hypothesis application has to be the only live mention of `t` in that branch.
More generally every variable is Lone by default, parameters included: a
definition or pattern that needs a value twice marks it `+` (`def f(+x: Nat)`,
`case +h <> t:`), which is how the prelude writes `P.double_all`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.zip_sum_nil_left(ys)`, `def L.zip_sum_nil_right(xs)`,
`def L.zip_sum_len(xs, ys)` and `def L.zip_sum_self(xs)`. Helpers go under the
reserved `Policy.` namespace, which the gate ignores, and none of them may cite
a law.
