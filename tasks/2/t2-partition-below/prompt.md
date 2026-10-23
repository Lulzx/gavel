Implement `partition_below`, then prove the four laws in `LAWS.bend`.

`partition_below(xs, n)` splits `xs` into two lists, answered as
`P.MkL{front, back}`: `front` holds the elements that are at most `n` and
`back` holds the elements that are above `n`. Each keeps the order of `xs`, and
every element lands in exactly one of them.

    partition_below([1n, 5n, 2n, 7n], 3n) == P.MkL{1n <> 2n <> Nil{}, 5n <> 7n <> Nil{}}
    partition_below([4n], 4n) == P.MkL{4n <> Nil{}, Nil{}}
    partition_below(Nil{}, 2n) == P.MkL{Nil{}, Nil{}}

The laws use `P.le(a, b)`, the `Bool` that says `a` is at most `b`; the two
projections `P.front(p)` and `P.back(p)` of a `P.PairL`; and `P.len(xs)`, the
number of elements of `xs`.

- `partition_below_nil`: the empty list gives `P.MkL{Nil{}, Nil{}}`.
- `partition_below_keep`: when `P.le(h, n) == True{}`, `partition_below(h <> t, n)`
  has `h` at the front of the tail's `front`, and the tail's `back` unchanged.
- `partition_below_drop`: when `P.le(y, n) == False{}`, `partition_below(y <> t, n)`
  has the tail's `front` unchanged, and `y` at the front of the tail's `back`.
- `partition_below_len`: the lengths of `front` and `back` add up to the length
  of `xs`.
