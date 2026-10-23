Implement `assoc_delete`, then prove the four laws in `LAWS.bend`.

`assoc_delete(k, kvs)` removes the first entry of the association list `kvs`
whose key is `k`. Every other entry stays, in its original order, and if no
entry has key `k` the whole list is returned. An association list is a list of
`P.Mk{key, value}` entries. Only keys are compared, never values.

    assoc_delete(1n, P.Mk{1n, 7n} <> P.Mk{2n, 8n} <> P.Mk{1n, 9n} <> Nil{}) == P.Mk{2n, 8n} <> P.Mk{1n, 9n} <> Nil{}
    assoc_delete(2n, P.Mk{1n, 7n} <> P.Mk{2n, 8n} <> Nil{}) == P.Mk{1n, 7n} <> Nil{}
    assoc_delete(5n, P.Mk{1n, 7n} <> Nil{}) == P.Mk{1n, 7n} <> Nil{}
    assoc_delete(0n, Nil{}) == Nil{}

The prelude's `P.key_select(a, b, x, y)` is the list `x` when the numbers `a`
and `b` are equal and the list `y` otherwise.

- `assoc_delete_nil`: deleting from the empty list gives the empty list.
- `assoc_delete_step`: for a list `P.Mk{hk, hv} <> t`, the result is chosen by
  `P.key_select` on the keys `hk` and `k`: the tail `t` if they are equal, and
  otherwise the head entry kept in front of `assoc_delete(k, t)`.
- `assoc_delete_hit`: when the first entry has key `k`, the result is exactly
  the tail `kvs`, even if the tail has `k` again.
- `assoc_delete_skip`: when the first entry has key `1n + k`, the entry is kept
  and the deletion continues in the tail:
  `assoc_delete(k, P.Mk{1n + k, w} <> kvs) == P.Mk{1n + k, w} <> assoc_delete(k, kvs)`.
