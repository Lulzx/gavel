Implement `collatz_len`, then prove the six laws in `LAWS.bend`.

`collatz_len(fuel, n)` counts the Collatz steps that take `n` down to `1n`. One
step sends an even number to half of it and an odd number to `3n * n + 1n`. The
walk stops, with no further steps, at `0n` and at `1n`. `fuel` is a budget of
steps: when it is `0n` the walk has run out and the answer is `0n`. Each step
spends one unit of fuel and adds one to the count. With enough fuel the answer
is the number of steps to reach `1n`.

    collatz_len(30n, 6n) == 8n
    collatz_len(30n, 15n) == 17n
    collatz_len(30n, 1n) == 0n
    collatz_len(0n, 6n) == 0n

The prelude's `P.is_even_b(n)` is `True{}` when `n` is even, and `P.half(n)` is `n`
divided by two, rounding down. `Bool.pick(Nat, b, x, y)` is `x` when `b` is
`True{}` and `y` when it is `False{}`.

- `collatz_len_no_fuel`: with `0n` fuel the answer is `0n`, for every `n`.
- `collatz_len_zero`: at `n = 0n` the answer is `0n`, for every fuel.
- `collatz_len_one`: at `n = 1n` the answer is `0n`, for every fuel.
- `collatz_len_step`: with fuel `1n + f` and a number `1n + 1n + p`, the answer is
  `1n` more than `collatz_len` with fuel `f` at the next number. The next number
  is `Bool.pick(Nat, P.is_even_b(m), P.half(m), Nat.mul(3n, m) + 1n)` where `m` is
  `1n + 1n + p`.
- `collatz_len_six`: `collatz_len(30n, 6n) == 8n`.
- `collatz_len_fifteen`: `collatz_len(30n, 15n) == 17n`.
