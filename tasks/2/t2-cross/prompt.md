# The product of two lists

`cross(xs, ys)` is every element of `xs` paired with every element of `ys`:

    cross([1n, 2n], [3n, 4n])  ==  [MkPair{1n, 3n}, MkPair{1n, 4n},
                                    MkPair{2n, 3n}, MkPair{2n, 4n}]
    cross([1n], [2n, 3n])      ==  [MkPair{1n, 2n}, MkPair{1n, 3n}]
    cross([1n, 2n], [])        ==  []
    cross([], [1n, 2n])        ==  []

There are two orderings to state, and this task states them rather than derives
them. The rows come in the order `xs` has them -- the whole row for the first
element, then the whole row for the second -- and inside a row the cells come in
the order `ys` has them. So the answer reads left to right, top to bottom, like
a multiplication table written out row by row. The answer has exactly
`|xs| * |ys|` cells, and it is the empty list as soon as either input is.

The bank's neighbours of this function and none of them is this one. `zip_with`,
`zip_with_const` and `zip3` walk two or three lists *together*, so their answer
is as long as the shorter input and each cell pairs the elements at one
position; this one is as long as the *product* of the two lengths and pairs
across every position. `pairs` packs *neighbouring* elements of a single list,
`chunk_two` cuts a single list into blocks, and `pairs` again is the pairwise
neighbour relation rather than a product -- all three take one list, and this
one takes two and answers a two-dimensional shape flattened. `concat_map` /
`concat` flattens a list of lists that already exists; this one builds the list
of lists first, and the interesting part is that its rows share `ys`.
`dot` multiplies the cells of a zip and adds them; this one does not look at the
values at all, only at how many cells there are and which element goes with
which.

There are two functions to implement. `row(x, ys)` is one row of the product:
`x` paired with every element of `ys`, in order. `cross(xs, ys)` is the whole
thing: on an empty `xs` there are no rows, and on a cons the row for the front
element is concatenated with the product of the tail. `P.append` and the `Pair`
type are in the prelude and are immutable -- `append` because `Base`'s `List` is
monomorphic and the answer's elements are pairs, not `Nat`s, so the walk cannot
concatenate `Nat` lists. `row` recurses on `ys` and `cross` recurses on `xs`, so
in each the list is the argument that shrinks and it comes first. `x` is read
twice in `row` -- once into the cell and once as the element the rest of the row
is about -- and in `cross` the front element is read by the row while the whole
of `ys` is read by every row, so those binders are declared reusable.

## The laws, and what each one pins

`cross_nil` and `row_nil` are the anchors, one at each function's empty case.
Both right-hand sides call no target at all, so the two short inputs are pinned
absolutely: a body that answered an empty product with a cell, or that padded
it, is separated there and nowhere else.

`row_cons` is the row's step and the law that says what a row is. The front of
`ys` is paired with `x` and put in front of the row for the rest, so the pairs
come out in `ys`'s order. A body that built `MkPair{y, x}` -- the transposed
pair -- has the right length and the wrong cells here, and a body that built the
row in reverse has the same cells in a different order.

`cross_cons` is the product's step, and the only law whose left-hand side
reaches `row` through `cross`. It is what says the rows are in `xs`'s order and
that every row sees the whole of `ys`: the row for the front element comes
first, the product of the tail comes after, and a body that swapped those two,
dropped the row, or walked only the zipped prefix of the two lists has a
different unfolding here.

`cross_one` is content at a list of exactly one row. The product of a one-row
`xs` is that row and nothing else -- not the row with an empty row after it, and
not the row concatenated with anything. The two sides are the same list because
concatenating nothing on the right changes nothing, which is a property of
`P.append` rather than of `cross`, so the law is a statement about the answer's
*tail* rather than about its cells.

`cross_two_two` is the one closed law, and the one whose left-hand side is a
ground term: every cell of a two-by-two product is written out. Because every
element is a literal, it separates bodies that the general laws above would also
separate, and it is here as the absolute anchor -- the product of these two lists
is *this* list, cell for cell, in this order.

## What the policy implements

Two functions, `row` and `cross`, in `solution.bend`. `LAWS.bend`,
`prelude.bend` and everything under `references/` are immutable.
