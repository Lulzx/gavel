Implement `indexed_go` and `indexed`, then prove the four laws in `LAWS.bend`.

`indexed(xs)` pairs every element of `xs` with its position, counting from
`0n`, keeping the order. Each pair is `P.MkIndexed{i, x}`: position `i`, element
`x`. The empty list gives the empty list.

    indexed([5n, 6n]) == [P.MkIndexed{0n, 5n}, P.MkIndexed{1n, 6n}]
    indexed(Nil{})    == Nil{}

`indexed_go(xs, i)` does the same but counts from `i` instead of `0n`. The list
is the first parameter and the starting position the second.

    indexed_go([5n, 6n], 3n) == [P.MkIndexed{3n, 5n}, P.MkIndexed{4n, 6n}]

The laws use these prelude names. `P.len(xs)` is the number of elements of a
list of `Nat`, and `P.plen(ps)` the number of elements of a list of
`P.Indexed`. `P.elems(ps)` is the list of the elements of `ps` with the
positions thrown away, in order.

- `indexed_zero`: `indexed(xs)` is `indexed_go(xs, 0n)`.
- `indexed_cons`: `indexed_go(x <> t, i)` is `P.MkIndexed{i, x}` in front of
  `indexed_go(t, i + 1n)`.
- `indexed_len`: `P.plen(indexed_go(xs, i))` is `P.len(xs)`.
- `indexed_elems`: `P.elems(indexed_go(xs, i))` is `xs`.
