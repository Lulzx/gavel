Implement `rev`, then prove the four laws in `LAWS.bend`.

`rev(xs)` is `xs` with its elements in the opposite order.

    rev([1n, 2n, 3n]) == [3n, 2n, 1n]
    rev(Nil{}) == Nil{}

The list type is the prelude's `List<&2, Nat>`; a statement written over
`List<Nat>` will not unify with the laws. `P.len(xs)` is the number of elements
of `xs`, `P.append(xs, ys)` is `xs` followed by `ys`, and `P.snoc(xs, y)` is
`xs` with `y` put on the end.

- `rev_len`: reversing a list does not change its number of elements.
- `rev_append`: reversing `xs` followed by `ys` gives the reverse of `ys`
  followed by the reverse of `xs`.
- `rev_rev`: reversing twice gives back `xs`.
- `rev_singleton`: a one-element list `[x]` reverses to itself.
