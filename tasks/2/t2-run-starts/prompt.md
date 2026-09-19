Implement `run_starts` and its walk `run_starts_go` on lists of `Nat`, then
prove the six laws about them.

`run_starts(xs)` is the list of positions at which a new run of equal elements
begins, in increasing order. A run begins at position `i` when `xs[i]` differs
from the element before it -- and position `0n` always begins one when `xs` is
non-empty, because there is no element before it for it to equal. So
`[1n, 1n, 2n]` opens at `0n` and at `2n`, not at `1n`, and `[5n]` opens only at
`0n`. The answer is a `List<&2, Nat>` of positions, not a count and not the
elements themselves.

Both lists are `List<&2, Nat>`, which is `Data`, so a binder may be declared
reusable. The prelude is immutable and carries the two things the step and the
laws are stated in: `P.same(a, b)` is `True{}` exactly when the two numbers are
equal, and it matches on both arguments at once, so on a pair of variables it is
stuck. `P.put_start(i, r, k)` is `r` when `k` is `True{}` and `i <> r` when it is
`False{}` -- the walk's step with its decision exposed as an argument, because a
`match` cannot scrutinise a computed value in Bend and the step has to answer two
different ways on `P.same(h, prev)`.

`run_starts_go(rest, prev, i)` walks `rest` carrying `prev`, the element before
it, and `i`, the position its head sits at. The empty list answers `Nil{}`. A
cons cell compares its head with `prev` and hands the answer to `P.put_start`
together with `i`: the position opens a run when the answer is `False{}` and is
passed over when it is `True{}`. Either way the walk recurses on the tail at
`1n + i` with the head as the element before it. `i` and the head are each read
twice in that step, so both are declared reusable: `+i` and `+h`.

`run_starts(xs)` is `Nil{}` on the empty list, and otherwise `0n` in front of the
walk on the tail, started at `1n` with the first element as the element before
it.

`run_starts_nil` and `run_starts_single` are the absolute anchors -- their
right-hand sides call no target -- and `run_starts_single` is the law that
separates a body which decides the first position by comparing the head against
an initial value. `run_starts_go_nil` anchors the walk. `run_starts_go_cons`
writes the step out, with the position and the element before it universally
quantified.

`run_starts_go_same` is the law with content: an element equal to the one before
it continues its run, so the walk opens nothing at its head and the answer is the
walk on the tail one position along. At a variable `a` the decision `P.same(a, a)`
does not reduce, so this cannot be closed by unfolding -- it needs the fact that a
number is the same as itself. `run_starts_three` is closed: it fixes what the
walk comes to on `[1n, 1n, 2n]`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.run_starts_nil()`, `def L.run_starts_single(x)`,
`def L.run_starts_go_nil(prev, i)`, `def L.run_starts_go_cons(h, t, prev, i)`,
`def L.run_starts_go_same(t, a, i)` and `def L.run_starts_three()`. Helpers go
under the reserved `Policy.` namespace, which the gate ignores, and none of them
may cite a law.
