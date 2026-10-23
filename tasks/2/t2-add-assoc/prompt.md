Implement `add`, then prove the two laws in `LAWS.bend`.

`add(a, b)` is the sum of the two natural numbers `a` and `b`.

    add(2n, 3n) == 5n
    add(0n, 4n) == 4n
    add(4n, 0n) == 4n

- `add_one`: adding `1n` on the right is the same as adding it on the left,
  `add(x, 1n) == 1n + x`.
- `add_assoc`: addition is associative, `add(add(x, y), z) == add(x, add(y, z))`.
