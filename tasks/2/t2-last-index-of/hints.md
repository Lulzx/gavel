The reference matches on the list. `Nil{}` answers `0n`. A cons `h <> +t` answers
`P.at_if(P.has_k(t, k), 1n + last_index_of(t, k), P.at_if(P.eq(h, k), 0n, 1n + last_index_of(t, k)))`.
The decisions go through `P.at_if` because a `match` cannot scrutinise a
computed value. The tail is bound `+t` and the target is `+k`, since each is
used several times.

- `last_index_of_nil` and `last_index_of_step` close by `{==}`.
- `Policy.eq_refl(k) : P.eq(k, k) == True{}`: `0n` is `{==}`; `1n+p` is one
  rewrite with `Policy.eq_refl(p)` then `{==}`.
- `Policy.has_k_inc_all(xs) : P.has_k(P.inc_all(xs), 0n) == False{}`: induction
  on `xs`; cons case is a rewrite with the hypothesis at `t`, then `{==}` (each
  head is a successor, so `P.eq(1n + h, 0n)` is `False{}`).
- `last_index_of_miss` is an induction on `xs` (heads bound `+h`, `+t`).
  `Nil{}` is `{==}`. In the cons case rewrite `P.has_k(P.inc_all(t), 0n)` to
  `False{}` with the flipped `has_k_inc_all(t)`, then the recursive call to
  `P.len(t)` with the flipped hypothesis `L.last_index_of_miss(t)`; `{==}`.
- `last_index_of_hit` needs no induction: match on `xs`. `Nil{}` is `{==}`. In
  the cons case rewrite the `P.has_k` test to `False{}` with the flipped
  `has_k_inc_all(t)`; `P.eq(0n, 0n)` reduces and `{==}` closes it.
- `last_index_of_last_wins`: flip `Policy.eq_refl(k)` and rewrite the inner
  `P.eq(k, k)` hole, then `{==}`: the inner decision takes `0n`, matching the
  right side whatever `P.has_k(t, k)` is.
