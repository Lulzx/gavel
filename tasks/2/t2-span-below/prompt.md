Implement `span_below`, then prove the four laws in `LAWS.bend`.

`span_below(xs, n)` splits `xs` into two lists, answered as `P.MkL{front, back}`:
`front` is the longest prefix of `xs` whose elements are all at most `n`, and
`back` is the rest of `xs`, starting at the first element above `n`. Appending
`front` and `back` gives `xs`. A later element at most `n` stays in `back`.

    span_below([1n, 2n, 5n, 1n], 3n) == P.MkL{1n <> 2n <> Nil{}, 5n <> 1n <> Nil{}}
    span_below([7n, 1n], 3n) == P.MkL{Nil{}, 7n <> 1n <> Nil{}}
    span_below(Nil{}, 3n) == P.MkL{Nil{}, Nil{}}

The laws use `P.le(a, b)`, the `Bool` that says `a` is at most `b`; the two
projections `P.front(p)` and `P.back(p)` of a `P.PairL`; and `P.len(xs)`, the
number of elements of `xs`.

- `span_below_nil`: the empty list gives `P.MkL{Nil{}, Nil{}}`.
- `span_below_keep`: when `P.le(h, n) == True{}`, `span_below(h <> t, n)` has `h`
  at the front of the tail's `front`, and the tail's `back` unchanged.
- `span_below_stop`: when `P.le(y, n) == False{}`, `span_below(y <> t, n)` is
  `P.MkL{Nil{}, y <> t}`.
- `span_below_len`: the lengths of `front` and `back` add up to the length of
  `xs`.
