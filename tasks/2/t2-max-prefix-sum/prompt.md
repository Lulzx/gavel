Implement `max_prefix_sum` and its walk `max_prefix_sum_go` on lists of `Nat`,
then prove the five laws about them.

`max_prefix_sum(xs)` is the largest sum over any prefix of `xs`. The empty
prefix is one of the prefixes and sums to `0n`, so an empty list answers `0n`
and no prefix of a list of `Nat` sums to less. The answer is a `Nat`, and both
functions' answers are `Nat`.

Both lists are `List<&2, Nat>`, which is `Data`, so a binder may be declared
reusable. The prelude is immutable and carries the comparison the walk folds its
running best with: `P.max2(a, b)` is the larger of the two numbers, and it
matches on both arguments at once, so on a pair of variables it is stuck.

`max_prefix_sum_go(xs, acc, best)` walks `xs` carrying two running values: `acc`,
the sum of the elements consumed so far, and `best`, the largest prefix sum seen
so far. The empty list answers `best` -- there is no prefix left to consider. A
cons cell adds its head to `acc`, keeps whichever of the new sum and `best` is
larger, and recurses on the tail. The new sum is read twice in that step, once
as the next accumulator and once inside the comparison, so both the head and
`acc` are declared reusable: `+h` and `+acc`.

`max_prefix_sum(xs)` is the walk started at `0n` for both running values.

`max_prefix_sum_nil` is the absolute anchor -- its right-hand side calls no
target -- and it is the only law that reaches the empty input.
`max_prefix_sum_walk` says the answer is the walk started at that pair, at every
list, and it is the law a body that seeded the walk differently fails. `mpg_nil`
pins which of the two running values the walk answers at the end.

`mpg_cons` is the law with the content: it writes the walk's step out, with both
running values universally quantified, so it holds at every pair the walk can be
started from. A body that lagged one prefix behind -- carrying the head into the
sum but not into the best -- or that took the largest *element* seen for the
best rather than the largest *prefix sum*, satisfies the laws above and is
separated here. `max_prefix_sum_three` is closed: it fixes what the walk comes
to on `[3n, 1n, 2n]`, whose prefixes sum to `0n`, `3n`, `4n` and `6n`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.max_prefix_sum_nil()`, `def L.max_prefix_sum_walk(xs)`,
`def L.mpg_nil(acc, best)`, `def L.mpg_cons(h, t, acc, best)` and
`def L.max_prefix_sum_three()`. Helpers go under the reserved `Policy.`
namespace, which the gate ignores, and none of them may cite a law.
