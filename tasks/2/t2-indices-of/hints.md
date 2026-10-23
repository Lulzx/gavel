The reference matches on the list. `Nil{}` answers `Nil{}`. A cons `h <> t`
answers `P.cons_if(P.eq(h, k), 0n, P.inc_all(indices_of(t, k)))`: the comparison
goes through `P.cons_if` because a `match` cannot scrutinise a computed value,
and the tail's positions are shifted up by one with `P.inc_all`. The target is
used twice, so it is declared `+k`.

- `indices_of_nil` and `indices_of_step` close by `{==}`.
- `indices_of_hit` needs `P.eq(k, k) == True{}`, which is stuck on a variable.
  Prove `Policy.eq_refl(k)` by a match on `k`: `0n` is `{==}`, and `1n+p` is one
  rewrite with `Policy.eq_refl(p)` then `{==}`. In `indices_of_hit`, flip it with
  `Equal.sym(Bool, P.eq(k, k), True{}, Policy.eq_refl(k))` and rewrite the hole in
  `P.cons_if(_, 0n, P.inc_all(S.indices_of(t, k))) == 0n <> P.inc_all(S.indices_of(t, k))`;
  `{==}` then closes it.
- `indices_of_miss` is an induction on `xs`. `Nil{}` is `{==}`. In the cons case
  the head is `1n + h`, so `P.eq(1n + h, 0n)` is `False{}` and the decision
  returns the shifted tail alone, leaving `P.inc_all(indices_of(inc_all(t), 0n))`
  against `Nil{}`. Rewrite with the flipped hypothesis
  `Equal.sym(List<Nat>, S.indices_of(P.inc_all(t), 0n), Nil{}, L.indices_of_miss(t))`
  into the hole of `P.inc_all(_) == Nil{}`, then `{==}`.
