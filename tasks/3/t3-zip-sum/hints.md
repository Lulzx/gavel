The reference matches on `xs` and then on `ys`: `Nil{}` on either side answers
`Nil{}`, and two conses answer `(h1 + h2) <> zip_sum(t1, t2)`.

- `zip_sum_nil_left` and `zip_sum_cons` close by `{==}`.
- `zip_sum_nil_right`: the outer match is stuck on the variable `xs`, so match on
  `xs`; both cases then close by `{==}`.
- `zip_sum_len`: an induction following `zip_sum`'s match, on `xs` and then on
  `ys`. The two `Nil{}` cases are `{==}`, since `P.min` steps on its first
  argument and then its second. In the cons-cons case rewrite with the
  hypothesis `L.zip_sum_len(t1, t2)`, flipped with `Equal.sym`, in the motive
  `{1n + _ == P.min(P.len(h1 <> t1), P.len(h2 <> t2)) : Nat}`, then `{==}`; the
  right side steps through two successors to the same term.
- `zip_sum_self`: an induction on `xs`. The cons case is
  `(h + h) <> S.zip_sum(t, t) == (h + h) <> P.double_all(t)`; rewrite with the
  hypothesis at `t`, flipped, then `{==}`. The hypothesis is the only live use
  of `t`.
