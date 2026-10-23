Implement `add` and `double`, then prove the three laws in `LAWS.bend`.

`add(a, b)` is the sum of `a` and `b`. `double(a)` is `a` added to itself, that
is, twice `a`.

    add(2n, 3n) == 5n
    double(4n)  == 8n
    double(0n)  == 0n

- `add_plus`: `add(x, y)` equals Base's built-in `x + y`.
- `double_eq_add`: `double(x)` equals `add(x, x)`.
- `double_succ`: `double(1n+x)` is `1n+1n+double(x)`.
