Implement `is_pow2`, then prove the six laws in `LAWS.bend`.

`is_pow2(w, n)` says whether `n` is a power of two (`1n`, `2n`, `4n`, `8n`, ...),
given a budget `w` of halvings. `0n` and non-powers of two give `False{}`. A
power of two `2^j` is recognised only when the budget is large enough, which
means `w` at least `j + 1n`; with a smaller budget the answer is `False{}`. In
particular a budget of `0n` always gives `False{}`.

    is_pow2(3n, 4n) == True{}
    is_pow2(2n, 4n) == False{}
    is_pow2(3n, 6n) == False{}
    is_pow2(4n, 1n) == True{}
    is_pow2(4n, 0n) == False{}

The laws use these prelude names. `P.is_even_b(n)` is `True{}` when `n` is even.
`P.half(n)` is `n` divided by two, rounded down.

- `is_pow2_no_fuel`: `is_pow2(0n, n)` is `False{}`, whatever `n` is.
- `is_pow2_zero`: `is_pow2(w, 0n)` is `False{}`, whatever `w` is.
- `is_pow2_one`: `is_pow2(1n + w, 1n)` is `True{}`.
- `is_pow2_step`: `is_pow2(1n + w, 1n + 1n + q)` is `Bool.and` of
  `P.is_even_b(1n + 1n + q)` and `is_pow2(w, P.half(1n + 1n + q))`: an
  `n` above one qualifies when it is even and its half qualifies with one less
  budget.
- `is_pow2_four`: `is_pow2(3n, 4n)` is `True{}`.
- `is_pow2_six`: `is_pow2(3n, 6n)` is `False{}`.
