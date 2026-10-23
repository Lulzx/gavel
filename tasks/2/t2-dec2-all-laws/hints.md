The reference matches on the list: `Nil{}` answers `Nil{}`, and `h <> t` answers
`P.dec2(h) <> dec2_all(t)`.

- `dec2_all_single`: closes by `{==}`.
- `dec2_all_append`: induction on `xs`; the `Nil{}` case is `{==}`. In the cons
  case both sides are `P.dec2(h)` in front of something, so rewrite with the
  hypothesis at `t` (no flip) and close:

      %L.dec2_all_append(t, ys) : {P.dec2(h) <> S.dec2_all(P.append(t, ys)) == P.dec2(h) <> _ : List<Nat>}
      {==}
