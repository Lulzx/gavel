Implement `min_first`, then prove the six laws in `LAWS.bend`.

`min_first(xs)` is `xs` with its smallest element moved to the front and every
other element left in its original order. The empty list gives `Nil{}` and a
one-element list is its own answer. The lists are `List<&2, Nat>`.

    min_first([3n, 1n, 2n]) == [1n, 3n, 2n]
    min_first([2n, 2n, 5n, 1n]) == [1n, 2n, 2n, 5n]
    min_first([4n]) == [4n]

The laws use `P.le(a, b)`, the `Bool` that says `a` is at most `b`;
`P.len(xs)`, the number of elements; and `P.mf_put(h, r)`, which puts `h` onto
`r`, an already-arranged list: `h` stays in front when it is at most the front
of `r`, and otherwise the front of `r` goes first with `h` right behind it.

- `min_first_nil`: `min_first(Nil{})` is `Nil{}`.
- `min_first_single`: `min_first(x <> Nil{})` is `x <> Nil{}`.
- `min_first_cons`: `min_first(h <> t)` is `P.mf_put` applied to `h` and to `min_first(t)`.
- `min_first_keep`: when `P.le(x, y) == True{}`, `min_first(x <> y <> Nil{})` is
  `x <> y <> Nil{}`.
- `min_first_swap`: when `P.le(x, y) == False{}`, `min_first(x <> y <> Nil{})` is
  `y <> x <> Nil{}`.
- `min_first_len`: `min_first(xs)` has the same length as `xs`.
