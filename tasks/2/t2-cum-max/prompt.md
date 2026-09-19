# The running maxima of a list

`cum_max(xs)` is the list of the largest element seen so far at each position, so
it has one entry per element of `xs` and is exactly as long as its input:

    cum_max([3n, 1n, 2n])  ==  [3n, 3n, 3n]
    cum_max([1n, 2n, 3n])  ==  [1n, 2n, 3n]
    cum_max([7n])          ==  [7n]
    cum_max([])            ==  []

The bank's `run_max(xs, m)` is the same running value, but it walks the list from
the *front* and carries the running value as a parameter, with a seed you have to
supply; nothing here has a seed, and the walk runs from the end of the list back
to the front. That is not a reversal of the answer -- `[3n, 3n, 3n]` read
backwards is the same list -- it is a different way of computing it, and the laws
below are about this one.

There are two functions to implement. `max_all(ys, m)` is the raise: every
element of `ys` replaced by the larger of it and `m`, and nothing dropped. It is
what a walk that goes backwards needs, because the only thing a suffix has to
tell the element in front of it is how big it got. `cum_max` is the walk: the
head of a non-empty list is its own running maximum, and the rest of the answer
is the running maxima of the *tail* -- computed first, because the answer runs
from the end back to the front -- raised by the head, so every cell the head
beats is brought up to it and no cell that is already at least the head is
touched. `max_all` recurses on the list and `cum_max` recurses on the tail of the
list, so both shrink the one argument that carries them.

`Nat.max(a, b)` is the larger of two numbers and comes from `Base`. `P.len(xs)`
is the length of a list, and it is what the law about the length of the answer is
stated with.

In `max_all` the number the suffix is raised by is read once per cell, so it is
declared reusable: `+m`. In `cum_max` the head is read twice -- once as the first
entry of the answer and once as the raise -- so it is declared reusable: `+h`.

## The laws, and what each one pins

`max_all_nil` and `cum_max_nil` are the anchors. `max_all_nil` says an empty
suffix has nothing to raise, and `cum_max_nil` says an empty list has no running
maxima, and neither right-hand side calls a target at all. They are the only laws
here that reach `Nil{}` through their own function, so a body that answered
anything else there -- or that was built as `ref(xs) + c` with a constant that
cancels out of every law about a longer list -- is caught by them.

`max_all_cons` and `cum_max_cons` are the two steps, and both are definitional.
`max_all_cons` pins what the raise does to one cell: the cell is replaced by the
larger of itself and the number, and the number does not change as the walk goes.
A body folded with `Nat.min`, or one that skipped the cells the raise cannot
change and so answered a shorter list, fails here. `cum_max_cons` is the only law
that pins the two functions together: the head comes first, and what follows it
is the tail's running maxima raised by the head. A body that walked the other way
-- raising the head by what comes after it, which is the maxima of the *suffixes*
and agrees with this one on every list that only rises -- has a different
unfolding and fails here.

`cum_max_three` is closed: `[3n, 1n, 2n]` has `3n` in its last cell, carried
there from the first, and the `1n` in the middle raises nothing. It is the law
that separate the bodies which agree with the walk on rising lists: the list
itself, the running minima, and the suffix maxima all pass every law above, and
none of them answers `[3n, 3n, 3n]`.

`cum_max_single` is the other end of the same fact: one element is the largest
thing seen so far, whatever it is, so the answer is that element and not `Nil{}`
or `0n`. A body that read the answer as "everything a later element beats" is
separated only here.

`cum_max_len` is the law with content, and it is an induction twice over: the
answer is as long as the input, and the raise does not change a length either.
`cum_max` on a variable list is stuck, so the step has to show that
`max_all(cum_max(t), h)` is as long as `t` -- which needs the hypothesis about the
tail, and a second induction about `max_all` on its own. No law above says
anything about the length of the answer: a body that answered the *distinct*
maxima, one per change, passes the two steps of the walk and is separated here.

## What the policy implements

Two functions, `max_all` and `cum_max`, in `solution.bend`. `LAWS.bend`,
`prelude.bend` and everything under `references/` are immutable.
