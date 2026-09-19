Implement `count_runs` on lists of `Nat`, then prove the four laws about it.

`count_runs(xs)` is the number of maximal runs of equal neighbours in `xs`.
`count_runs([1n, 1n, 2n, 3n, 3n])` is `3n`: one run of `1n`s, one `2n`, one run
of `3n`s. Recurse on `xs`: `Nil{}` answers `0n`, a one-element list answers `1n`,
and from two elements on the answer is the count of the list starting at the
second element, plus one when the first two differ.

The last step cannot be written as a `match` on the comparison. A `match` in
Bend may not scrutinise the result of a call, so a step that answers one thing
for a new run and nothing for a continuation cannot branch on whether the two
elements are equal. `prelude.bend` supplies the arithmetic that makes the step
branch-free: `P.is_eq(a, b)` is `1n` when the two numbers are equal and `0n`
otherwise, and `P.nsub(a, b)` is `a - b` cut off at zero. The step is then
`P.nsub(1n, P.is_eq(h, h2)) + count_runs(...)` -- one for a boundary, nothing for
a continuation, and no branch at all.

`count_runs_nil` and `count_runs_single` pin the two inputs the step law cannot
reach. The step law below names `a <> (b <> t)`, so it constrains only lists of
two or more elements; without these two, a body that answered the empty list or
the one-element list with something else would satisfy it. Both sides compute in
each, so both are definitional, and each is an absolute anchor: the right-hand
side is the constant the answer must be, and neither names `count_runs` at all.

`count_runs_same` is the law that says a boundary is where the count grows: two
equal neighbours are one run, so putting a copy of the first element in front of
a list does not change the count of the list that starts at that copy. It is
not definitional -- `P.is_eq(a, a)` on a variable does not reduce -- and it is
one of the two laws that need an induction.

`count_runs_diff` is its opposite and is stated with a premise: the two
neighbours differ, and then the run they start is worth exactly one. The premise
is a fact about the prelude's own `P.is_eq`, which is not yours to write, so it
is a real case split rather than a law a body can make vacuous. Together with
`count_runs_same` it fixes the step for every pair of neighbours.

Together the four determine `count_runs` on every input, by induction on the
length: the empty and one-element lists are the first two laws, and a longer
list is `count_runs_same` or `count_runs_diff` applied to its tail, which is
shorter.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.count_runs_nil()`, `def L.count_runs_single(x)`,
`def L.count_runs_same(a, t)` and `def L.count_runs_diff(a, b, t, e)`.
