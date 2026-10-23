Implement `no_divisor` and `is_prime`, then prove the ten laws in `LAWS.bend`.

`is_prime(n)` is `True{}` when `n` is a prime number: at least `2n`, with no
divisor other than `1n` and itself. `0n` and `1n` are not prime.

    is_prime(0n)  == False{}
    is_prime(1n)  == False{}
    is_prime(2n)  == True{}
    is_prime(9n)  == False{}
    is_prime(13n) == True{}

`no_divisor(n, k)` is `True{}` when none of the numbers `2n`, `3n`, ..., `k`
divides `n`. When `k` is `0n` or `1n` there are no such numbers, so the answer
is `True{}`.

    no_divisor(12n, 3n) == False{}
    no_divisor(7n, 6n)  == True{}
    no_divisor(9n, 2n)  == True{}
    no_divisor(9n, 1n)  == True{}

The laws use two prelude names. `P.divides(a, b)` is `True{}` when `b` divides
`a` exactly. `Bool.not` and `Bool.and` come from `Base`.

- `no_divisor_zero`: `no_divisor(n, 0n)` is `True{}`.
- `no_divisor_one`: `no_divisor(n, 1n)` is `True{}`.
- `no_divisor_step`: `no_divisor(n, 2n + j)` is `Bool.and` of
  `Bool.not(P.divides(n, 2n + j))` and `no_divisor(n, 1n + j)`: the candidate
  does not divide `n`, and no smaller candidate does.
- `is_prime_handoff`: `is_prime(2n + n)` is `no_divisor(2n + n, 1n + n)`: for
  `n` at least two, only the candidates below `n` are tested.
- `is_prime_zero`: `is_prime(0n)` is `False{}`.
- `is_prime_one`: `is_prime(1n)` is `False{}`.
- `is_prime_two`: `is_prime(2n)` is `True{}`.
- `is_prime_four`: `is_prime(4n)` is `False{}`.
- `is_prime_seven`: `is_prime(7n)` is `True{}`.
- `is_prime_nine`: `is_prime(9n)` is `False{}`.
