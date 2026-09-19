Implement `second_max` and its walk `sec_go`, then prove all five laws.

`second_max(xs)` answers the second largest element of `xs`. On `[2n, 1n, 3n]`
that is `2n`. An empty list has no second largest element, and a one-element
list has none either, so both answer `0n`; `0n` is below every element the walk
sees, so it also serves as the walk's starting second value.

`sec_go(xs, top, second)` is the same walk with the two largest elements seen so
far carried as arguments, so that they can be updated on the way down. `Nil{}`
answers `second`, the second of the two running values -- the walk has already
folded everything in. A cons cell folds its head into both running values and
recurses on the tail: the new largest is `P.max2(h, top)`, and the new second is
`P.max2(P.min2(h, top), second)`. That second fold is the whole content of the
function: a head below the largest replaces the second only if it is above it,
which is why the comparison is `P.min2` against `top` and then `P.max2` against
`second`. `top` is read twice in that step, so the parameter is declared
reusable: `+top`.

`second_max` hands its tail to the walk together with the head, which is the
largest element of a one-element prefix, and `0n`.

The list type is `List<&2, Nat>`, the prelude's `P.min2` and `P.max2` are
immutable, and a `List<Nat>` will not unify with these. `&2` is what makes the
head legal to read twice in one branch.

`second_max_nil` fixes the answer on an empty input and it is the law that
separates `second_max` from a constant. `second_max_cons` says `second_max` is
the walk started at the head: a body that seeded the walk with `0n` twice, or
with the last element, keeps every other law here and fails this one.

`sec_go_nil` fixes the walk's answer on an empty tail -- the *second* running
value, not the first -- and `sec_go_cons` is the walk's step. Together the two
fix the walk completely at every pair the walk can start from, which is why the
running values are universally quantified in the law rather than stated at the
one pair `second_max` uses. `sec_go_cons` is the only law whose two sides look
at both running values: a body that folded the head through one comparison
only, or that dropped the head and answered the starting pair, agrees with the
pins and is separated here.

`second_max_three` is the closed value: the second largest element of
`[3n, 1n, 2n]` is `2n`, neither the largest nor the smallest.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.second_max_nil()`, `def L.second_max_cons(h, t)`, `def L.sec_go_nil(top,
second)`, `def L.sec_go_cons(h, t, top, second)` and `def L.second_max_three()`.
