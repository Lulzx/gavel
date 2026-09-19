Implement `extremes` and its walk `ext_go`, then prove all six laws.

`extremes(xs)` answers the smallest and the largest element of a non-empty `xs`,
as a two-element list with the smallest one in front: `extremes([3n, 1n, 2n])`
is `[1n, 3n]`. The empty list has no elements to answer with, so
`extremes(Nil{})` is `Nil{}`.

`ext_go(xs, lo, hi)` is the same walk, carrying the two running values as
arguments so that they can be updated on the way down. `Nil{}` answers
`lo <> hi <> Nil{}`. A cons cell folds its head into both running values --
`P.min2(h, lo)` for the first and `P.max2(h, hi)` for the second -- and recurses
on the tail. `extremes` walks the tail of a cons cell starting from the head,
read twice, which is what the second walk is for.

The list type is `List<&2, Nat>`, the prelude's `P.min2`, `P.max2` and `P.len`
are immutable, and a `List<Nat>` will not unify with these. Read the head twice
in one branch and the element type is what makes that legal: a variable is
**Lone** by default, so `&2` is required for a second read, exactly as in
`t2-span-below`.

`extremes_nil` fixes the answer on an empty input and `extremes_single` on a
one-element one. The two cons laws below name a list with at least one element,
so neither reaches the empty case, and `extremes_single` is what catches a walk
that was seeded with a constant rather than with the head.

`extremes_cons` says `extremes` is the walk started at the head: `x` is passed
as both running values, which is the only place the start is stated.
`ext_go_nil` fixes the walk's answer on an empty tail, with the *first* running
value in front, and `ext_go_cons` is the walk's step: the head is folded into
both running values and the walk continues on the tail. Together with
`ext_go_nil` it fixes the walk completely, and it is the only law whose two
sides read the running values at all.

`ext_go_len` is the work, and the one law here that is not an unfolding: the
walk answers exactly two elements, whatever the list and whatever pair the walk
starts from. With a variable list neither side reduces, so this is an induction
on `xs`. It is what says the walk consumes the whole tail rather than stopping
early, and it is why `lo` and `hi` are universally quantified in the law: a
version stated only at the pair `extremes` starts with would not be strong
enough for the induction's own step.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.extremes_nil()`, `def L.extremes_single(x)`, `def L.extremes_cons(x, xs)`,
`def L.ext_go_nil(lo, hi)`, `def L.ext_go_cons(h, t, lo, hi)` and
`def L.ext_go_len(xs, lo, hi)`.
