The reference matches on the list: `Nil{}` answers `0n`, and `h <> +t` answers
`P.count_gt(h, t) + count_inv(t)`. The tail is read twice, so bind it `+t`.

- `count_inv_nil`, `count_inv_single`, `count_inv_cons`: close by `{==}`.
- `count_inv_replicate`: induction on `n`; the `0n` case is `{==}`. In the
  successor case the goal is `P.count_gt(a, replicate(k, a)) + count_inv(replicate(k, a))`
  against `0n`. Two `Policy.` lemmas, stated with `0n` on the left so a rewrite
  can replace the stuck term by `0n`:
  - `is_lt_refl(a)`: `0n == P.is_lt(a, a)`, an induction on `a` (rewrite with the
    hypothesis, goal `{0n == _ : Nat}`).
  - `count_gt_replicate(n, +a)`: `0n == P.count_gt(a, P.replicate(n, a))`, an
    induction on `n`; the step rewrites with `is_lt_refl(a)` (goal
    `{0n == _ + P.count_gt(a, P.replicate(k, a)) : Nat}`) and then with the
    hypothesis at `k`.

  The law then rewrites with `count_gt_replicate(k, a)` (goal
  `{_ + S.count_inv(P.replicate(k, a)) == 0n : Nat}`), then with the law's own
  hypothesis at `k`, flipped by `Equal.sym` (goal `{_ == 0n : Nat}`), then `{==}`.
