The reference matches on `xs`, then on `ys`: either being `Nil{}` gives `Nil{}`,
and `h1 <> t1` with `h2 <> t2` gives `P.max(h1, h2) <> zip_with(t1, t2)`.

- `zip_with_nil_left` and `zip_with_cons`: close by `{==}`.
- `zip_with_nil_right`: the first match is on `xs`, so match `xs`; both cases
  (`Nil{}` and `h <> t`) close by `{==}`.
- `zip_with_len`: induction on `xs`, then a match on `ys`. `P.min` also steps on
  both arguments. The `Nil{}` cases close by `{==}`. In the `h1 <> t1`,
  `h2 <> t2` case both sides reduce to `1n + ...`; flip the hypothesis at
  `(t1, t2)` with `Equal.sym` and rewrite:

      %Equal.sym(Nat, P.len(S.zip_with(t1, t2)), P.min(P.len(t1), P.len(t2)), L.zip_with_len(t1, t2)) : {1n + _ == 1n + P.min(P.len(t1), P.len(t2)) : Nat}
      {==}

- `zip_with_self`: induction on `xs`, needing a `Policy.` lemma
  `{P.max(x, x) == x : Nat}` (a match on `x`; the successor step flips the
  hypothesis at `p` with `Equal.sym` under `1n +`). `Nil{}` closes by `{==}`. In
  the cons case, two rewrites, both flipped with `Equal.sym`: the lemma at `h`
  to turn `P.max(h, h)` into `h`, then the hypothesis at `t` to turn
  `zip_with(t, t)` into `t`, then `{==}`.
