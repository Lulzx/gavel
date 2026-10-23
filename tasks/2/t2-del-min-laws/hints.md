The reference matches on the list: `Nil{}` answers `Nil{}`, and `+h <> +t`
answers `P.dm_put(h, t, del_min(t))`. `P.dm_put` matches on its tail and hands
the comparison `P.le(h, P.min_go(h2 <> t2, h2))` to `P.dm_dec` as a `Bool`
argument, since a match cannot scrutinise a computed value; `P.dm_dec(h, h2, t2, r, k)`
answers `h2 <> t2` on `True{}` and `h <> r` on `False{}`.

- `del_min_nil`, `del_min_single`: close by `{==}`.
- `del_min_keep`, `del_min_drop`: the premise is the comparison's answer, so
  flip it with `Equal.sym` and rewrite it into the `dm_dec` call, then `{==}`:

      %Equal.sym(Bool, P.le(x, P.min_go(y <> t, y)), True{}, e) : {P.dm_dec(x, y, t, S.del_min(y <> t), _) == y <> t : List<&2, Nat>}
      {==}

  and the same with `False{}` and goal `{... == x <> S.del_min(y <> t) : ...}`.
- `del_min_len`: needs an induction on the tail with the head generalised, so
  use two `Policy.` lemmas. `dm_dec_len(+h, +h2, +t2, +r, k, +e)`, with
  `e : P.len(r) == P.len(t2)`, concludes `1n + P.len(t2) == P.len(P.dm_dec(h, h2, t2, r, k))`
  by a match on `k` (`True{}` is `{==}`; `False{}` rewrites with `e`, goal
  `{1n + _ == 1n + P.len(r) : Nat}`). `del_min_len_gen(+t, +h)` states the law
  with the arguments swapped and is an induction on `t`: `Nil{}` is `{==}`, and
  the cons case applies `dm_dec_len` at the comparison and the hypothesis
  `del_min_len_gen(t2, h2)`, goal `{_ == P.len(h2 <> t2) : Nat}`, then `{==}`.
  The law itself is the call `Policy.del_min_len_gen(t, h)`.
