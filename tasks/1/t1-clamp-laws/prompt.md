Implement `clamp`, then prove the three laws in `LAWS.bend`.

`clamp(x, lo, hi, klo, khi)` is `x` held inside the range from `lo` to `hi`.
The two `Bool` arguments are decisions the caller has already taken: `klo` is
`P.le(x, lo)`, so it is `True{}` when `x` is at most `lo`, and `khi` is
`P.le(hi, x)`, so it is `True{}` when `hi` is at most `x`. The answer is `lo`
when `klo` is `True{}`. Otherwise it is `hi` when `khi` is `True{}`, and `x`
when `khi` is `False{}`. The function reads only the two decisions, never `x`,
`lo` or `hi` themselves, to choose the branch.

    clamp(1n, 2n, 6n, True{}, False{}) == 2n
    clamp(9n, 2n, 6n, False{}, True{}) == 6n
    clamp(5n, 2n, 6n, False{}, False{}) == 5n

`P.le(a, b)` is `True{}` when `a` is at most `b`. The laws do not use it.

- `clamp_below`: when `klo` is `True{}` the answer is `lo`, whatever `khi` is.
- `clamp_above`: when `klo` is `False{}` and `khi` is `True{}` the answer is
  `hi`.
- `clamp_inside`: when both decisions are `False{}` the answer is `x`.
