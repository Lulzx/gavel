Implement `values` and `sum_values`, then prove the six laws in `LAWS.bend`.

An association list is a list of `P.Entry`, a pair of a key and the value
stored under it, written `P.Mk{k, v}`.

`values(kvs)` is the list of the values stored in `kvs`, in the order the
entries appear. `sum_values(kvs)` is the sum of those values. Keys play no part
in either answer. The empty association list has no values and its values sum
to `0n`.

    values(P.Mk{1n, 2n} <> P.Mk{3n, 4n} <> Nil{}) == [2n, 4n]
    sum_values(P.Mk{1n, 2n} <> P.Mk{3n, 4n} <> Nil{}) == 6n
    sum_values(Nil{}) == 0n

The laws use `P.assoc_put(kvs, k, v)`, which puts the entry `P.Mk{k, v}` at the
front of `kvs`, and `P.nsum(xs)`, the sum of the elements of a `List<Nat>`.

- `values_nil`: `values(Nil{})` is `Nil{}`.
- `values_cons`: the values of `P.Mk{hk, hv} <> kvs` are `hv` in front of the
  values of `kvs`.
- `values_put`: the values of `P.assoc_put(kvs, k, v)` are `v` in front of the
  values of `kvs`.
- `sum_values_nil`: `sum_values(Nil{})` is `0n`.
- `sum_values_cons`: `sum_values(P.Mk{hk, hv} <> kvs)` is `hv` plus
  `sum_values(kvs)`.
- `sum_values_values`: `sum_values(kvs)` equals `P.nsum(values(kvs))`, for
  every `kvs`.
