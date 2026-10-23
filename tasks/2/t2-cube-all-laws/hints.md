The reference matches on the list: `Nil{}` answers `Nil{}`, and `h <> t` answers
`P.cube(h) <> cube_all(t)`.

- `cube_all_single`: closes by `{==}`.
- `cube_all_append`: induction on `xs`; the `Nil{}` case is `{==}`. In the cons
  case both sides are `P.cube(h)` in front of something, so rewrite with the
  hypothesis at `t` (no flip) and close:

      %L.cube_all_append(t, ys) : {P.cube(h) <> S.cube_all(P.append(t, ys)) == P.cube(h) <> _ : List<Nat>}
      {==}
