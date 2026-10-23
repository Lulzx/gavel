Implement `sub_all`, then prove the two laws in `LAWS.bend`.

`sub_all(xs, n)` is the list of the same length as `xs` in which every element
`h` is replaced by `P.sub(h, n)`, in the same order. The empty list maps to the
empty list.

    sub_all([5n, 2n, 9n], 3n) == [2n, 0n, 6n]
    sub_all([1n], 0n) == [1n]
    sub_all(Nil{}, 4n) == Nil{}

The laws use the prelude's `P.sub(a, b)`, truncated subtraction: `a - b` when
`a` is at least `b`, and `0n` otherwise, and `P.append(xs, ys)`, the list `xs`
followed by the list `ys`.

- `sub_all_single`: mapping the one-element list `[h]` with `n` gives the
  one-element list holding `P.sub(h, n)`.
- `sub_all_append`: mapping a concatenation with `n` is the concatenation of
  the two lists each mapped with the same `n`.
