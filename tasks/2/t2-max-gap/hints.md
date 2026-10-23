`gap_go` matches on the list: `Nil{}` answers `best`, and a cons `+h <> t`
walks on with `gap_go(t, h, Nat.max(P.absdiff(prev, h), best))`. The head is
used twice, so it is bound `+h`. `max_gap` matches on the list: `Nil{}` is
`0n` and `h <> t` is `gap_go(t, h, 0n)`.

Six laws close by `{==}`: `max_gap_nil`, `max_gap_single`, `max_gap_cons`,
`gap_go_nil`, `gap_go_cons` and `max_gap_three` are all definitional.

`gap_go_same` is an induction on `n`, and needs two `Policy.` lemmas:

- `absdiff_self(a)`: `{0n == P.absdiff(a, a) : Nat}`, by induction on `a`
  (the successor case rewrites with the hypothesis at `p`, then `{==}`).
- `max_zero_left(m)`: `{m == Nat.max(0n, m) : Nat}`, by a match on `m`; both
  cases are `{==}`.

The `0n` case is `{==}`. In the `1n+p` case the list opens to `k <> same(p, k)`
and the goal holds `P.absdiff(k, k)` inside a `Nat.max`. Rewrite in order with
`absdiff_self(k)` (hole at the distance), `max_zero_left(best)` (hole at the
`Nat.max`), then the hypothesis `L.gap_go_same(p, k, best)`, and close with
`{==}`:

    %Policy.absdiff_self(k) : {S.gap_go(P.same(p, k), k, Nat.max(_, best)) == best : Nat}
