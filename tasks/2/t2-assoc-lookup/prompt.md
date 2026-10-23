Implement `assoc_lookup`, then prove the four laws in `LAWS.bend`.

`assoc_lookup(kvs, k)` is the value stored under the key `k` in the association
list `kvs`, a list of `P.Mk{key, value}` entries. When several entries have key
`k` it is the value of the first one. When none does, it is `0n`. Only keys are
compared with `k`, never values.

    assoc_lookup(P.Mk{1n, 7n} <> P.Mk{2n, 8n} <> Nil{}, 2n) == 8n
    assoc_lookup(P.Mk{1n, 7n} <> P.Mk{1n, 9n} <> Nil{}, 1n) == 7n
    assoc_lookup(P.Mk{1n, 7n} <> Nil{}, 4n) == 0n
    assoc_lookup(Nil{}, 4n) == 0n

The prelude's `P.key_select(a, b, x, y)` is `x` when `a` and `b` are equal and
`y` otherwise.

- `lookup_nil`: looking up any key in the empty list gives `0n`.
- `lookup_cons`: for a list `P.Mk{hk, hv} <> kvs`, the result is chosen by
  `P.key_select` on the keys `hk` and `k`: the head's value `hv` if they are
  equal, and otherwise `assoc_lookup(kvs, k)`.
- `lookup_hit`: when the first entry's key is `k`, the result is that entry's
  value `v`, whatever the tail is.
- `lookup_skip`: when the first entry's key is `1n + k`, the entry is ignored
  and the result is `assoc_lookup(kvs, k)`.
