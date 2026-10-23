The reference matches on `kvs`: `Nil{}` answers `Nil{}`, and
`P.Mk{+hk, hv} <> +t` answers
`P.key_select(hk, k, t, P.Mk{hk, hv} <> assoc_delete(k, t))`. The key, `hk` and
the tail are each used twice, so declare `+k` and bind `+hk`, `+t`.

`assoc_delete_nil` and `assoc_delete_step` close by `{==}`.

`key_select` descends on both keys together, so with equal variable keys it is
stuck. Two `Policy.` lemmas, each an induction on the key (`x` and `y` erased
with `-`), stated with the decided answer on the left so a rewrite can replace
the `key_select` term:

- `key_select_self(a, -x, -y)`: `x == P.key_select(a, a, x, y)`.
- `key_select_succ(k, -x, -y)`: `y == P.key_select(1n + k, k, x, y)`.

Both have `{==}` in the `0n` case and, in the successor case, a rewrite with
the hypothesis at the predecessor (goal `{x == _ : ...}`) then `{==}`.

- `assoc_delete_hit`: rewrite with `key_select_self(k, kvs,
  P.Mk{k, w} <> assoc_delete(k, kvs))`, goal `{_ == kvs : ...}`, then `{==}`.
- `assoc_delete_skip`: rewrite with `key_select_succ(k, kvs,
  P.Mk{1n + k, w} <> assoc_delete(k, kvs))`, goal
  `{_ == P.Mk{1n + k, w} <> S.assoc_delete(k, kvs) : ...}`, then `{==}`.
