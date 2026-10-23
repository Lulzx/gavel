Implement `add`, then prove the two laws in `LAWS.bend`.

`add(a, b)` is the sum of the two natural numbers `a` and `b`.

    add(2n, 3n) == 5n
    add(0n, 4n) == 4n
    add(4n, 0n) == 4n

- `add_zero`: adding `0n` on the right changes nothing, `add(x, 0n) == x`.
- `add_succ`: adding a successor on the right is the successor of the sum,
  `add(x, 1n+y) == 1n+add(x, y)`.
