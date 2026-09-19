Implement `enum_from`, which enumerates a run of consecutive numbers, then prove
the laws that relate it to the length of a list.

`enum_from(n, a)` must return the list of `n` consecutive numbers that starts at
`a`, so `enum_from(3n, 5n)` is `5n <> (6n <> (7n <> Nil{}))`. Recurse on the
count: `0n` is the base case and returns `Nil{}`, and `1n+k` answers the start
in front of the run of `k` numbers that starts one above it.

The law `enum_from_zero` fixes the answer where the count is `0n`: there is
nothing to enumerate, so the list is empty. It is the weak companion of the step
law below, which reaches only a successor count.

The law `enum_from_succ` is the step. It says that a run of `1n+k` numbers
starting at `a` is `a` in front of a run of `k` numbers starting at `1n+a`, and
it is the law that pins *where* the numbers start and *how* they advance: a body
that answered the same number `n` times, or that advanced by two, leaves the two
sides of this law unconvertible.

The law `enum_from_len` says that the run has as many elements as were asked
for. It is inductive in the count, and it is the law that pins the count: the
step law alone is satisfied by a body that answers a longer or shorter run, and
this one is not.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.enum_from_zero(a)`, `def L.enum_from_succ(n, a)` and
`def L.enum_from_len(n, a)`.
