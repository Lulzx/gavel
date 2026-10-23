Implement `index_of`, then prove the four laws in `LAWS.bend`.

`index_of(xs, k)` is the position of the first element of `xs` equal to `k`,
counting from `0n`. If `k` does not occur, it is the length of `xs`. For the
empty list that is `0n`.

    index_of([5n, 7n, 6n], 6n) == 2n
    index_of([5n, 7n, 6n], 9n) == 3n
    index_of([5n, 6n, 6n], 6n) == 1n
    index_of(Nil{}, 6n)        == 0n

The laws use these prelude names. `P.eq(a, b)` is the `Bool` comparison of two
`Nat`s. `P.at_if(b, x, y)` is `x` when `b` is `True{}` and `y` otherwise.
`P.len(xs)` is the number of elements of `xs`. `P.inc_all(xs)` adds one to every
element of `xs`, so none of its elements is `0n`.

- `index_of_nil`: `index_of(Nil{}, k)` is `0n`.
- `index_of_step`: for `h <> t`, `index_of` is the decision `P.at_if` makes on
  `P.eq(h, k)` between two numbers: `0n` (the head is the target) and one more
  than `index_of(t, k)`.
- `index_of_hit`: `index_of(k <> t, k)` is `0n`, whatever `t` is.
- `index_of_miss`: `index_of(P.inc_all(xs), 0n)` is `P.len(xs)`.
