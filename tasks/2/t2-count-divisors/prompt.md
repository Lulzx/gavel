Implement `cd_go` and `count_divisors`, then prove the six laws in `LAWS.bend`.

`cd_go(n, k)` counts how many of the numbers `1n, 2n, ..., k` divide `n`. With
`k = 0n` there is nothing to test and the count is `0n`.

`count_divisors(n)` is the number of positive numbers that divide `n`, including
`1n` and `n` itself. For `n = 0n` it is `0n`.

    count_divisors(1n) == 1n
    count_divisors(7n) == 2n
    count_divisors(12n) == 6n
    cd_go(12n, 6n) == 5n

The prelude's `P.divides(a, b)` is `True{}` when `b` divides `a` exactly and
`False{}` otherwise. `Bool.pick(Nat, b, x, y)` is `x` when `b` is `True{}` and
`y` when it is `False{}`.

- `cd_go_zero`: `cd_go(n, 0n)` is `0n`, for every `n`.
- `cd_go_step`: `cd_go(n, 1n + k)` is `1n` or `0n` according to whether
  `P.divides(n, 1n + k)` is `True{}` or `False{}` (`Bool.pick(Nat, P.divides(n, 1n + k), 1n, 0n)`),
  added to `cd_go(n, k)`.
- `count_divisors_handoff`: `count_divisors(n)` is `cd_go(n, n)`.
- `count_divisors_one`: `count_divisors(1n) == 1n`.
- `count_divisors_seven`: `count_divisors(7n) == 2n`.
- `count_divisors_twelve`: `count_divisors(12n) == 6n`.
