Implement `chunk_two` and `join_two`, then prove the six laws in `LAWS.bend`.

`chunk_two(xs)` groups the elements of `xs` in twos, left to right, as
`P.MkPair{a, b}` records. The groups do not overlap. If the list has an odd
length, the last element has no partner and is dropped.

`join_two(ps)` writes a list of `P.MkPair` records out flat: each record becomes
its two halves, `a` then `b`, in order.

    chunk_two([1n, 2n, 3n, 4n, 5n]) == P.MkPair{1n, 2n} <> P.MkPair{3n, 4n} <> Nil{}
    chunk_two([7n]) == Nil{}
    join_two(P.MkPair{1n, 2n} <> P.MkPair{3n, 4n} <> Nil{}) == [1n, 2n, 3n, 4n]
    join_two(Nil{}) == Nil{}

- `chunk_two_nil`: the empty list gives no groups.
- `chunk_two_single`: a one-element list gives no groups.
- `chunk_two_cons`: for a list `x <> y <> t` of two or more elements, the answer
  is `P.MkPair{x, y}` in front of `chunk_two(t)`.
- `join_two_nil`: no records write out to the empty list.
- `join_two_cons`: the record `P.MkPair{a, b}` in front of `t` writes out as
  `a`, then `b`, then `join_two(t)`.
- `chunk_two_join_two`: writing a list of records out and grouping the result
  again gives back the same list of records, `chunk_two(join_two(ps)) == ps`.
