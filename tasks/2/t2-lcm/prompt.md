Implement `lcm_go` and `lcm`, then prove the ten laws in `LAWS.bend`.

`lcm(n, m)` is the least common multiple of `n` and `m`: the smallest positive
number that is a multiple of both. If either argument is `0n` the answer is
`0n`.

    lcm(1n, 1n) == 1n
    lcm(4n, 6n) == 12n
    lcm(6n, 4n) == 12n
    lcm(7n, 3n) == 21n
    lcm(5n, 7n) == 35n
    lcm(0n, 6n) == 0n
    lcm(7n, 0n) == 0n

`lcm_go(fuel, c, step, m)` examines at most `fuel` candidates, the multiples
`c`, `c + step`, `c + step + step`, ... in order. It answers the first
candidate that is a multiple of `m`. If none of the `fuel` candidates is, it
answers the candidate reached when the budget ran out, `c` plus `fuel` steps.
With `fuel` equal to `0n` that is `c`.

    lcm_go(5n, 4n, 4n, 6n)  == 12n
    lcm_go(2n, 5n, 3n, 7n)  == 11n
    lcm_go(0n, 5n, 3n, 7n)  == 5n

The laws use the prelude's `P.divides(a, b)`, which is `True{}` when `b`
divides `a` exactly.

- `lcm_zero_left`: `lcm(0n, m)` is `0n`.
- `lcm_zero_right`: `lcm(n, 0n)` is `0n`.
- `lcm_handoff`: `lcm(1n + n, 1n + m)` is `lcm_go(1n + m, 1n + n, 1n + n, 1n + m)`:
  the candidates start at `n` itself, step by `n`, and number `m`.
- `lcm_go_no_fuel`: `lcm_go(0n, c, step, m)` is `c`.
- `lcm_go_step`: `lcm_go(1n + f, c, step, m)` picks, by the `Bool` `P.divides(c, m)`
  through `Bool.pick(Nat, ...)`, between `c` (when it is `True{}`) and
  `lcm_go(f, c + step, step, m)` (when it is `False{}`).
- `lcm_one_one`: `lcm(1n, 1n)` is `1n`.
- `lcm_four_six`: `lcm(4n, 6n)` is `12n`.
- `lcm_six_four`: `lcm(6n, 4n)` is `12n`.
- `lcm_seven_three`: `lcm(7n, 3n)` is `21n`.
- `lcm_five_seven`: `lcm(5n, 7n)` is `35n`.
