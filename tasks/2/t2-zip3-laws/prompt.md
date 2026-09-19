Implement `zip3` on lists of `Nat`, then prove all five laws.

`zip3(xs, ys, zs)` adds the three lists element by element and stops when the
shortest of them runs out. So `zip3([1n, 2n], [10n, 20n, 30n], [100n])` is
`[111n]`. Recurse on all three at once: an empty list on any side gives `Nil{}`,
and otherwise the three heads are added -- the sum is `(h1 + h2 + h3)`, left
associated -- and the three tails are zipped.

The prelude is immutable and already has the vocabulary the laws are stated in:
`P.len`, the length of a list, and `P.min3(a, b, c)`, the smallest of three
counts. `P.min3` steps one successor off all three arguments at once, and it
matches them one at a time, so a term whose three arguments are not all
successors computes without the later ones being looked at.

The three `nil` laws fix the answer wherever any list is empty, and each is
there because the others cannot reach its case: `zip3_nil_left` constrains only
an empty *first* list, `zip3_nil_mid` only an empty second one, and
`zip3_nil_right` only an empty third -- so a body that recursed on the first
list alone, or on the three lists in the wrong order, is not touched by the ones
above it. Each is a match on a literal, and each is proved by the induction its
position needs: the left one needs none, the middle one is stuck until the first
list is split, and the right one is stuck until the first two are.

`zip3_len` is the count law, and it is stated exactly rather than as a bound:
the answer is `P.min3` of the three lengths, so it pins the *stopping point*,
and a body that padded the short lists out to the long one, or stopped at the
longest of the three, fails it. `P.len` folds over `zip3` and `P.min3` steps
through all three of its arguments, so the induction's step case is one use of
the hypothesis and nothing else.

`zip3_cons` is the law that says *which* numbers: the three heads are added, and
the answer continues with the zip of the tails. The three laws above are about
empty cases and about counts; none of them reads a head, so a body that answered
`(h1 + h1 + h1) <> zip3(t1, t2, t3)` -- reading only the first of the three
elements -- has the right length everywhere and is caught by this one alone.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.zip3_nil_left(ys, zs)`, `def L.zip3_nil_mid(xs, zs)`,
`def L.zip3_nil_right(xs, ys)`, `def L.zip3_len(xs, ys, zs)` and
`def L.zip3_cons(h1, t1, h2, t2, h3, t3)`.
