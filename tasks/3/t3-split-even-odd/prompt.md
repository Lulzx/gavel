Implement `split`, then prove the three laws in `LAWS.bend`.

`split(xs)` separates `xs` into the elements at even positions and the elements
at odd positions, counting from zero, each half keeping the original order. The
answer is the prelude's pair `P.MkL{evens, odds}`:

    split([5n, 6n, 7n]) == P.MkL{[5n, 7n], [6n]}
    split([5n]) == P.MkL{[5n], Nil{}}
    split(Nil{}) == P.MkL{Nil{}, Nil{}}

The list type throughout is `List<&2, Nat>`. `P.evens(p)` and `P.odds(p)` are
the two fields of a `P.PairL`, and `P.len(xs)` is the number of elements of
`xs`.

- `split_nil`: the empty list splits into two empty lists.
- `split_cons`: splitting `h <> t` gives an even half of `h` followed by the odd
  half of `split(t)`, and an odd half equal to the even half of `split(t)`.
- `split_len`: the lengths of the two halves add up to the length of the input.
