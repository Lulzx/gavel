The reference matches on the list of rows in both defs. `map_len`: `Nil{}`
answers `Nil{}`, and `l <> t` answers `P.len(l) <> map_len(t)`. `longest_row`:
`Nil{}` answers `0n`, and `l <> t` answers
`P.max(P.len(l), longest_row(t))`.

- The first four laws close by `{==}`.
- `longest_row_map_len` is an induction on `xss`. `Nil{}` is `{==}`. In the cons
  case the goal unfolds to `P.max(P.len(l), longest_row(t))` against
  `P.max(P.len(l), P.max_list(map_len(t)))`, so one rewrite with the hypothesis
  at `t`, under the `P.max`, then `{==}`:

      %L.longest_row_map_len(t) : {P.max(P.len(l), S.longest_row(t)) == P.max(P.len(l), _) : Nat}
      {==}
