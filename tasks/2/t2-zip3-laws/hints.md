The reference matches on `xs`, then `ys`, then `zs`: any `Nil{}` gives `Nil{}`,
and three conses give `(h1 + h2 + h3) <> zip3(t1, t2, t3)`.

- `zip3_nil_left` and `zip3_cons`: close by `{==}`.
- `zip3_nil_mid`: the first match is on `xs`, so match `xs`; both cases close by
  `{==}`.
- `zip3_nil_right`: match `xs`, and for `h1 <> t1` match `ys`; every case closes
  by `{==}`.
- `zip3_len`: match `xs`, then `ys`, then `zs`, and use the hypothesis in the
  all-cons case. `P.min3` steps through all three arguments in the same order.
  Every case with a `Nil{}` closes by `{==}`. In the all-cons case both sides
  reduce to `1n + ...`, and the hypothesis at `(t1, t2, t3)` covers the rest:

      %L.zip3_len(t1, t2, t3) : {1n + P.len(S.zip3(t1, t2, t3)) == 1n + _ : Nat}
      {==}
