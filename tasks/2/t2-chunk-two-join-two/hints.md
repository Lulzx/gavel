The reference for `chunk_two` matches on the list and then on its tail: `Nil{}`
answers `Nil{}`; `x <> Nil{}` answers `Nil{}`; `x <> h <> t2` answers
`P.MkPair{x, h} <> chunk_two(t2)`, recursing on the tail after the second
element. `join_two` matches on the list: `Nil{}` answers `Nil{}`, and
`P.MkPair{a, b} <> t` answers `a <> (b <> join_two(t))`.

The first five laws each close by `{==}`: every argument is a constructor, so
the matches step.

`chunk_two_join_two` is an induction on `ps`, since `join_two` is stuck on a
variable list. The `Nil{}` case is `{==}`. In the `P.MkPair{a, b} <> t` case
`join_two` writes the head out and `chunk_two` groups it straight back, leaving
`P.MkPair{a, b} <> chunk_two(join_two(t))`. Rewrite with the hypothesis at `t`
(no flip needed):

    %L.chunk_two_join_two(t) : {P.MkPair{a, b} <> S.chunk_two(S.join_two(t)) == P.MkPair{a, b} <> _ : List<&2, P.Pair>}
    {==}
