The reference matches on `kvs`: `Nil{}` answers `0n`, and `P.Mk{hk, hv} <> +t`
answers `P.key_select(hk, k, 1n + count_key(t, k), count_key(t, k))`. The tail
and `k` are each used twice, so declare `+k` and bind `+t`.

`count_key_nil` and `count_key_cons` close by `{==}`.

`key_select` descends on both keys together, so `key_select(a, a, x, y)` and
`key_select(1n + k, k, x, y)` are stuck on a variable. Two `Policy.` lemmas,
each an induction on the key (`x` and `y` erased with `-`), stated with the
decided answer on the left because the rewrite replaces the `key_select` term:

- `key_select_self(a, -x, -y)`: `x == P.key_select(a, a, x, y)`.
- `key_select_succ(k, -x, -y)`: `y == P.key_select(1n + k, k, x, y)`.

Both have `{==}` in the `0n` case and, in the successor case, a rewrite with
the hypothesis at the predecessor (goal `{x == _ : Nat}`) then `{==}`.

- `count_key_hit` and `count_key_put`: rewrite with
  `key_select_self(k, 1n + count_key(kvs, k), count_key(kvs, k))`, goal
  `{_ == 1n + S.count_key(kvs, k) : Nat}`, then `{==}`.
- `count_key_skip`: rewrite with `key_select_succ(k, 1n + count_key(kvs, k),
  count_key(kvs, k))`, goal `{_ == S.count_key(kvs, k) : Nat}`, then `{==}`.
