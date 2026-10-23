Implement `swap_adjacent`, then prove the five laws in `LAWS.bend`.

`swap_adjacent(xs)` exchanges the elements of each successive pair of `xs`: the
first with the second, the third with the fourth, and so on. If the length is
odd, the last element has no partner and stays where it is, so the answer always
has the same length as `xs`. The empty list and a one-element list answer
themselves.

    swap_adjacent([1n, 2n, 3n, 4n]) == [2n, 1n, 4n, 3n]
    swap_adjacent([1n, 2n, 3n]) == [2n, 1n, 3n]
    swap_adjacent([7n]) == [7n]

The laws use the prelude's `P.len(xs)`, the number of elements of `xs`.

- `swap_adjacent_nil`: the empty list gives the empty list.
- `swap_adjacent_single`: a one-element list gives itself.
- `swap_adjacent_cons`: for `x <> (y <> t)`, the answer is `y`, then `x`, then
  the answer for `t`.
- `swap_adjacent_len`: the answer has as many elements as `xs`.
- `swap_adjacent_involutive`: swapping twice gives back `xs`.
