Implement `last_index_of`, then prove the five laws in `LAWS.bend`.

`last_index_of(xs, k)` is the position of the last element of `xs` equal to
`k`, counting from `0n`. If `k` does not occur, it is the length of `xs`. For
the empty list that is `0n`.

    last_index_of([5n, 7n, 6n], 6n) == 2n
    last_index_of([5n, 7n, 6n], 9n) == 3n
    last_index_of([5n, 6n, 6n], 6n) == 2n
    last_index_of(Nil{}, 6n)        == 0n

The laws use these prelude names. `P.eq(a, b)` is the `Bool` comparison of two
`Nat`s. `P.at_if(b, x, y)` is `x` when `b` is `True{}` and `y` otherwise.
`P.has_k(xs, k)` is `True{}` when `k` occurs in `xs`. `P.len(xs)` is the number
of elements of `xs`. `P.inc_all(xs)` adds one to every element of `xs`, so none
of its elements is `0n`.

- `last_index_of_nil`: `last_index_of(Nil{}, k)` is `0n`.
- `last_index_of_step`: for `h <> t`, `last_index_of` is a decision `P.at_if`
  makes on `P.has_k(t, k)` between two numbers. The first is
  `1n + last_index_of(t, k)`, taken when `k` occurs in `t`. The second is itself
  a decision on `P.eq(h, k)` between `0n` and `1n + last_index_of(t, k)`.
- `last_index_of_miss`: `last_index_of(P.inc_all(xs), 0n)` is `P.len(xs)`.
- `last_index_of_hit`: `last_index_of(0n <> P.inc_all(xs), 0n)` is `0n`.
- `last_index_of_last_wins`: `last_index_of(k <> t, k)` is the decision
  `P.at_if` makes on `P.has_k(t, k)` between `1n + last_index_of(t, k)` and `0n`:
  a later occurrence in the tail wins over the head.
