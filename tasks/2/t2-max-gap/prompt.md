# The largest gap between neighbours

`max_gap(xs)` is the largest distance between two elements that are next to each
other in `xs`, and `0n` when there are fewer than two elements to be next to
each other:

    max_gap([3n, 1n, 5n, 2n])  ==  3n        -- the gaps are 2n, 4n and 3n
    max_gap([7n])              ==  0n
    max_gap([1n, 9n, 2n])      ==  8n        -- 8n beats 7n

The distance is absolute: it does not matter whether the list goes up or down,
so `max_gap([1n, 9n])` and `max_gap([9n, 1n])` are both `8n`. Two functions in
the bank are close and are not this one. `diffs(xs)` answers the *list* of
adjacent differences, so its length is the number of gaps and this task's answer
is the largest of them; `run_max` and the running maxima keep every prefix
maximum rather than folding the walk down to one number.

The list is the argument the recursion shrinks, so it is the first parameter, and
there are two of them to implement. `gap_go(xs, prev, best)` is the walk: it
carries the element before the current window (`prev`) and the largest distance
it has seen (`best`), and answers `best` when the list runs out. `max_gap` only
opens the walk on a list of two or more elements, with the first element as the
element before the window and `0n` as the largest seen so far.

The prelude hands you the vocabulary:

- `P.absdiff(a, b) -> Nat` is the distance between two numbers. It steps one
  successor off each side at once, so on two variables it is stuck.
- `Nat.max(a, b)` is the larger of two numbers, and `Nat` comes from `Base` with
  the rest.

The walk's head is read twice -- once for the distance and once as the element
before the next window -- so it is declared reusable: `+h`. Nothing is built up:
the maximum is folded in as the walk goes, so no list of differences is ever
constructed. That is what makes the law about a run of equal elements an
induction rather than a computation.

## The laws, and what each one pins

`max_gap_nil` is the anchor: `Nil{}` in, `0n` out, one side computing without
calling either target. It is the only law here whose right-hand side calls
neither `max_gap` nor `gap_go`.

`max_gap_single` is the other end of the same fact: one element has no
*neighbour*, so the answer is `0n` and not the element itself. A body that
started the largest-seen-so-far at the first element, or that answered the
largest element when there is no pair at all, passes every law about longer
lists and is separated here. `max_gap_cons` is the opening step: a list of two
or more hands the walk its tail, the element before that tail's first window --
the head -- and `0n`.

`gap_go_nil` and `gap_go_cons` are the walk, and they are the pair the value
laws are stated over. The empty case answers what it was carrying, whatever that
is and whatever came before it; the step measures the head against the element
before the window, folds the distance and the largest-so-far with `Nat.max`, and
walks on with the head. A body folded with `Nat.min`, or one that kept only the
distance of the window it is looking at, fails the step.

`gap_go_same` is the law with content, and it is an induction. Over a run of
equal elements every window has distance `0n`, so the walk answers exactly what
it was carrying -- but `gap_go` is stuck on `P.same(n, k)` at a variable `n`, and
`P.absdiff(k, k)` does not reduce on a variable either, so neither side is a
computation. This is what says the answer is a *largest* rather than a count of
windows: a body that added the distances up would grow with the run and keep
every law above.

`max_gap_three` is closed: `[1n, 9n, 2n]` has gaps `8n` and `7n`, and the answer
is the larger. A body that answered the last distance, or the smallest, satisfies
every law above and is separated here.

## What the policy implements

Two functions, `gap_go` and `max_gap`, in `solution.bend`. `LAWS.bend`,
`prelude.bend` and everything under `references/` are immutable.
