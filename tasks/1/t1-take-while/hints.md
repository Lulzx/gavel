The reference matches on `xs`: `Nil{}` answers `Nil{}`, and `h <> t` answers
`P.keep_put(h, take_while(t, n), P.le(h, n))`. The decision goes to
`P.keep_put` as an argument because a `match` cannot scrutinise the computed
`P.le(h, n)`. `h` is used twice (in `P.keep_put` and in `P.le`), so it is bound
as `+h`, and `n` is `+n` in the stub.

- `take_while_nil` closes by `{==}`.
- `take_while_keep` and `take_while_stop` have no induction. `P.le(h, n)` is
  stuck on variables, so each is one rewrite that replaces it with the literal
  from the premise `e`, flipped because the hole sits where `P.le(h, n)` is:

      %Equal.sym(Bool, P.le(h, n), True{}, e) : {P.keep_put(h, S.take_while(t, n), _) == h <> S.take_while(t, n) : List<Nat>}
      {==}

  `take_while_stop` is the same with `False{}`, `y` for `h`, and a right side
  of `Nil{}`.
