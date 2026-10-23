Implement `divmod3`, then prove the five laws in `LAWS.bend`.

`divmod3(n)` divides `n` by three and returns a `P.Pair` of quotient and
remainder: `P.MkPair{q, r}` with `n = 3*q + r` and `r < 3`.

    divmod3(7n) == P.MkPair{2n, 1n}
    divmod3(2n) == P.MkPair{0n, 2n}
    divmod3(9n) == P.MkPair{3n, 0n}

The laws use these prelude names. `P.shift(p)` adds one to the quotient of the
pair `p` and leaves its remainder alone. `P.snd(p)` is the remainder of `p`.

- `divmod3_zero`: `divmod3(0n)` is `P.MkPair{0n, 0n}`.
- `divmod3_one`: `divmod3(1n)` is `P.MkPair{0n, 1n}`.
- `divmod3_two`: `divmod3(2n)` is `P.MkPair{0n, 2n}`.
- `divmod3_succ3`: `divmod3(3n + k)` is `P.shift` applied to `divmod3(k)`: one more
  in the quotient, the same remainder.
- `divmod3_rem`: the remainder of `divmod3(n)` is always below `3n`, that is
  `Nat.is_lt(P.snd(divmod3(n)), 3n)` is `True{}`.
