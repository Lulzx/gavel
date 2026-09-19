Implement `chunks` and its worker `chunks_go` on lists of `Nat`, then prove the
seven laws.

`chunks(xs, n)` must split `xs` into consecutive blocks of `n` elements, in
order, keeping a short final block if the last one is not full. `chunks([1, 2,
3, 4, 5], 2n)` is `[[1, 2], [3, 4], [5]]`, and `chunks([1, 2, 3], 1n)` is
`[[1], [2], [3]]`.

The split cannot be written as "take `n`, recurse on the rest": the rest is
`Nat.sub`- or `drop`-shaped, a computed value, and a recursive call whose
argument is computed is rejected -- the checker accepts a self-call only when
its arguments are unchanged until one of them *shrinks* structurally. The
elements are therefore consumed one at a time and the block being built is
carried along as an accumulator.

`chunks_go(xs, n, k, cur, out)` is that walk. `k` is the number of elements
`cur` still has room for, `cur` is the block being built with its elements in
order, and `out` is the blocks finished so far, in order. An element arriving
with `k` a successor joins `cur` and leaves `k` one smaller; an element
arriving with `k` of `0n` finds `cur` full, so `cur` is closed onto `out` and
the new element opens the next block, which has `n - 1n` room left because the
element itself takes a slot. When the list runs out, whatever is in `cur` is
closed onto `out` -- that is the step that keeps a short final block instead of
dropping it.

`chunks(xs, n)` is the entry point: nothing finished, nothing being built, and
a full block's worth of room. `Nil{}` has nothing to split, and a size of `0n`
cannot form a block, so both answer `Nil{}`.

The size is read twice in `chunks` -- once as the size of the first block and
once as the room left in it after the first element -- so both parameters are
declared reusable: `+n`. Both matches are on `Nat`, and Bend matches its
parameters in order, so the list is matched before the size.

The law `chunks_nil` is the pin on the empty list and `chunks_zero` the pin on
the size `0n` -- the two arms the recursion stops at. `chunks_zero` is an
induction rather than a computation because `chunks` looks at the list first.

`chunks_single` says one element split by a size of one is one block holding
that element. It is the first law whose two sides are values rather than calls,
so it is the first that says where an element *lands*.

`chunks_three_by_two` is the closed one: three elements split by two is one
full block and then a short one. Both sides are literals, so the checker
computes them. A law about how *many* blocks come out -- one, then one shorter
-- is satisfied by a body that puts the first two elements in the wrong order,
or that drops the last block, and this law is not, because both answers are
written out.

`chunks_go_fill` and `chunks_go_close` are the two laws about the worker, and
they are what fixes the recursion generally rather than a handful of sizes: one
of the two arms is taken for every `k`, `1n + k` is a successor so the match
takes the first, and `0n` is the literal so the match takes the second. Both
are definitional.

`chunks_cons` is the one law that says what `chunks` itself does at a size of
two or more, and it is here because the four laws above do not. Every one of
them names a *closed* list -- `Nil{}`, `x <> Nil{}`, and the single literal
`[1, 2, 3]` -- so a body is free at every other list of length two or more, and
free there for a body that agrees at those points. `chunks_single` and
`chunks_three_by_two` are values rather than calls, and agreeing with two values
is not agreeing with a rule. The law writes the entry point's step arm out in
terms of the worker: a cons cell at size `1n + n` opens a block with its first
element and hands the tail to `chunks_go` with the room that element left. Note
the room is `Nat.sub(1n + n, 1n)` and not `n`: `Nat.sub` recurses on its *first*
argument, so that term steps to `Nat.sub(n, 0n)`, which is stuck and does not
reduce to `n`. Write the term the body computes. It is definitional, so `{==}`
closes it.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.chunks_nil(n)`, `def L.chunks_zero(xs)`, `def L.chunks_single(x)`,
`def L.chunks_three_by_two()`, `def L.chunks_cons(x, xs, n)`,
`def L.chunks_go_fill(x, xs, n, k, cur, out)` and
`def L.chunks_go_close(x, xs, n, cur, out)`.
