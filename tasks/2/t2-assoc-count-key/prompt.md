Implement `count_key`, then prove the five laws in `LAWS.bend`.

`count_key(kvs, k)` is the number of entries of the association list `kvs`
whose key is `k`. An association list is a list of `P.Mk{key, value}` entries.
The empty list has none.

    count_key(Nil{}, 3n) == 0n
    count_key(P.Mk{1n, 5n} <> P.Mk{2n, 5n} <> P.Mk{1n, 0n} <> Nil{}, 1n) == 2n
    count_key(P.Mk{1n, 5n} <> P.Mk{2n, 5n} <> Nil{}, 5n) == 0n

Only the key of an entry is compared with `k`, never its value.

The prelude's `P.key_select(a, b, x, y)` is `x` when `a` and `b` are equal and
`y` otherwise. `P.assoc_put(kvs, k, v)` is `kvs` with the entry `P.Mk{k, v}`
added at the front.

- `count_key_nil`: the empty list has count `0n` for every `k`.
- `count_key_cons`: for a list `P.Mk{hk, hv} <> kvs`, the count is
  `P.key_select(hk, k, 1n + count_key(kvs, k), count_key(kvs, k))`.
- `count_key_hit`: an entry `P.Mk{k, v}` whose key is the query, with any value
  `v`, adds one: `count_key(P.Mk{k, v} <> kvs, k) == 1n + count_key(kvs, k)`.
- `count_key_skip`: an entry whose key is `1n + k` adds nothing:
  `count_key(P.Mk{1n + k, v} <> kvs, k) == count_key(kvs, k)`.
- `count_key_put`: storing under `k` raises the count for `k` by one,
  `count_key(P.assoc_put(kvs, k, v), k) == 1n + count_key(kvs, k)`.
