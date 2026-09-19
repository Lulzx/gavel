# Peaks

`count_peaks(xs)` is how many elements of `xs` are strictly greater than *both*
of the elements next to them:

    count_peaks([1n, 2n, 3n])        ==  0n
    count_peaks([1n, 3n, 2n])        ==  1n
    count_peaks([3n, 1n, 2n])        ==  0n
    count_peaks([1n, 3n, 2n, 5n, 4n]) ==  2n
    count_peaks([2n, 2n, 2n])        ==  0n
    count_peaks([1n, 2n])            ==  0n
    count_peaks([])                  ==  0n

The convention this task states rather than derives is that an element with only
*one* neighbour is not a peak. The first element of a list has nothing to its
left and the last element has nothing to its right, so neither can be counted,
however it compares with the neighbour it does have: `count_peaks([5n, 1n])` is
`0n`, not `1n`. It follows that no list of fewer than three elements has a peak,
and this is also the choice that makes the function a function of *windows* --
three consecutive elements at a time -- rather than of elements plus a special
case at the two ends.

The bank's neighbours of this function and none of them is this one. `max_gap`
and `min_gap` compare *adjacent pairs* and answer a difference; this one compares
each element against two neighbours at once and answers a count. `run_starts`,
`run_ends` and `run_lengths` read neighbours to find where a value *changes*;
this one reads them to find where a value is *larger than both*. `longest_run_len`
answers the length of the longest plateau, which is `0n` on a list this one can
count peaks in, and `1n` on a list this one answers `0n` for. `count_at_depth`,
`count_divisors` and `internal_count` count elements satisfying a predicate on
the element alone; every element this function counts is counted because of the
two elements beside it.

There are two functions to implement. `count_peaks` is the answer: a list of
fewer than three elements answers `0n` without a walk, and a longer list spends
its first two elements on establishing the first window and hands the rest to
the walk. `peaks_go(t, prev, h)` is the walk: `t` is what is left to read,
`prev` and `h` are the two elements already behind the one being decided, and
the element at the front of `t` is that element's second neighbour. So the
element in hand is decided by `P.peak_at(prev, h, j)` -- `1n` when `h` beats both
of its neighbours, `0n` otherwise -- and then the walk continues with `h` and `j`
as the next two. `P.peak_at` and the comparison under it are in the prelude and
are immutable. The walk recurses on the tail of the list it matched, so the list
is the argument that shrinks and it comes first. `h` is read twice on the step
-- once into the indicator for the element in hand and once as a neighbour of the
element after it -- so it is declared reusable (`+h`), and so is the element the
match takes off the front of `t`, which is read twice for the same reason.

## The laws, and what each one pins

`count_peaks_nil` and `count_peaks_single` are the anchors at the short end of
the answer. The first's right-hand side calls no target at all. The second fixes
a one-element list at `0n` for *every* element, which is the stated convention:
its right-hand side also calls no target, so a body that read a lone element as
trivially greater than both of the neighbours it does not have is separated
there and nowhere else.

`count_peaks_step` is the hand-off from the answer to the walk, and the only law
that reaches `peaks_go` *through* `count_peaks`. A body that answered a long
list without a walk, or that opened the walk with the wrong two elements behind
it -- the wrong element first, say, so that every window is shifted by one --
has a different unfolding here.

`peaks_go_nil` fixes the walk's answer when the list runs out, whatever the two
elements it was carrying are; its right-hand side calls no target. It is also
the law that says the *last* element is never counted: the walk reaches this
case holding the last element, and answers `0n` rather than deciding it against
the one neighbour it has.

`peaks_go_cons` is the walk's step, and the law that says what the walk is
measuring. The element at the front of the remaining list is the second
neighbour of the element in hand, so the indicator for the element in hand is
`P.peak_at(prev, h, j)`, and the rest of the count is the same walk over the
tail with the window moved one along. A body that compared the element in hand
against only one neighbour, or that carried the window forward without dropping
the element that has just been decided, or that summed the two halves the other
way round, has a different unfolding here.

`count_peaks_three` is content, at the shortest list where every element has as
many neighbours as it is going to get. The first and last elements contribute
nothing and the middle one contributes `P.peak_at(x, y, z)`, so the law states
the answer of *any* three-element list in one equation. A body that counted the
first element, or the last, or that took two consecutive equal elements for a
peak, is separated here.

## What the policy implements

Two functions, `count_peaks` and `peaks_go`, in `solution.bend`. `LAWS.bend`,
`prelude.bend` and everything under `references/` are immutable.
