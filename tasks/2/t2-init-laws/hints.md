The reference matches on the list, then on its tail: `Nil{}` answers `Nil{}`;
`h <> t` with `t` being `Nil{}` answers `Nil{}`; `h <> t` with `t` being
`h2 <> t2` answers `h <> init(h2 <> t2)`.

- `init_nil` and `init_single` close by `{==}`.
- `init_snoc` is an induction on `xs`, with a split on the tail `t` in the cons
  case, since the inner match in `init` is stuck on a variable `t`. `Nil{}` is
  `{==}`, and so is `t = Nil{}` (a one-element list). For `t = h2 <> t2`,
  rewrite with the hypothesis at `h2 <> t2`, then `{==}`:

      %L.init_snoc(h2 <> t2, x) : {h <> S.init(P.append(h2 <> t2, x <> Nil{})) == h <> _ : List<Nat>}
      {==}
