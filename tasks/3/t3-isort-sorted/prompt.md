Implement `insert` and `isort` on lists of `Nat`, then prove all six laws.

`insert(xs, y)` returns `xs` with `y` inserted, assuming `xs` is sorted.
`isort(xs)` sorts `xs` by inserting each element into the sorted tail. Both
recurse on `xs`.

The prelude is immutable and already has the vocabulary: `P.le(a, b)` is the
`Bool` comparison; `P.sorted_put(t, h, k)` says that `h <> t` is sorted given
the decision `k` about `h` against the element before it; `P.is_sorted(xs)` is
`P.sorted_put(xs, 0n, True{})`, a `0n` in front of everything being a settled
first decision; `P.len(xs)` counts the elements; and `P.insert_put(t, h, y, k)`
is the cons step of an insert with the decision exposed as an argument. That
last one is there because of a Bend restriction rather than for convenience:
**a `match` cannot scrutinise a computed value**, so `case P.le(y, h):` inside
`insert` is not a thing you can write. Recursing on the list and deferring the
decision is the way through.

`isort_sorted` is the induction and its step case is the whole task. Both sides
compute one turn: `isort(h <> t)` is `insert(isort(t), h)`, so the goal becomes
sortedness of an insert applied to a list the induction hypothesis already
describes -- and what the hypothesis is about is `isort(t)`, which is not a
list anything can match on. The insert has to be unfolded against that opaque
list, which makes the step a lemma of its own: at the point of the call, the
sortedness of `isort(t)` is an assumption, and everything the cons step of
`insert_put` needs to know about the element before `h` -- that it is at most
`h`, and that the decision that gets passed further down is the one `P.le`
would compute -- has to arrive as a parameter rather than be derived on the
spot. The decisions are Bools, so the proof splits on them, and the cells where
the two disagree are where the work is: the element being inserted lands
between two elements whose order is exactly the assumption that has to be
carried past it, and the cell that cannot be inhabited is a contradiction.

`insert_sorted` is the same lemma again at the top, with `0n` as the lower
bound `sorted_put` starts from, and `insert_le` and `insert_gt` are the two
cons cases of `insert` on a one-element list. Those two are a single rewrite
each once the decision is a literal. `isort_swap` is the same shape twice
over: `isort(x <> y <> Nil{})` computes down to `P.insert_put` on a literal
list, and again the decision is the only thing left.

`insert_len` is there for a different reason, and it is the law to think about
before the others. Everything above is a sortedness predicate or a statement
about a list of at most two elements, and a list with elements missing is still
sorted: an `insert` that answered a two-element list whenever it was handed a
longer one satisfies all five of them, and the two-element cases agree because
that is exactly how long their arguments are. Nothing counted. `insert_len`
counts: it says the answer is one element longer than the argument, and it is
what ties the answer to the list it came from rather than only to its order.
Its proof is an induction in `xs` whose step passes through a helper -- a
`Policy.` lemma about `P.insert_put`'s own length, four cases over the list and
the decision -- and the step that recurses needs the helper's equation the
other way round, so it is an `Equal.sym` around the recursive call.

One fact is not free: `P.le` decides the same way in the other direction when
it answers `False{}`, and the step case needs both directions at once. That
fact is an induction of its own -- step a successor off each side of the same
variable, the way `P.le` itself walks -- and its `0n` case is a contradiction:
`P.le(b, 0n)` is `True{}` while the assumption says `False{}`. A contradiction
proves anything through `Equal.cong`, but only if the two sides are the same
symbol: **the checker does not unfold a def whose scrutinee is stuck**, so two
different predicates applied to an uncomputed list are never the same term, and
every step of the proof has to stay inside `P.sorted_put`. The direction of
each rewrite is the one that matters: to replace a term `B` in the goal you
supply a proof of `{B' == B}` with `B'` the term you want, which is
`Equal.sym` around a lemma that points the other way.

The laws bind lists and `Nat`s `+` because their step cases mention the tail
twice -- once as the argument of a recursive call and once inside a function
being folded over it -- so a list in these statements is a `List<&2, Nat>` and
a binder used twice is allowed to be used twice. Write the implementations in
`solution.bend` and the proofs in `PROOF.bend`, as `def L.isort_sorted(xs)`,
`def L.insert_sorted(xs, y, e)`, `def L.insert_le(x, y, e)`,
`def L.insert_gt(x, y, e)`, `def L.isort_swap(x, y, e)` and
`def L.insert_len(xs, y)`. Any helpers you
need go under the reserved `Policy.` namespace, which the gate ignores, and
none of them may cite a law -- a helper that did would make an isolated law
depend on a law that has not been credited yet, and the credit for both would
be lost.
