Implement `count_if`, then prove the three laws in `LAWS.bend`.

`count_if(ps)` counts the records in the list `ps` whose two halves are the same number.
A record is `P.MkPair{a, b}`. The empty list counts `0n`.

    count_if(P.MkPair{1n, 1n} <> P.MkPair{2n, 3n} <> P.MkPair{4n, 4n} <> Nil{}) == 2n
    count_if(P.MkPair{2n, 3n} <> Nil{}) == 0n
    count_if(Nil{}) == 0n

The prelude's `P.same(a, b)` is `1n` when `a` and `b` are the same number and
`0n` otherwise. `P.append(ps, qs)` is the list `ps` followed by `qs`.

- `count_if_nil`: the empty list counts `0n`.
- `count_if_cons`: for a list `P.MkPair{a, b} <> t`, the count is
  the record's `P.same(a, b)` added to `count_if(t)`.
- `count_if_snoc`: adding one record `P.MkPair{a, b}` at the end of `ps` adds its
  contribution: `count_if(P.append(ps, P.MkPair{a, b} <> Nil{}))` is
  `count_if(ps) + P.same(a, b)`.
