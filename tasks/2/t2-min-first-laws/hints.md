The reference matches on the list: `Nil{}` answers `Nil{}` and `h <> t` answers
`P.mf_put(h, min_first(t))`. `P.mf_put` does the comparison, because a `match`
cannot scrutinise a computed `P.le`.

- `min_first_nil`, `min_first_single` and `min_first_cons` close by `{==}`.
- `min_first_keep` and `min_first_swap`: the goal reduces to
  `P.mf_dec(x, y, Nil{}, P.le(x, y))`, which is stuck on the `Bool`. Flip the
  hypothesis with `Equal.sym(Bool, P.le(x, y), True{}, e)` (or `False{}`) and
  rewrite the `P.le` out, with hole in the last argument:

      %Equal.sym(Bool, P.le(x, y), True{}, e) : {P.mf_dec(x, y, Nil{}, _) == x <> y <> Nil{} : List<&2, Nat>}
      {==}

- `min_first_len`: induction on `xs`. It needs two `Policy.` lemmas, neither
  citing a law:
  - `mf_len(h, m, rest, k)`: `{P.len(P.mf_dec(h, m, rest, k)) == 1n + (1n + P.len(rest)) : Nat}`,
    a match on the `Bool` `k`, each case `{==}`.
  - `mf_put_len(h, r)`: `{P.len(P.mf_put(h, r)) == 1n + P.len(r) : Nat}`, a match
    on `r` (`Nil{}` is `{==}`, a cons uses `mf_len` at `P.le(h, m)`).

  `Nil{}` is `{==}`. In the cons case, flip `mf_put_len(h, min_first(t))` with
  `Equal.sym` and rewrite to `1n + P.len(min_first(t))`, then rewrite with the
  hypothesis at `t` and close by `{==}`.
