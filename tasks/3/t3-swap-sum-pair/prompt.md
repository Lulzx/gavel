Implement `swap_each` and `sum_pair` on a list of records, then prove all six
laws.

`swap_each(ps)` swaps the two halves of every record:
`swap_each([P.MkPair{1n, 2n}, P.MkPair{3n, 4n}])` is
`[P.MkPair{2n, 1n}, P.MkPair{4n, 3n}]`. The records are what the two functions
pass each other, and the prelude's `P.MkPair{a, b}` is the only thing in it.

`sum_pair(ps)` adds up both halves of every record, first half first:
`sum_pair([P.MkPair{1n, 2n}, P.MkPair{3n, 4n}])` is `1n + (2n + (3n + (4n + 0n)))`.
The arithmetic is `+`, which the base already has, so the prelude holds nothing
but the record.

Both functions match on the list of records: `Nil{}` is the base -- `Nil{}` for
the swap and `0n` for the sum -- and a cons cell takes its record apart and
recurses on the rest. The record is taken apart in the pattern, as
`case P.MkPair{a, b} <> t:`, so the swap can put the two halves back the other
way round.

`swap_each_nil` and `sum_pair_nil` fix the two answers on an empty list, which no
other law here reaches. `swap_each_cons` and `sum_pair_cons` fix one step of
each, and both are definitional: the first is the only law that says which way
round the halves go, and the second is what says the sum is over the halves of
each record rather than over the records themselves.

`swap_each_swap_each` says swapping every record twice is the identity. It is an
induction: with a variable `ps` neither side computes, since `swap_each` is stuck
until its argument is a cons. It is not enough on its own -- a body that sorted
the records onto the ends of the list is its own inverse twice over as well --
but with `swap_each_cons` it closes the shape of that function.

`sum_pair_swap_each` is the interaction and the reason the two functions are one
task: swapping the halves of every record does not change the sum of them all,
because the same numbers are still added up, only in the other order within each
record. It is the only law here that mentions both functions, so it is what pins
them against each other rather than one at a time. It is the work: with a
variable `ps` neither side computes, so it is an induction, and its step reaches
`b + (a + s)` against `a + (b + s)` -- the two halves of one record in the other
order, over the sum `s` of the rest -- which is commutativity of `+` read through
associativity on both sides. Those are facts about `+` that neither the base nor
the prelude states, and they belong in `PROOF.bend` as `Policy.*` helpers: a law
that cited another law would make the credit for both depend on the citation.
Note that `+` matches on its left argument, so none of them is definitional and
each is an induction of its own.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.swap_each_nil()`, `def L.swap_each_cons(a, b, t)`, `def L.sum_pair_nil()`,
`def L.sum_pair_cons(a, b, t)`, `def L.swap_each_swap_each(ps)` and
`def L.sum_pair_swap_each(ps)`.
