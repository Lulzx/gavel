Implement `cmp`, then prove the six laws in `LAWS.bend`.

`cmp(a, b)` compares two natural numbers and answers a `P.Tri`: `P.Lt{}` when `a`
is below `b`, `P.Eq{}` when they are equal, and `P.Gt{}` when `a` is above `b`.

    cmp(2n, 5n) == P.Lt{}
    cmp(4n, 4n) == P.Eq{}
    cmp(5n, 2n) == P.Gt{}
    cmp(0n, 0n) == P.Eq{}

The prelude's `P.flip(t)` swaps `P.Lt{}` and `P.Gt{}` and leaves `P.Eq{}` alone.

- `cmp_zero_zero`: `cmp(0n, 0n)` is `P.Eq{}`.
- `cmp_zero_succ`: `cmp(0n, 1n + k)` is `P.Lt{}`.
- `cmp_succ_zero`: `cmp(1n + k, 0n)` is `P.Gt{}`.
- `cmp_succ_succ`: `cmp(1n + a, 1n + b)` is `cmp(a, b)`.
- `cmp_self`: `cmp(a, a)` is `P.Eq{}`.
- `cmp_antisym`: `cmp(a, b)` is `P.flip` of `cmp(b, a)`.
