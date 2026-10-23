The reference matches on `kvs`: `Nil{}` answers `0n`, and `P.Mk{hk, hv} <> t`
answers `P.key_select(hk, k, hv, assoc_lookup(t, k))`. `k` is used twice, so
declare `+k`.

`lookup_nil` and `lookup_cons` close by `{==}`.

`key_select` descends on both keys together, so with equal variable keys it is
stuck. Two `Policy.` lemmas, each an induction on the key (`x` and `y` erased
with `-`), stated with the decided answer on the left so a rewrite can replace
the `key_select` term:

- `key_select_self(a, -x, -y)`: `x == P.key_select(a, a, x, y)`.
- `key_select_succ(k, -x, -y)`: `y == P.key_select(1n + k, k, x, y)`.

Both have `{==}` in the `0n` case and, in the successor case, a rewrite with
the hypothesis at the predecessor (goal `{x == _ : Nat}`) then `{==}`.

- `lookup_hit`: rewrite with `key_select_self(k, v, assoc_lookup(kvs, k))`, goal
  `{_ == v : Nat}`, then `{==}`.
- `lookup_skip`: rewrite with `key_select_succ(k, v, assoc_lookup(kvs, k))`,
  goal `{_ == S.assoc_lookup(kvs, k) : Nat}`, then `{==}`.
