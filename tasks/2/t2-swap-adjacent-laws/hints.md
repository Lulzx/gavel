The reference matches on the list and then on its tail: `Nil{}` gives `Nil{}`;
`x <> Nil{}` gives `x <> Nil{}`; `x <> (y <> t2)` gives
`y <> (x <> swap_adjacent(t2))`.

The first three laws close by `{==}`.

`swap_adjacent_len` and `swap_adjacent_involutive` are inductions that step two
cells at a time: match `xs` as `Nil{}` or `x <> t`, then match `t` as `Nil{}` or
`y <> t2`, and use the hypothesis at `t2`. The two shorter cases close by `{==}`.

- `swap_adjacent_len`, `y <> t2` case: both sides reduce to `1n + (1n + ...)`:

      %L.swap_adjacent_len(t2) : {1n + (1n + P.len(S.swap_adjacent(t2))) == 1n + (1n + _) : Nat}
      {==}

- `swap_adjacent_involutive`, `y <> t2` case: the inner swap steps to
  `y <> (x <> ...)`, the outer one swaps it back, and the hypothesis covers the
  tail:

      %L.swap_adjacent_involutive(t2) : {x <> (y <> S.swap_adjacent(S.swap_adjacent(t2))) == x <> (y <> _) : List<Nat>}
      {==}
