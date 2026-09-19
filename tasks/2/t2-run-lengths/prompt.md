# The lengths of the runs

`run_lengths(xs)` is the list of the lengths of the maximal runs of equal
elements of `xs`, in the order the runs appear. A run is maximal when the element
after it differs from it (or there is no element after it), so the answer holds
one cell per run and not one per element, and the cells add up to the length of
the input:

    run_lengths([1n, 1n, 2n])     ==  [2n, 1n]
    run_lengths([1n, 2n, 2n])     ==  [1n, 2n]
    run_lengths([1n, 2n, 1n])     ==  [1n, 1n, 1n]
    run_lengths([7n, 7n, 7n])     ==  [3n]
    run_lengths([3n])             ==  [1n]
    run_lengths([])               ==  []

The bank has neighbours of this function and none of them is this one. The
bank's `run_starts(xs)` is the *positions* at which runs begin; this is their
lengths, so `run_starts([1n, 1n, 2n])` is `[0n, 2n]` while the answer here is
`[2n, 1n]`. The bank's `count_runs(xs)` is how many runs there are -- one number;
this is a list of their lengths. The bank's `run_max(xs, m)` carries a running
value from the front with a seed the caller supplies; nothing here has a seed.
The bank's `longest_run` and `nondesc_run` answer one number, the largest run
length; this answers every run length, so `[1n, 1n, 2n]` gets `[2n, 1n]` and not
`2n`.

There are two functions to implement. `run_lengths` is the answer: an empty list
has no runs, a singleton is one run of one element, and a longer list opens its
first run at `1n` and hands the rest to the walk. `run_lengths_go(cont, cur, h,
t)` is the walk. It reads `t` one element at a time and carries three things: the
length `cur` the run has reached, the element `h` it reached it with, and whether
`h` was in that run at all (`cont`). The head of `t` either joins the run -- the
run grows to `1n + cur` and the walk moves on -- or starts a new one, and then
the run carried so far is emitted and the walk starts again at `1n` with that
element. When `t` runs out, the run carried is emitted: with the last element
counted into it if it was in the run, or after it, as a run of one, if it was
not.

The comparison that decides whether the element in hand joins the run is between
two elements that are both in hand -- the element just read and the next one --
so the step cannot be a `match` on `P.same(h, h2)`: a `match` cannot scrutinise a
value it computed. The decision is therefore made one step early, where the two
elements are visible, and handed to the recursion as the `cont` argument, which
the walk matches on. `cont` is a `Bool`, `True{}` when the element in hand is in
the run and `False{}` when it starts a new one.

`P.same(a, b)` is the prelude's comparison of two `Nat`s: it returns `True{}` or
`False{}` and steps one successor off each side at a time, so with a variable on
either side its answer does not reduce. That is what makes `same(a, a)` an
induction rather than an unfolding, and one of the laws below turns on it.

In the walk, `cur` is read twice on a path that emits the run -- once as its
length and once as the length the next run starts after -- so it is declared
reusable: `+cur`. In `run_lengths` nothing is read twice.

## The laws, and what each one pins

`run_lengths_nil` and `run_lengths_single` are the anchors at the ends of the
answer's own function. Neither right-hand side calls a target at all. The first
is the only law that reaches the empty input through `run_lengths`, so a body
that answered one cell for nothing -- or that was built as `xs` itself -- is
caught there; the second is what separates a body that emits one cell per element
without merging equal neighbours (it answers `[1n, 1n]` for `[1n, 1n]` where this
one answers `[2n]`), and a body that reads the answer as the runs *after* the
first.

`run_lengths_step` is the hand-off between the two targets and the only law that
reaches the walk through the answer: two or more elements open the first run at
`1n`, and the comparison of the two heads is decided before the walk is called. A
body that walked the tail before opening the first run, or that opened it at
`0n`, has a different unfolding here.

`run_lengths_go_last_in_run` and `run_lengths_go_last_alone` are the walk's two
answers at the empty tail, and neither right-hand side calls a target. They are
read at a universally quantified `cur`, so they pin the run's *length* and not
just its presence: a body that emitted the run without the element in hand, or
that dropped the carried run at the end of the list, is separated by exactly one
of them.

`run_lengths_go_grow` and `run_lengths_go_fresh` are the walk's two steps, and
both are definitional: the first grows the run and passes the comparison of the
next pair along, the second emits the run carried and starts again at `1n`. A
body that decided the next comparison between the wrong pair of elements, or that
emitted one cell per element, is separated here.

`run_lengths_go_same` is the law with content: stepping onto an element equal to
the one in hand is the same as continuing with `True{}`, since the walk's
comparison of an element with itself is `True{}`. The two sides are not the same
unfolding -- `P.same(a, a)` does not reduce at a variable `a` -- so the law is
only provable through the reflexivity of the comparison, which is an induction on
`a`. A body that compared the wrong pair, or that treated every element as its
own run, leaves it unconvertible.

`run_lengths_three` is closed: `[1n, 1n, 2n]` is a run of two and a run of one,
so the answer is `[2n, 1n]`. A body that emitted one cell per element, or that
merged the last element into the run before it without asking, satisfies several
of the laws above and is separated here.

## What the policy implements

Two functions, `run_lengths` and `run_lengths_go`, in `solution.bend`.
`LAWS.bend`, `prelude.bend` and everything under `references/` are immutable.
