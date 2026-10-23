The reference matches on `n`: `0n` answers `0n`, and `1n+np` binds the root of
`np` once (`+k = nat_sqrt(np)`, so there is a single recursive call) and answers
`Nat.add(k, P.le_ind(Nat.mul(1n + k, 1n + k), 1n + np))`.

- `nat_sqrt_zero`, `nat_sqrt_succ`, `nat_sqrt_four`, `nat_sqrt_eight` and
  `nat_sqrt_nine` close by `{==}`.
- `nat_sqrt_mono` needs one `Policy.` lemma, `le_self_add(a, +b)`:
  `{P.le_ind(a, a + b) == 1n : Nat}`, an induction on `a` with a split on `b`
  in the `0n` case (both sub-cases `{==}`); the successor case rewrites with the
  hypothesis at `ap` and closes by `{==}`. In the law, unfold `nat_sqrt(1n + n)`
  and apply it at `a = nat_sqrt(n)` and `b` the `P.le_ind(...)` term, with the
  hole at the left-hand `P.le_ind`; then `{==}`.
