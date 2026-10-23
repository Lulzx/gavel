Implement `assoc_update`, then prove the four laws in `LAWS.bend`.

`assoc_update(kvs, k, v)` replaces the value of the first entry of the
association list `kvs` whose key is `k` by `v`. Every other entry stays, in
order. If no entry has key `k`, the list is returned unchanged; it never adds an
entry. An association list is a list of `P.Mk{key, value}` entries. Only keys
are compared with `k`.

    assoc_update(P.Mk{1n, 7n} <> P.Mk{2n, 8n} <> Nil{}, 2n, 5n) == P.Mk{1n, 7n} <> P.Mk{2n, 5n} <> Nil{}
    assoc_update(P.Mk{1n, 7n} <> P.Mk{1n, 9n} <> Nil{}, 1n, 0n) == P.Mk{1n, 0n} <> P.Mk{1n, 9n} <> Nil{}
    assoc_update(P.Mk{1n, 7n} <> Nil{}, 4n, 5n) == P.Mk{1n, 7n} <> Nil{}

The prelude's `P.key_select(a, b, x, y)` is the list `x` when the numbers `a`
and `b` are equal and the list `y` otherwise.

- `update_nil`: updating the empty list gives the empty list.
- `update_cons`: for a list `P.Mk{hk, hv} <> kvs`, the result is chosen by
  `P.key_select` on the keys `hk` and `k`: the entry `P.Mk{k, v}` in front of
  the unchanged tail `kvs` if they are equal, and otherwise the head entry
  `P.Mk{hk, hv}` in front of `assoc_update(kvs, k, v)`.
- `update_hit`: when the first entry's key is `k`, the result is `P.Mk{k, v}`
  followed by the tail `kvs` as it stands, even if the tail has `k` again.
- `update_skip`: when the first entry's key is `1n + k`, the entry is kept and
  the update continues in the tail:
  `assoc_update(P.Mk{1n + k, w} <> kvs, k, v) == P.Mk{1n + k, w} <> assoc_update(kvs, k, v)`.
