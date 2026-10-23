The reference matches on `xs`: `Nil{}` answers `0n`, and `h <> t` answers
`P.count_put(count_while(t, n), P.le(h, n))`. The decision is passed to
`P.count_put` as an argument because a `match` cannot scrutinise the computed
`P.le(h, n)`. `n` is used twice, so it is declared `+n`.

- `count_while_nil` closes by `{==}`.
- `count_while_keep` and `count_while_stop` have no induction. `P.le(h, n)` is
  stuck on variables, so each needs one rewrite that replaces it by the literal
  from the premise `e`. The premise says `P.le(h, n) == True{}`, and the hole
  must sit where `P.le(h, n)` is, so flip it:

      %Equal.sym(Bool, P.le(h, n), True{}, e) : {P.count_put(S.count_while(t, n), _) == 1n + S.count_while(t, n) : Nat}
      {==}

  `count_while_stop` is the same with `False{}` and a right side of `0n`.
