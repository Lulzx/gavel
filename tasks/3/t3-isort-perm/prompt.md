Implement `insert` and `isort` on lists of `Nat`, then prove all four laws.

`insert(xs, y)` returns `xs` with `y` inserted; `isort(xs)` sorts `xs` by
inserting its elements into the tail. Both recurse on `xs`.

The prelude is immutable and already has the vocabulary, in two halves.
`P.le(a, b)` is the `Bool` comparison and `P.insert_put(t, h, y, k)` is the cons
step of an insert with the decision exposed as an argument. That last one is
there because of a Bend restriction rather than for convenience: **a `match`
cannot scrutinise a computed value**, so `case P.le(y, h):` inside `insert` is
not a thing you can write, and a `match` cannot reach a `let`-bound `Bool`
either. Recursing on the list and deferring the decision is the way through.
`P.eq(a, b)` is structural equality, `P.ind(b)` turns a decision into `1n` or
`0n`, `P.count_put(h, r, b)` is the cons step of a count with the decision
exposed (and `r` the count of the tail), and `P.count(z, xs)` counts the
elements of `xs` equal to `z`.

`insert_count` is the multiset behaviour of `insert`, and `isort_count` is the
permutation law: `isort` keeps every element's multiplicity. `isort_count` is
the induction. Its step case computes one turn on each side, giving
`P.count(z, S.insert(S.isort(t), h))` against `count(z, h <> t)` -- and the
element has to be counted at the head of the left side while the two `count`s
are tied together, so the fact the step needs is about `insert`, not about
`isort`: insert counts as one more `ind` of the element plus the count of the
list it went into. That lemma is an induction of its own on the same list, and
it is where the work is.

Three traps make it longer than it looks. First, the decision `P.le(y, h)` is a
`Bool` the recursion computes, so no `match` can reach it and no `let`-bound
copy of it can be matched either: it has to arrive as a parameter of a def, and
the goal has to be stated with the *computed* comparison sitting in the places
the parameter occupies, tied to it by an equation binder (`{b == P.le(y, h) :
Bool}`) so the two can be swapped with a rewrite. Second, `P.count_put` and
`P.count` are stuck on a comparison that never computes, and a stuck term is not
convertible to the sum it should be: what unsticks it is instantiating a lemma
whose decision is a *parameter* with the stuck comparison itself, which is a
legal call and gives an equation the checker will rewrite with even though
neither side computes. Third, `insert` leaves the element in place in its
`False` case, so the two counted elements arrive at the front of the sum in the
opposite order to the one the statement wants, and swapping two `Nat`s across a
stuck tail needs `a + b == b + a`, which is not free: it is an induction that
needs `a + 1n == 1n + a` and the associativity of `+` as well. All of that
arithmetic is provable in a few lines each, the way `+` itself walks, but it has
to exist before the count lemma can be finished.

The direction of every rewrite is the one that matters. A `%e : P` demands the
goal be `P` with e's *right* side in the hole and steps to `P` with e's left
side there, so to replace a term `B` with `B'` the evidence supplied has to have
type `{B' == B}` -- which for a lemma that points the other way means wrapping it
in `Equal.sym`. Type positions in a rewrite's motive are checked dead, so a
motive may mention a binder freely; a *live* use is what the linearity tally
counts.

The laws bind their lists and their `Nat`s `+` because the statements mention
each of them more than once, and the same goes for the defs that fill them: a
parameter used twice live has to be declared reusable. Write the implementations
in `solution.bend` and the proofs in `PROOF.bend`, as `def L.insert_count(xs, y,
z)`, `def L.isort_count(xs, z)`, `def L.isort_swap(x, y, e)` and
`def L.isort_keep(x, y, e)`, in that order. Any helpers you need go under the
reserved `Policy.` namespace, which the gate ignores, and none of them may cite a
law -- a helper that did would make an isolated law depend on a law that has not
been credited yet, and the credit for both would be lost.
