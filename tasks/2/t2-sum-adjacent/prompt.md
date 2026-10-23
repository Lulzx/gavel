Implement `sum_adjacent`, then prove the six laws in `LAWS.bend`.

`sum_adjacent(xs)` is the list of sums of successive pairs of `xs`: the first
element plus the second, then the second plus the third, and so on. Its `i`th
entry is the sum of the `i`th and `i+1`th entries of `xs`, so the answer has one
element fewer than `xs`. A list with fewer than two elements has no pair and
gives the empty list; in particular a one-element list gives `Nil{}`, not the
element.

    sum_adjacent([1n, 2n, 3n]) == [3n, 5n]
    sum_adjacent([3n, 1n, 4n, 1n]) == [4n, 5n, 5n]
    sum_adjacent([2n, 2n]) == [4n]
    sum_adjacent([1n]) == Nil{}

The laws use the prelude's `P.len(xs)`, the number of elements of `xs`.

- `sum_adjacent_nil`: the empty list gives the empty list.
- `sum_adjacent_single`: a one-element list gives the empty list.
- `sum_adjacent_cons`: for a list `h <> (k <> u)` of at least two elements, the
  answer is `h + k` followed by the answer for `k <> u`.
- `sum_adjacent_pair`: a two-element list `x <> (y <> Nil{})` gives the
  one-element list holding `x + y`.
- `sum_adjacent_len`: the answer for `x <> xs` has as many elements as `xs`.
- `sum_adjacent_three`: the answer for `[1n, 2n, 3n]` is `[3n, 5n]`.
