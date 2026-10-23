Implement `fib_go` and `fib_list`, then prove the six laws in `LAWS.bend`.

`fib_list(n)` is the list of the first `n` Fibonacci numbers, in order, starting
at `0n`: each number after the first two is the sum of the two before it.

    fib_list(0n) == Nil{}
    fib_list(1n) == [0n]
    fib_list(3n) == [0n, 1n, 1n]
    fib_list(6n) == [0n, 1n, 1n, 2n, 3n, 5n]

`fib_go(k, a, b)` is a list of `k` numbers that starts with `a`, then continues
with the sequence in which `b` follows `a` and each later number is the sum of
the two before it. With `k` equal to `0n` it is empty. `fib_list(n)` is the
case where the sequence starts `0n, 1n`.

    fib_go(3n, 2n, 3n) == [2n, 3n, 5n]
    fib_go(0n, 2n, 3n) == Nil{}

The laws use the prelude's `P.len(xs)`, the number of elements of `xs`.

- `fib_list_zero`: `fib_list(0n)` is the empty list.
- `fib_list_succ`: `fib_list(1n + n)` is `0n` in front of `fib_go(n, 1n, 1n)`.
- `fib_go_zero`: `fib_go(0n, a, b)` is the empty list, whatever `a` and `b` are.
- `fib_go_succ`: `fib_go(1n + k, a, b)` is `a` in front of `fib_go(k, b, a + b)`.
- `fib_go_len`: `fib_go(k, a, b)` has exactly `k` elements, for every `a` and `b`.
- `fib_list_three`: `fib_list(3n)` is `[0n, 1n, 1n]`.
