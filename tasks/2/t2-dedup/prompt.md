Implement `dedup` on lists of `Nat`, then prove all four laws.

`dedup(xs)` removes *adjacent* duplicates: every run of equal elements is
replaced by a single copy of it. So `dedup([3n, 3n, 1n, 3n, 3n])` is
`[3n, 1n, 3n]` -- the two threes at the front collapse into one and the two at
the back collapse into one, while the middle `3n` is kept because it is not next
to an equal element. Only neighbours are compared: `dedup([3n, 1n, 3n])` is
`[3n, 1n, 3n]`. This is not a general duplicate remover.

Recurse on `xs`: `Nil{}` answers `Nil{}`, a one-element list answers itself, and
from two elements on the answer keeps the first element exactly when it differs
from the second, and continues with the deduplication of the rest of the list
from the second element on.

`P.same(a, b)` is `True{}` when the two `Nat`s are the same number, and
`P.same_put(h, r, k)` answers `r` when `k` is `True{}` and `h <> r` otherwise.
Both come from the prelude. `same_put` exists because Bend will not let a `match`
scrutinise a computed value, and `P.same(h, h2)` is one: the decision has to be
handed to a function that matches it as a parameter. `P.same` matches both of its
arguments at once, so with two variables the answer does not reduce on its own.

`dedup_nil` and `dedup_single` pin the two inputs the step cannot reach. The step
law names `a <> (b <> t)`, so it constrains only lists of two or more elements,
and a body that answered the empty list or the one-element list with a non-empty
list would satisfy it. Both sides compute in each of these two, so both are
definitional.

`dedup_cons` is the step. It is the law that says which elements come out and
where the recursion restarts. Both sides compute, because `a <> (b <> t)` is a
cons cell and the inner match on `b <> t` takes its cons case; what is left on
both sides is a `P.same_put` whose decision is `P.same(a, b)`, which is stuck on
two variables. That stuck decision is the point of the law: a body that never
drops, that always drops, or that takes the two answers the wrong way round
leaves the two sides unconvertible.

`dedup_same` is the equal-neighbour case stated on a pair that *is* equal. It is
the one law here that is not definitional: `dedup_cons` leaves the decision
behind a stuck `P.same(a, b)`, so it never lets the checker see which branch a
concrete equal pair takes, and `P.same(a, a)` does not reduce on a variable
either. Its proof is an induction on `a`, in a lemma of its own under the
reserved `Policy.*` namespace: `def Policy.same_refl(a)`, stating that
`P.same(a, a)` and `True{}` are the same `Bool`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.dedup_nil()`, `def L.dedup_single(x)`, `def L.dedup_cons(a, b, t)` and
`def L.dedup_same(a, t)`.
