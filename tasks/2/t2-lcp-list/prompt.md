# The longest common prefix

`lcp_list(xs, ys)` is the longest common prefix of `xs` and `ys`, as a *list*:
the leading elements the two lists have in common, stopping at the first
position where they differ or at the end of whichever list runs out first.

    lcp_list([1n, 2n, 3n], [1n, 2n, 4n])  ==  [1n, 2n]
    lcp_list([1n, 2n], [1n, 2n])          ==  [1n, 2n]
    lcp_list([1n, 2n], [1n, 2n, 3n])      ==  [1n, 2n]
    lcp_list([1n], [2n])                  ==  []
    lcp_list([], [1n])                    ==  []
    lcp_list([], [])                      ==  []

Two conventions are stated here rather than derived. The prefix is a *prefix*:
the element the lists disagree at is not in the answer, and neither is the
element the longer list has over the shorter one. And the answer stops where the
two lists stop agreeing, so `lcp_list(xs, xs)` is the whole of `xs` -- there is
no position at which a list disagrees with itself.

The bank's neighbours of this function and none of them is this one.
`lcp_len` answers the *length* of this prefix as a `Nat`; this one answers the
prefix itself, and a body that counted the agreeing positions without keeping
the elements satisfies every law about a count and none of the laws here.
`is_prefix` decides whether one list is a prefix of another; this one answers
the longest one two lists share, so `is_prefix` reads a `Bool` off a pair of
lists while this one reads a list off a pair of lists. `prefixes(xs)` answers
*every* prefix of one list; this one answers exactly one, of two.
`max_prefix` and `max_prefix_sum` fold over the prefixes of a single list.
`dedup`, `run_starts` and `run_lengths` read *neighbouring* elements of one
list; this one reads two lists position by position.

There is one function to implement. `lcp_list(xs, ys)` walks both lists at once:
the empty list on either side ends the walk at `Nil{}`, and two cons cells keep
their element and go on when the two heads agree, and answer `Nil{}` when they
do not. The walk is on `xs` first, so the first list is the argument that
shrinks and it comes first; the second list shrinks with it. The element in hand
is read twice -- once into the comparison and once into the answer -- so it is
declared reusable.

`P.is_eq(a, b)` and `P.gate_list(c, xs)` are in the prelude and are immutable.
`P.is_eq` is `1n` when two elements are equal and `0n` otherwise. The branch
that the comparison decides has to be taken by a function rather than by a
`match`, because the answer of a comparison is not a term a `match` may
scrutinise; `P.gate_list(c, xs)` is `xs` when `c` is non-zero and `Nil{}` when
it is zero, so the two outcomes are handed to it together and it returns one of
them.

## The laws, and what each one pins

`lcp_list_nil_left` and `lcp_list_nil_right` are the two anchors, and they are
not the same law: the walk looks at the first list first, so the second one is
the branch that says a list running out on the right ends the prefix too, and
it is the one that has to be inductive in `xs`. Both right-hand sides call no
target.

`lcp_list_cons_heads` is the step, and the law that says a matching pair is
*kept* rather than passed over: the answer is the element in hand in front of
the prefix of the tails, when the comparison says the two heads agree, and the
empty list when it does not. The two heads are separately quantified -- the law
holds whether or not they are equal -- so the comparison's own two arguments are
pinned here: a body that asked whether the second head equals the first is a
different term, and a body that answered the prefix of the tails alone, or that
dropped the cell and counted what was left, has a different unfolding.

`lcp_list_self` is content, and the one law with no second list: the longest
common prefix of a list with itself is the whole list. That fixes the *tail* of
the answer at every length -- the first and last elements included -- which no
law about a mismatch can, and it is what separates a body that stopped one
position early or that treated the end of a list as a special case.

`lcp_list_stops_at_a_mismatch` and `lcp_list_shorter_runs_out` are closed, and
their left-hand sides are ground terms. The first has the two lists agreeing
twice and differing at the third position, so the answer is what they share and
not what they disagree at; the second has one list running out before the other,
so the answer is the whole of the shorter one and not the whole of the longer.
Between them they separate a body that never stops at a mismatch, a body that
keeps the element it disagreed at, and a body that stops one position short of
the end of the shorter list.

## What the policy implements

One function, `lcp_list`, in `solution.bend`. `LAWS.bend`, `prelude.bend` and
everything under `references/` are immutable.
