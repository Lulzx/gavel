The reference matches on `xs` and then on `ys`: `Nil{}` on either side answers
`Nil{}`, and two conses answer `P.Mk{hx, hy} <> zip(tx, ty)`.

- `zip_nil_l` and `zip_cons` close by `{==}`.
- `zip_nil_r`: with a variable `xs` the outer match is stuck, so match on `xs`;
  both cases then reduce and close by `{==}`. No hypothesis is needed.
- `zip_len`: the reference proves `Policy.zip_len_general(+xs, +ys)` with the
  law's statement, an induction that follows `zip`'s own two-level match, and
  the law is one rewrite with it then `{==}`. In the general proof, the two
  `Nil{}` cases are `{==}` because `P.min` matches on its first argument and
  then on its second. In the cons-cons case both sides reduce to `1n +`
  something: rewrite with the hypothesis at `(tx, ty)` in the motive
  `{1n + P.zlen(S.zip(tx, ty)) == 1n + _ : Nat}`, then `{==}`. No arithmetic is
  needed.
