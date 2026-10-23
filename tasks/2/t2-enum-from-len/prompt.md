Implement `enum_from`, then prove the three laws in `LAWS.bend`.

`enum_from(n, a)` is the list of `n` consecutive numbers starting at `a`, in
increasing order. A count of `0n` gives the empty list.

    enum_from(3n, 5n) == [5n, 6n, 7n]
    enum_from(1n, 0n) == [0n]
    enum_from(0n, 5n) == Nil{}

The laws use the prelude's `P.len(xs)`, the number of elements of `xs`.

- `enum_from_zero`: `enum_from(0n, a)` is the empty list.
- `enum_from_succ`: `enum_from(1n + n, a)` is `a` in front of `enum_from(n, 1n + a)`.
- `enum_from_len`: `enum_from(n, a)` has exactly `n` elements.
