Implement `half`, then prove the five laws in `LAWS.bend`.

`half(n)` is `n` divided by two, rounded down.

    half(7n) == 3n
    half(8n) == 4n
    half(1n) == 0n
    half(0n) == 0n

The laws use `Nat.double(n)`, which is `n` doubled.

- `half_zero`: `half(0n)` is `0n`.
- `half_one`: `half(1n)` is `0n`.
- `half_step`: `half(1n + (1n + n))` is `1n + half(n)`.
- `half_double`: `half(Nat.double(n))` is `n`.
- `half_double_succ`: `half(1n + Nat.double(n))` is `n`.
