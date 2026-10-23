The reference matches on `xs`: `Nil{}` answers `Nil{}`, and `h <> t` answers
`P.drop_put(h, t, drop_while(t, n), P.le(h, n))`. The decision goes to
`P.drop_put` as an argument because a `match` cannot scrutinise the computed
`P.le(h, n)`. The cons step uses `t` twice (once in the recursion, once to hand
it back), which is why the stub declares `+xs` (and `+n`).

- `drop_while_nil` closes by `{==}`.
- `drop_while_keep` and `drop_while_stop` have no induction. `P.le(h, n)` is
  stuck on variables, so each is one rewrite that replaces it with the literal
  from the premise `e`, flipped because the hole sits where `P.le(h, n)` is:

      %Equal.sym(Bool, P.le(h, n), True{}, e) : {P.drop_put(h, t, S.drop_while(t, n), _) == S.drop_while(t, n) : List<&2, Nat>}
      {==}

  `drop_while_stop` is the same with `False{}`, `y` for `h`, and a right side
  of `y <> t`.
