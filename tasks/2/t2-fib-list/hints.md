The reference walk `fib_go(k, +a, +b)` matches on `k`: `0n` answers `Nil{}`,
and `1n+kp` answers `a <> fib_go(kp, b, a + b)`. The count comes first because
it is the argument that shrinks. `fib_list(n)` is just `fib_go(n, 0n, 1n)`.

- `fib_list_zero`, `fib_list_succ`, `fib_go_zero`, `fib_go_succ` and
  `fib_list_three` close by `{==}`: the count is a literal or `1n + _`, so the
  match steps, and `fib_list_three` is closed.
- `fib_go_len` is a match on `k` that calls itself on `kp`, with the pair
  slid. `0n` is `{==}`. In `1n+kp` the goal reduces to
  `1n + P.len(fib_go(kp, b, a + b)) == 1n + kp`:

      %L.fib_go_len(kp, b, a + b) : {1n + P.len(S.fib_go(kp, b, a + b)) == 1n + _ : Nat}
      {==}
