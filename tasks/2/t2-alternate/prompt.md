Implement `alternate`, then prove the four laws in `LAWS.bend`.

`alternate(n, a, b)` is the list of length `n` whose elements alternate between
`a` and `b`, starting with `a`. A count of `0n` gives the empty list.

    alternate(4n, 1n, 2n) == [1n, 2n, 1n, 2n]
    alternate(3n, 5n, 7n) == [5n, 7n, 5n]
    alternate(0n, 1n, 2n) == Nil{}

The prelude's `P.len(xs)` is the number of elements of `xs`.

- `alternate_zero`: with a count of `0n` the answer is the empty list, whatever
  `a` and `b` are.
- `alternate_cons`: with a count of `1n+n`, the answer is `a` followed by
  `alternate(n, b, a)`: the same alternation with the two numbers swapped.
- `alternate_two`: with a count of `2n` the answer is `[a, b]`.
- `alternate_len`: the answer has length `n`, `P.len(alternate(n, a, b)) == n`.
