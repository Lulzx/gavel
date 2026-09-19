# Zip to the longer list

`zip_longest(xs, ys, d)` pairs the two lists up element by element and runs to
the end of the longer one. Where a list has run out, `d` stands in for the
element it no longer has:

    zip_longest([1, 2], [10, 20], 9)  ==  [(1, 10), (2, 20)]
    zip_longest([1, 2], [10], 9)      ==  [(1, 10), (2, 9)]
    zip_longest([1], [10, 20], 9)     ==  [(1, 10), (9, 20)]

The padding value goes in the component belonging to the list that stopped: if
the first list ran out, `d` is the first half of the extra pairs; if the second
ran out, it is the second half.

There are three functions to implement. `zip_longest` is the answer. `zl_pad_left`
and `zl_pad_right` are the two ends of it, for when one list has run out and the
other has not.

`zl_pad_left(ys, d)` walks `ys` and emits `(d, y)` for each element. `zl_pad_right(xs, d)`
walks `xs` and emits `(x, d)`. Both answer the empty list when there is nothing
left to pad.

`zip_longest` steps on the first list and then on the second. While both have
elements the two heads are packed together and the walk continues on both tails.
When the first runs out, the second is padded on its left; when the second runs
out, the first is padded on its right.

One thing about the shape is forced by the checker rather than chosen. A
recursive call is only accepted when the argument the function matches on is the
one that shrinks, and every argument before it is passed unchanged. `zip_longest`
matches on its first list, so a self-call on `(Nil{}, t, d)` would shrink the
*second* argument while the first stayed put -- which is not accepted. Splitting
the padding into two functions is what keeps every self-call shrinking the list
its own function matches on. For the same reason `zl_pad_left` and `zl_pad_right`
are two functions and not one with a flag: each matches on its own list and
recurses on that list's tail.

## The laws, and what each one pins

`zl_pad_left_nil` and `zl_pad_right_nil` are the two walks' stopped answers. Both
are definitional and both have a right-hand side that calls no target, so both
are absolute anchors. They stop a body from emitting a phantom pair when there
is nothing left to pad.

`zl_pad_left_cons` and `zl_pad_right_cons` are the two walks' steps, and they are
definitional. They are stated separately because the pair components are the
other way round in each, and this is what says so: read together they pin which
side the padding value lands on, so a body that padded both ends the same way is
separated by the pair of them.

`zip_longest_nil_nil` is the pin on the answer when both lists are already
empty, before the second list is looked at. It is definitional, its left side is
ground in both lists, and its right side calls no target.

`zip_longest_cons_cons` is the step while both lists have elements, and it is
definitional. It says which element goes in which component and that the walk
continues on both tails -- a body that swapped the components, or that recursed
on one tail twice, has a different unfolding here.

`zip_longest_nil_cons` and `zip_longest_cons_nil` are the two hand-offs from the
answer to the padding walks, and they are the laws that say the answer keeps
going when one list ends: an ordinary zip, which stops at the shorter list,
answers the empty list on the right of the first of them. They are also what
says the padding walks are handed the *other* list -- a body that padded the
wrong side names the wrong walk.

`zip_longest_equal_lengths`, `zip_longest_pads_the_right` and
`zip_longest_pads_the_left` are the closed values, and none of their right-hand
sides calls a target, so all three are absolute anchors. The first says nothing
is padded when the lists end together, and the other two pin the direction of
the padding and that the tail keeps its order -- the only laws here that look at
a whole output list from the outside rather than one pair at a time.

## What the policy implements

Three functions, `zl_pad_left`, `zl_pad_right` and `zip_longest`, in
`solution.bend`. `LAWS.bend`, `prelude.bend` and everything under `references/`
are immutable.
