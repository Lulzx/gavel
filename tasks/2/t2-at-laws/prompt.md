Implement `at`, then prove the three laws in `LAWS.bend`.

`at(xs, n)` is element number `n` of `xs`, counting from `0n`. When the list has
no element at that position, including when it is empty, it is `0n`.

    at([5n, 6n, 7n], 0n) == 5n
    at([5n, 6n, 7n], 2n) == 7n
    at([5n, 6n, 7n], 3n) == 0n
    at(Nil{}, 4n) == 0n

The prelude's `P.append(xs, ys)` is `xs` followed by `ys`, and `P.len(xs)` is the
number of elements of `xs`.

- `at_succ`: element `1n + k` of a list `h <> xs` is element `k` of `xs`.
- `at_len_append`: in the list `xs` with `y` added at the end, the element at
  position `P.len(xs)` is `y`.
- `at_nil`: no position of the empty list holds anything but `0n`.
