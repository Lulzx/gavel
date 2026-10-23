Implement `is_prefix`, then prove the five laws in `LAWS.bend`.

`is_prefix(xs, ys)` is `True{}` when `ys` starts with `xs`, that is, when `xs`
is the first part of `ys`, element for element. The empty list is a prefix of
every list. A non-empty list is not a prefix of the empty list, and a list
longer than `ys` is never a prefix of it.

    is_prefix([1n, 2n], [1n, 2n, 3n]) == True{}
    is_prefix([2n], [1n, 2n])         == False{}
    is_prefix([1n], Nil{})            == False{}
    is_prefix(Nil{}, [1n])            == True{}

The laws use two prelude names. `P.eq(a, b)` is the `Bool` comparison of two
`Nat`s. `P.append(xs, ys)` is the list `xs` followed by the list `ys`.

- `is_prefix_nil`: `is_prefix(Nil{}, ys)` is `True{}`.
- `is_prefix_nil_right`: `is_prefix(h <> t, Nil{})` is `False{}`.
- `is_prefix_cons`: `is_prefix(h <> t, k <> u)` is `Bool.and` of `P.eq(h, k)`
  and `is_prefix(t, u)`: the heads are equal and the tails are a prefix.
- `is_prefix_append`: `is_prefix(xs, P.append(xs, ys))` is `True{}`.
- `is_prefix_self`: `is_prefix(xs, xs)` is `True{}`.
