Implement `replace_at` on a list of `Nat`, then prove all four laws.

`replace_at(n, xs, y)` puts `y` at position `n` of `xs`, counting from `0n`, and
leaves the length alone:

    replace_at(1n, [3n, 1n, 2n], 9n)  ==  [3n, 9n, 2n]
    replace_at(3n, [3n, 1n, 2n], 9n)  ==  [3n, 1n, 2n]

The second of those is the out-of-range answer: a count past the last position
has no element to stand in place of, so `xs` comes back unchanged. That is not
the same answer as "replace nothing and drop the tail" -- the whole list is
preserved, which is what makes `replace_at` a setter rather than a resizer, and
it is why the empty list is the answer at the bottom of the recursion.

Recurse on the count. `0n` drops the head and puts `y` in its place; `1n + p`
keeps the head it passed and recurses on the element behind it. The count is the
argument that shrinks and it comes first, so the list may change at every step
(`t`, its own tail) and the value may too. `replace_at(n, xs, y)` is accepted as
written; a body that recursed on the whole list rather than on its tail is not.

The prelude adds nothing: the laws speak in `List<Nat>` terms only, and
`replace_at` needs no helper.

`replace_at_nil` fixes the answer on an empty list at any count. Its left-hand
side is a ground term in the list, and its right-hand side mentions no target at
all -- it is the absolute anchor, and it is the law that catches a body whose
count ran out by answering a one-element list instead of nothing.

`replace_at_zero` is the answer at position `0n`: the head is dropped and `y`
takes its place. The count is a literal there, so the match inside `replace_at`
steps and answers without recursing, and the successor law below, stated at
`1n + n`, never reaches this answer. A body whose `0n` case conses `y` in front
instead of replacing answers `y <> h <> t` here.

`replace_at_succ` is the step, and it is the law that makes the count mean a
position rather than a number of steps: the head survives and the recursion goes
to the element behind it.

`replace_at_idem` is the one law here that is not definitional, and it is the
law with content. Replacing the element at position `n` twice is the same as
replacing it once, with the second value: the second application must land on
the value the first wrote, and nowhere else. It is inductive in the count, with
a split on the list in each case, and its proof is the hypothesis at the
predecessor and the tail.

Together the laws determine the body: the empty list is fixed, the `0n` answer
is fixed, and the successor law fixes what a cons cell becomes, so the recursion
is pinned at every count. The three "look at it" laws are definitional and
proved with a bare `{==}`; only `replace_at_idem` needs an induction.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.replace_at_nil(n, y)`, `def L.replace_at_zero(h, t, y)`,
`def L.replace_at_succ(n, h, t, y)` and `def L.replace_at_idem(n, xs, y, z)`.
