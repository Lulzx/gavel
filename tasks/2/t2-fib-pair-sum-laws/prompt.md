Implement `fib_pair` and `sum_fib`, then prove the five laws in `LAWS.bend`.

`fib_pair(n)` is a `P.Pair` of two consecutive Fibonacci numbers, the earlier
first: the `n`-th Fibonacci number (counting `0n, 1n, 1n, 2n, 3n, 5n, ...` from
index 0) and the one after it.

    fib_pair(0n) == P.MkPair{0n, 1n}
    fib_pair(1n) == P.MkPair{1n, 1n}
    fib_pair(4n) == P.MkPair{3n, 5n}

`sum_fib(n)` is the sum of the first `n` Fibonacci numbers, those at indices
`0` to `n - 1`. It is `0n` for `0n`.

    sum_fib(0n) == 0n
    sum_fib(3n) == 2n
    sum_fib(5n) == 7n

The laws use these prelude names. `P.advance(p)` slides a pair along by one:
`P.MkPair{a, b}` becomes `P.MkPair{b, a + b}`. `P.fst(p)` is the first element
of a pair and `P.snd(p)` the second.

- `fib_pair_zero`: `fib_pair(0n)` is `P.MkPair{0n, 1n}`.
- `fib_pair_succ`: `fib_pair(1n + k)` is `P.advance` applied to `fib_pair(k)`.
- `sum_fib_zero`: `sum_fib(0n)` is `0n`.
- `sum_fib_succ`: `sum_fib(1n + k)` is the first element of `fib_pair(k)` (by `P.fst`)
  plus `sum_fib(k)`.
- `sum_fib_pair`: `sum_fib(n) + 1n` is `P.snd(fib_pair(n))`.
