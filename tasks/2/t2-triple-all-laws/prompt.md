Implement `triple_all`, then prove the two laws in `LAWS.bend`.

`triple_all(xs)` is the list of the same length as `xs` in which every element
`n` is replaced by `n + n + n`, in the same order. The empty list maps to the
empty list.

    triple_all([1n, 4n]) == [3n, 12n]
    triple_all([0n]) == [0n]
    triple_all(Nil{}) == Nil{}

The laws use the prelude's `P.triple(n)`, which is `n + n + n`, and
`P.append(xs, ys)`, the list `xs` followed by the list `ys`.

- `triple_all_single`: mapping the one-element list `[h]` gives the one-element
  list holding `P.triple(h)`.
- `triple_all_append`: mapping a concatenation is the concatenation of the two
  mapped lists.
