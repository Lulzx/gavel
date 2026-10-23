Implement `succ2_all`, then prove the two laws in `LAWS.bend`.

`succ2_all(xs)` is the list of the same length as `xs` in which every element
`n` is replaced by `n + 2n`, in the same order. The empty list maps to the empty
list.

    succ2_all([1n, 4n]) == [3n, 6n]
    succ2_all([0n]) == [2n]
    succ2_all(Nil{}) == Nil{}

The laws use the prelude's `P.succ2(n)`, which is `n + 2n`, and
`P.append(xs, ys)`, the list `xs` followed by the list `ys`.

- `succ2_all_single`: mapping the one-element list `[h]` gives the one-element
  list holding `P.succ2(h)`.
- `succ2_all_append`: mapping a concatenation is the concatenation of the two
  mapped lists.
