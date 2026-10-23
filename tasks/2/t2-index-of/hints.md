The reference matches on the list. `Nil{}` answers `0n`. A cons `h <> t` answers
`P.at_if(P.eq(h, k), 0n, 1n + index_of(t, k))`: the comparison goes through
`P.at_if` because a `match` cannot scrutinise a computed value. The target is
used twice, so it is declared `+k`.

- `index_of_nil` and `index_of_step` close by `{==}`: the list is a constructor,
  so the match steps.
- `index_of_hit` needs `P.eq(k, k) == True{}`, which is stuck on a variable.
  Prove `Policy.eq_refl(k)` by a match on `k`: `0n` is `{==}`, and `1n+p` is one
  rewrite with `Policy.eq_refl(p)` then `{==}`. In `index_of_hit`, flip it with
  `Equal.sym(Bool, P.eq(k, k), True{}, Policy.eq_refl(k))` and rewrite the
  hole in `P.at_if(_, 0n, 1n + S.index_of(t, k)) == 0n`; `{==}` then closes it.
- `index_of_miss` is an induction on `xs`. `Nil{}` is `{==}`. In the cons case
  the head is `1n + h`, so `P.eq(1n + h, 0n)` reduces to `False{}` and the
  decision takes its second answer, leaving
  `1n + index_of(inc_all(t), 0n) == 1n + len(t)`. Rewrite with the hypothesis
  flipped: `Equal.sym(Nat, S.index_of(P.inc_all(t), 0n), P.len(t), L.index_of_miss(t))`,
  then `{==}`.
