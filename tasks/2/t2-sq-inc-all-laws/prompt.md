Implement `sq_inc_all`, then prove the two laws in `LAWS.bend`.

`sq_inc_all(xs)` is the list of the same length as `xs` in which every element
`n` is replaced by `n * n + 1n`, in the same order. The empty list maps to the
empty list.

    sq_inc_all([2n, 3n]) == [5n, 10n]
    sq_inc_all([0n]) == [1n]
    sq_inc_all(Nil{}) == Nil{}

The laws use the prelude's `P.sq_inc(n)`, which is `n * n + 1n`, and
`P.append(xs, ys)`, the list `xs` followed by the list `ys`.

- `sq_inc_all_single`: mapping the one-element list `[h]` gives the one-element
  list holding `P.sq_inc(h)`.
- `sq_inc_all_append`: mapping a concatenation is the concatenation of the two
  mapped lists.
