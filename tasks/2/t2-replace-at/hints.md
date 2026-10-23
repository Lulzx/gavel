The reference matches on the count `n` and then on the list. At `0n`, `Nil{}`
answers `Nil{}` and `h <> t` answers `y <> t`; at `1n+p`, `Nil{}` answers
`Nil{}` and `h <> t` answers `h <> replace_at(p, t, y)`.

- `replace_at_zero` and `replace_at_succ` close by `{==}`.
- `replace_at_nil`: the list is a literal but the count is a variable, so match
  on `n`; both cases are `{==}`.
- `replace_at_idem`: induction on `n`, with a match on `xs` inside each case.
  Every case closes by `{==}` except `1n+p` with `h <> t`: there rewrite with
  the hypothesis at `(p, t, y, z)`, flipped with `Equal.sym` because the goal
  holds the twice-replaced list:

      %Equal.sym(List<Nat>, S.replace_at(p, S.replace_at(p, t, y), z), S.replace_at(p, t, z), L.replace_at_idem(p, t, y, z)) : {h <> _ == h <> S.replace_at(p, t, z) : List<Nat>}
