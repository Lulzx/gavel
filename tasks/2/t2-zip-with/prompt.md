Implement `zip_with` on two lists of `Nat`, then prove all five laws.

`zip_with(xs, ys)` combines the two lists element by element and stops when the
shorter of them runs out. The combination is the prelude's `P.max`, so
`zip_with([1n, 7n], [4n, 2n])` is `[4n, 7n]`. Recurse on the first list and then
on the second: the empty list on either side answers `Nil{}`, and otherwise the
two heads are combined with `P.max` and the two tails are combined in the same
way. That is the order `P.min` steps through its two arguments in, and the count
law below is stated with it.

The prelude is immutable and already has the vocabulary the laws are stated in:
`P.max`, the operation a pair of elements is combined with; `P.len`, the length
of a list; and `P.min`, the smaller of two counts.

`zip_with_nil_left` and `zip_with_nil_right` fix the two empty cases. Neither
one reaches a cons cell, and each constrains only its own side: a body that
recursed on the second list instead of on the two together satisfies the first
and leaves the second unconvertible.

`zip_with_len` is the count law: the answer is as long as the shorter input,
stated exactly as `P.min(P.len(xs), P.len(ys))` rather than as a bound. It is an
induction on the list, and it is the law that catches a body that padded the
short list out to the long one.

`zip_with_self` is the law about the operation rather than about the zipping.
`P.max` is idempotent, so combining a list with itself gives the list back, and
this is the law that says which elements come out: the count law and the two
empty laws would all be satisfied by a body whose elements were all `0n`. A
pairing `zip` cannot have a law of this shape at all, since a pair of an element
with itself is not the element.

`zip_with_cons` is the step, and it is the law that reads a pair of *different*
elements: on the diagonal the two heads of `zip_with_self` are the same element,
so the laws above would all be proved by a body that never read the second
list's element -- `P.max(h1, h1) <> zip_with(t1, t2)` satisfies every one of
them. Both sides of this law compute, so it settles which element is combined
with which.

Together the laws determine the body: the two empty cases are fixed, the step
says what a cons cell becomes, and the count and the diagonal say that the
recursion is on the two tails.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.zip_with_nil_left(ys)`, `def L.zip_with_nil_right(xs)`,
`def L.zip_with_len(xs, ys)`, `def L.zip_with_self(xs)` and
`def L.zip_with_cons(h1, t1, h2, t2)`.
