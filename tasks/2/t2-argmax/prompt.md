Implement `argmax` and its walk `argmax_go`, then prove all seven laws.

`argmax(xs)` is the position of the largest element of `xs`, counting from `0n`
-- and on a tie, the *first* position at which the largest element occurs:

    argmax([1n, 3n, 2n])      ==  1n
    argmax([2n, 3n, 3n, 1n])  ==  1n
    argmax([7n])              ==  0n

The list is never empty when `argmax` is called; the empty list answers `0n`
anyway. `argmax` is one step: a cons cell hands its tail to `argmax_go` with the
head as the largest element seen so far and `0n` as its position.

`argmax_go(xs, cur, bi, i)` walks `xs` carrying three things: `cur`, the largest
element seen so far; `bi`, the position in the whole list of that element; and
`i`, the position of the element it is about to look at. The empty list answers
`bi` -- everything has been seen. A cons cell folds its head in and recurses on
the tail: the new largest is `P.max2(h, cur)`, and the new position is `i` when
the head is *strictly* greater than `cur` and `bi` when it is not. That strict
comparison is what keeps the first of equal elements: a tie must leave the
position where it is. The list is the argument that shrinks, and in Bend the
shrinking argument has to come before the arguments that are only read, so the
list comes first. `cur`, `i` and the head are each read twice in the step, so
they are declared reusably (`+cur`, `+i`, `+h`).

The comparison is the prelude's `P.gt` and the decision is taken by `P.pick_if`,
which matches on the value it is handed. A match cannot scrutinise a computed
value where it is written, so the comparison is passed to `P.pick_if` rather
than matched on in place. The prelude also has `P.max2`, the larger of two
numbers, and `P.same`, the list of `n` copies of an element, which only the last
law is stated over.

`argmax_nil` pins the empty input. It is the only law whose left-hand side is a
closed list, and it fixes the answer there, which the cons law below never
reaches.

`argmax_cons` is definitional: a cons cell hands the tail, the head, `0n` and
`1n` to the walk. It is the law that says `argmax` starts the walk at the head
rather than at a constant or at the last element.

`argmax_go_nil` is the walk's empty case: the position of the largest element
seen, not the position counter. With the step law below it fixes which of the
walk's running values is the answer.

`argmax_go_step` is the law with the content: the head is folded into both
running values and the walk recurses on the tail, taking the position on a
strict win only. It is stated at variables `cur`, `bi` and `i`, so it holds at
every state the walk can be started from.

`argmax_three` is one closed list, `[1n, 3n, 2n]`, whose largest element sits at
`1n` -- neither where the walk starts nor where it ends.

`argmax_tie` is a closed list with a tie in it, `[2n, 3n, 3n, 1n]`. The largest
element is `3n`, at `1n` and at `2n`, and the answer is `1n`. `argmax_three` has
no tie, so it cannot separate a body that moved the position every time the head
reached the largest seen so far; this law can.

`argmax_same` is the induction, stated over the walk rather than over `argmax`:
a walk over a list of `n` equal elements, from a state whose largest element
seen so far is that element, answers the position it started from -- whatever
the counter reads and however long the list is -- because every element ties
with the largest seen so far and the position never moves. Its state is
universally quantified. A body that took the new position on a tie answers the
last index here, and a body that answered the position counter at the empty
list answers the last index too.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.argmax_nil()`, `def L.argmax_cons(h, t)`, `def L.argmax_go_nil(cur, bi,
i)`, `def L.argmax_go_step(h, t, cur, bi, i)`, `def L.argmax_three()`, `def
L.argmax_tie()` and `def L.argmax_same(n, k, bi, i)`. Any lemma you need about
the prelude's own functions goes under the reserved `Policy.*` namespace, as
`def Policy.<name>(...)`, so that it is not taken for a law.

Two things about proof defs that a law about the walk runs into. A proof def's
parameters are good for one live use each, so an argument cited several times
over the steps is rebound reusable first (`+r = k`) and the steps cite that. And
`%e : { ... _ ... }` rewrites the hole, which must sit where the right-hand side
of the equation `e` proves occurs; the body under it then sees the equation's
left-hand side there. That is why a step that folds a term *back* to its
left-hand side passes `Equal.sym` of the lemma rather than the lemma.
