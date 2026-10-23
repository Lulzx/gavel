The reference matches on the list: `Nil{}` answers `Nil{}`, and `h <> +t`
answers `P.at_if(P.eq(h, x), 0n <> P.inc_all(positions(x, t)), P.inc_all(positions(x, t)))`.
The test is a computed value, so it goes through `P.at_if`. `x` is `+x`.

- `positions_nil` and `positions_step` close by `{==}`.
- `positions_hit`: `P.eq(k, k)` is stuck on a variable. A `Policy.` lemma
  `eq_refl(k)`: `{P.eq(k, k) == True{} : Bool}`, by induction on `k` (`0n` is
  `{==}`; `1n+p` rewrites with the hypothesis, then `{==}`). Flip it with
  `Equal.sym` and rewrite the test, then `{==}`:

      %Equal.sym(Bool, P.eq(k, k), True{}, Policy.eq_refl(k)) : {P.at_if(_, 0n <> P.inc_all(S.positions(k, t)), P.inc_all(S.positions(k, t))) == 0n <> P.inc_all(S.positions(k, t)) : List<&2, Nat>}

- `positions_miss`: induction on `xs`. `Nil{}` is `{==}`. In `h <> t`,
  `P.eq(1n + h, 0n)` reduces to `False{}`, so the answer is
  `P.inc_all(positions(0n, P.inc_all(t)))`. Flip the hypothesis at `t` with
  `Equal.sym` (it says `positions(0n, P.inc_all(t)) == Nil{}`), rewrite, then
  `{==}`.
