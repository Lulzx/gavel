# Sums of successive elements

`sum_adjacent(xs)` is a list one element shorter than `xs`, whose entries are
the sum of the first and second elements of `xs`, then of the second and third,
and so on:

    sum_adjacent([1n, 2n, 3n])        ==  [3n, 5n]
    sum_adjacent([3n, 1n, 4n, 1n])    ==  [4n, 5n, 5n]
    sum_adjacent([2n, 2n])            ==  [4n]
    sum_adjacent([1n])                ==  []
    sum_adjacent([])                  ==  []

Two conventions are stated here rather than derived. A list of fewer than two
elements has no successive pair, so it answers the empty list: `sum_adjacent` of
a one-element list does not answer the element itself, and does not pair it with
anything. And the `i`th entry of the answer is the sum of the `i`th and `i+1`th
entries of the input for every `i` the answer has an entry for, so the answer is
exactly `|xs| - 1` long -- one element, not two, is the input's contribution to
each sum.

The bank's neighbours of this function and none of them is this one. `diffs` is
the same walk with truncated subtraction in place of the sum, so its answer is
`0n` wherever the input falls and its law set needs a lemma about a subtraction
with a variable on the left; every sum here is a `Nat` addition and the answer
is monotone in its inputs, which is a different function and different laws.
`windows` answers consecutive *blocks* of a fixed length, so its answer is a
list of lists and the blocks share elements; this one answers single elements
and its entries are new values, each computed from two neighbours.
`longest_run_len`, `run_starts` and `run_lengths` read neighbouring elements
without adding them; `dot`, `sum_pair` and `zip_sum` add elements of two lists
position by position; `sum_prefix` adds everything up to a position. `pairs`
packs neighbouring elements into pairs and answers the pairs themselves, where
this one answers the value each pair comes to.

There is one function to implement. `sum_adjacent(xs)` walks the list: the empty
list answers `Nil{}`, and so does a one-element list; from two elements on, the
answer is the sum of the first two in front of the sums of everything from the
*second* element on. The walk recurses on the tail of the list it matched, so
the list is the argument that shrinks and it comes first. The element after the
front one is read twice -- once as the second half of the pair just added and
once as the first half of the next pair -- so it is declared reusable, and so is
the tail it is taken from, which both the pair and the recursive call read.

## The laws, and what each one pins

`sum_adjacent_nil` and `sum_adjacent_single` are the anchors, and they are the
two inputs the step law cannot reach: it names only lists of two or more
elements. Both right-hand sides call no target. The first is the one law whose
left-hand side is a ground term and whose answer is not read off another; the
second is what separates a body that read the first element as a pair with
nothing -- or that answered the input's head when there is no pair at all.

`sum_adjacent_cons` is the step, and the law that says which sums come out and
where the recursion restarts: the answer starts with the sum of the first two
elements and continues with the sums of everything from the *second* element on.
A body that recursed from the third element would drop a sum; one that summed
the wrong neighbours, or that kept a cell of the input as well as its sums, has
a different unfolding here.

`sum_adjacent_pair` is content at the shortest input that has a pair, with both
elements variables: the answer is exactly the one sum, and nothing follows it.
That pins the answer's tail where no closed law can, because the values are not
known.

`sum_adjacent_len` is the count half, and the law that is not definitional:
`sum_adjacent` is stuck on a variable front element and a variable tail, so the
induction is the proof. It says the answer is exactly one element shorter than
the input, which separates a body that answered one sum too many. Its binders
name the list before the element the walk puts in front of it, because the
hypothesis is applied to the list's tail and the checker asks the shrinking
argument to come first.

`sum_adjacent_three` is the closed law, and its left-hand side is a ground term:
three elements in, two sums out, in the order the pairs come in.

## What the policy implements

One function, `sum_adjacent`, in `solution.bend`. `LAWS.bend`, `prelude.bend`
and everything under `references/` are immutable.
