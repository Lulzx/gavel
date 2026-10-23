Implement `add`, then prove the one law in `LAWS.bend`.

`add(a, b)` is the sum of the two numbers `a` and `b`.

    add(2n, 3n) == 5n
    add(0n, 4n) == 4n
    add(4n, 0n) == 4n

- `add_plus`: `add(x, y)` equals Base's built-in `x + y`, for every `x` and `y`.
