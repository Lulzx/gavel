Implement `assoc_put` and `keys`, then prove the five laws in `LAWS.bend`.

An association list is a list of `P.Entry`, a pair of a key and the value
stored under it, written `P.Mk{k, v}`.

`assoc_put(kvs, k, v)` stores `v` under `k`: the result is `kvs` with the new
entry `P.Mk{k, v}` at the front, so it is the entry a later reader meets first.

`keys(kvs)` is the list of the keys of the entries, in the order the entries
appear. An empty association list has no keys.

    assoc_put(P.Mk{1n, 2n} <> Nil{}, 4n, 9n) == P.Mk{4n, 9n} <> P.Mk{1n, 2n} <> Nil{}
    keys(P.Mk{1n, 2n} <> P.Mk{3n, 4n} <> Nil{}) == [1n, 3n]
    keys(Nil{}) == Nil{}

The laws use `P.len(xs)`, the number of elements of a `List<Nat>`, and
`P.plen(kvs)`, the number of entries of an association list.

- `put_cons`: `assoc_put(kvs, k, v)` is `P.Mk{k, v} <> kvs`.
- `keys_nil`: `keys(Nil{})` is `Nil{}`.
- `keys_cons`: the keys of `P.Mk{hk, hv} <> kvs` are `hk` in front of the keys
  of `kvs`.
- `keys_put`: the keys of `assoc_put(kvs, k, v)` are `k` in front of the keys
  of `kvs`.
- `keys_len`: `keys(kvs)` has as many elements as `kvs` has entries.
