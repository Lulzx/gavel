Implement `gcd`, then prove the four laws in `LAWS.bend`.

`gcd(fuel, a, b)` is Euclid's algorithm with a step budget `fuel`: while the
divisor `b` is not `0n`, replace `(a, b)` by `(b, a mod b)`, spending one unit
of `fuel` per step. When `b` is `0n` the answer is `a`. When the fuel runs out
the answer is the current `a`. With enough fuel it is the greatest common
divisor of `a` and `b`.

    gcd(30n, 12n, 18n) == 6n
    gcd(30n, 9n, 6n)   == 3n
    gcd(5n, 7n, 0n)    == 7n
    gcd(0n, 12n, 18n)  == 12n

The prelude adds nothing: the laws use `Base`'s `Nat.mod`.

- `gcd_no_fuel`: `gcd(0n, a, b)` is `a`.
- `gcd_zero_divisor`: `gcd(f, a, 0n)` is `a`, for any fuel `f`.
- `gcd_step`: `gcd(1n + f, a, 1n + b)` is `gcd(f, 1n + b, Nat.mod(a, 1n + b))`.
- `gcd_twelve_eighteen`: `gcd(30n, 12n, 18n)` is `6n`.
