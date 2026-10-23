Implement `indices_of`, then prove the four laws in `LAWS.bend`.

`indices_of(xs, k)` is the list of every position at which `xs` holds `k`, in
ascending order, counting from `0n`. If `k` does not occur, or `xs` is empty,
the answer is the empty list.

    indices_of([5n, 7n, 5n], 5n) == [0n, 2n]
    indices_of([5n, 7n, 5n], 9n) == Nil{}
    indices_of(Nil{}, 5n)        == Nil{}

The laws use these prelude names. `P.eq(a, b)` is the `Bool` comparison of two
`Nat`s. `P.cons_if(b, x, ys)` is `x <> ys` when `b` is `True{}` and `ys`
otherwise. `P.inc_all(xs)` adds one to every element of `xs`, so none of its
elements is `0n`.

- `indices_of_nil`: `indices_of(Nil{}, k)` is `Nil{}`.
- `indices_of_step`: for `h <> t`, `indices_of` is the decision `P.cons_if`
  makes on `P.eq(h, k)`: it puts `0n` in front of a list when the head equals
  `k` and returns the list alone otherwise, where the list is `P.inc_all`
  applied to `indices_of(t, k)`, since every position in the tail is one further
  along.
- `indices_of_hit`: `indices_of(k <> t, k)` is `0n` in front of `P.inc_all`
  applied to `indices_of(t, k)`.
- `indices_of_miss`: `indices_of(P.inc_all(xs), 0n)` is `Nil{}`.
