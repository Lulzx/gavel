Implement `sub`, then prove the two laws in `LAWS.bend`.

`sub(a, b)` is `a - b`, stopping at `0n` rather than going below it: it is
`a - b` when `a` is at least `b`, and `0n` otherwise.

    sub(5n, 2n) == 3n
    sub(2n, 5n) == 0n
    sub(4n, 4n) == 0n
    sub(3n, 0n) == 3n

- `sub_cancel`: `sub(x + y, x)` is `y`, where `+` is Base's addition.
- `sub_saturates`: `sub(0n, y)` is `0n`, for every `y`.
