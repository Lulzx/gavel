# Every `n`th element

`take_every_nth(n, xs)` is the elements of `xs` at the positions `0n`, `n`,
`2n`, ... and nothing else -- every `n`th element, counting from the first:

    take_every_nth(2n, [1n, 2n, 3n, 4n, 5n])  ==  [1n, 3n, 5n]
    take_every_nth(3n, [1n, 2n, 3n, 4n, 5n, 6n, 7n])  ==  [1n, 4n, 7n]
    take_every_nth(1n, [1n, 2n, 3n])  ==  [1n, 2n, 3n]
    take_every_nth(0n, [1n, 2n, 3n])  ==  []
    take_every_nth(2n, [])            ==  []

The stride `0n` is the convention this task states rather than derives: it names
no position at all, so nothing is kept. The alternative reading -- keep the head
and then look for "every `0n`th" element again -- never finishes, because the
gap never grows and the recursion never reaches a shorter list. `0n` is therefore
answered with the empty list, and it is the one input the walk below is never
started on.

The bank's neighbours of this function and none of them is this one. `dedup`,
`run_starts` and `run_lengths` all read *neighbouring* elements and this one
reads every `n`th; `windows` answers consecutive *blocks* of a fixed length and
this one answers single elements a stride apart; `split` (the bank's
even-positions-and-odd-positions task) is the two halves at the fixed stride
`2n`, while this is one of those halves -- a single list, not a pair -- at a
stride the caller supplies. `indexed` packs every element with its position;
this one keeps the elements at every `n`th position and drops the rest.

There are two functions to implement. `take_every_nth` is the answer: a stride
of `0n` answers `Nil{}`, and a positive stride is one plus the number of
elements to *skip*, which is what the walk is handed. `every_nth_go(xs, m, i)`
is the walk, and `m` is the number of elements between two kept ones -- the
stride minus one -- while `i` is the number of skips still owed. The element in
hand is kept when `i` is `0n`, and then the next gap starts over at `m`; it is
passed over when `i` is a successor, and then the debt goes down by one. The
walk recurses on the tail of the list it matched, so the list is the argument
that shrinks and it comes first. `m` is read twice on the keeping step -- once
as the count just paid off and once as the count the next gap starts from -- so
it is declared reusable (`+m`), and so is the tail, which the two sides of the
inner match each read once.

## The laws, and what each one pins

`take_every_nth_zero` and `take_every_nth_nil` are the anchors at the two ends
of the answer. The first's right-hand side calls no target at all, and it is the
only law that reaches `take_every_nth` with a count the match stops on: a body
that read `0n` as "keep everything" is separated there and nowhere else. The
second fixes the empty list at every stride, and it is the law a body that
started its answer with a kept element regardless of the input fails.

`take_every_nth_one` is the other anchor, and the law that says the walk starts
at the *first* element: a body that kept the positions `1n`, `1n + n`, ... --
one whole stride late -- answers the tail of a cons cell where this one answers
the cell, at every input. Its right-hand side is the input itself, so no target
is named there.

`take_every_nth_step` is the hand-off from the answer to the walk, and the only
law that reaches `every_nth_go` *through* `take_every_nth`: a positive stride is
one plus the skip count, and the walk opens on the whole list with nothing owed.
A body that opened the walk at the wrong skip count, or that never opened it,
has a different unfolding here.

`every_nth_go_nil` fixes the walk's answer when the list runs out, whatever the
skip count and the debt are; its right-hand side calls no target. The other two
`every_nth_go_*` laws write the walk's two steps out, and both sides compute in
each, so both are definitional. `every_nth_go_take` is where the reset is
stated: the gap after a kept element starts at `m`, not at `0n`, so a body that
restarted at `0n` keeps every element from there on. `every_nth_go_skip` is
where the countdown is stated: the element in hand is dropped and the debt goes
down by exactly one, so a body that jumped a fixed distance, or that dropped a
different element, has a different unfolding.

`take_every_nth_five` and `take_every_nth_seven` are closed: one closed list
read end to end at a stride that divides the length, and one at a stride that
does not, so the last gap is left unfinished. Between them they separate a body
that kept one element per stride but the wrong ones, a body that padded the
answer to a whole number of strides, and a body that stopped one element early.

## What the policy implements

Two functions, `take_every_nth` and `every_nth_go`, in `solution.bend`.
`LAWS.bend`, `prelude.bend` and everything under `references/` are immutable.
