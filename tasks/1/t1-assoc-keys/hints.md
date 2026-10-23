`assoc_put` is just `P.Mk{k, v} <> kvs`, with no walk. `keys` matches on
`kvs`: `Nil{}` answers `Nil{}`, and `P.Mk{hk, hv} <> t` answers
`hk <> keys(t)`.

- `put_cons`, `keys_nil`, `keys_cons` and `keys_put` all close by `{==}`: each
  side is built from a literal constructor, so `assoc_put` and `keys` both
  step. `keys_nil` takes no parameters (`def L.keys_nil():`).
- `keys_len` is an induction on `kvs`, matching with `P.Mk{hk, hv} <> t` in
  the cons case. The `Nil{}` case is `{==}`. In the cons case the sides reduce
  to `1n + P.len(S.keys(t))` and `1n + P.plen(t)`; rewrite with
  `L.keys_len(t)` and close with `{==}`.
