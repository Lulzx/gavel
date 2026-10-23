The reference matches on the list: `Nil{}` answers `Nil{}`, and `h <> t`
answers `P.append(reverse(t), h <> Nil{})`.

- `reverse_single`: `{==}`.
- `reverse_snoc`: induction on `xs`. `Nil{}` is `{==}`. In `h <> t` the goal is
  `P.append(reverse(P.snoc(t, x)), h <> Nil{})` against
  `x <> P.append(reverse(t), h <> Nil{})`. The hypothesis says
  `reverse(P.snoc(t, x)) == x <> reverse(t)`, so flip it with `Equal.sym` before
  rewriting; `P.append` then steps on the cons and both sides agree:

      %Equal.sym(List<Nat>, S.reverse(P.snoc(t, x)), x <> S.reverse(t), L.reverse_snoc(t, x)) : {P.append(_, h <> Nil{}) == x <> P.append(S.reverse(t), h <> Nil{}) : List<Nat>}
      {==}
