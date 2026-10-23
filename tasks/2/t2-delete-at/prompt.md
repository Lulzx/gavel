Implement `delete_at`, then prove the four laws in `LAWS.bend`.

`delete_at(n, xs)` drops the element at position `n` of `xs`, counting from
`0n`, and keeps every other element in its order. If the list has no element at
position `n`, nothing is dropped and the list is returned unchanged; in
particular the empty list gives the empty list.

    delete_at(1n, [5n, 6n, 7n]) == [5n, 7n]
    delete_at(0n, [5n, 6n, 7n]) == [6n, 7n]
    delete_at(5n, [5n, 6n, 7n]) == [5n, 6n, 7n]
    delete_at(2n, Nil{}) == Nil{}

The prelude's `P.take(n, xs)` is the first `n` elements of `xs` (all of `xs` if it
is shorter). `P.drop(n, xs)` is `xs` without its first `n` elements (`Nil{}` if
it is shorter). `P.append(xs, ys)` is `xs` followed by `ys`.

- `delete_at_zero`: at position `0n` of a list `h <> t` the result is the tail `t`.
- `delete_at_nil`: on the empty list the result is the empty list, for every `n`.
- `delete_at_succ`: at position `1n + n` of a list `h <> t` the head is kept and
  the result is `h` in front of `delete_at(n, t)`.
- `delete_at_take_drop`: `delete_at(n, xs)` is the first `n` elements of `xs`
  followed by `xs` with its first `n` and then one more element removed:
  `P.append(P.take(n, xs), P.drop(1n, P.drop(n, xs)))`.
