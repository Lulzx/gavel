The reference has three functions, each with `d` reusable (`+d`).
`zl_pad_left(ys, d)` matches on `ys`: `Nil{}` gives `Nil{}`, and `h <> t` gives
`P.MkPair{d, h} <> zl_pad_left(t, d)`. `zl_pad_right` is the same with the pair
`P.MkPair{h, d}`. `zip_longest(xs, ys, d)` matches on `xs`, then on `ys`:
`Nil{}` hands `ys` to `zl_pad_left`; `hx <> tx` with `Nil{}` gives
`P.MkPair{hx, d} <> zl_pad_right(tx, d)`; and `hx <> tx` with `hy <> ty` gives
`P.MkPair{hx, hy} <> zip_longest(tx, ty, d)`. Splitting the padding into two
functions is what keeps every self-call on the list its own function matches.

All eleven laws close by `{==}`: each names the constructors its matches need,
or is a closed term.
