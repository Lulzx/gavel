The reference matches on the list. `Nil{}` answers `Nil{}`. A cons `+h <> +t`
answers `P.at_if(P.eq(h, x), t, h <> delete(x, t))`: the comparison is passed
to `P.at_if` because a `match` cannot scrutinise a computed value. The target is
declared `+x` and the tail is bound `+t`, since each is used twice.

- `delete_nil` and `delete_step` close by `{==}`: the list is a constructor, so
  the match steps and both sides are the same term.
- `delete_hit` needs `P.eq(k, k) == True{}`, which is stuck on a variable. Prove
  it as `Policy.eq_refl(k)` by a match on `k`: the `0n` case is `{==}`, and the
  `1n+p` case is one rewrite with `Policy.eq_refl(p)` then `{==}`, because
  `P.eq` steps one successor off both sides. In `delete_hit`, flip that lemma
  with `Equal.sym(Bool, P.eq(k, k), True{}, Policy.eq_refl(k))` and rewrite the
  decision's hole, giving `P.at_if(_, t, k <> S.delete(k, t)) == t`. Then
  `P.at_if(True{}, ...)` reduces to `t` and `{==}` closes it.
- `delete_miss` is an induction on `xs`. `Nil{}` is `{==}`. In the cons case the
  head is `1n + h`, so `P.eq(1n + h, 0n)` reduces to `False{}` and the decision
  takes its second answer, leaving `(1n + h) <> delete(0n, inc_all(t))` against
  `(1n + h) <> inc_all(t)`. One rewrite with `L.delete_miss(t)` and `{==}`.
