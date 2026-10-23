The reference matches on the list: `Nil{}` answers `True{}`, and `h <> t`
answers `Bool.and(P.is_mult3_b(h), all_mult3(t))`.

- `all_mult3_nil`: closes by `{==}`.
- `all_mult3_snoc`: induction on `xs`, and it needs two `Policy.` lemmas about
  `Bool.and`, both a match on the first `Bool` with `{==}` in each case:
  - `and_true(b)`: `Bool.and(b, True{}) == b`.
  - `and_assoc(a, -b, -c)`: `Bool.and(a, Bool.and(b, c)) == Bool.and(Bool.and(a, b), c)`.
    Erase `b` and `c` with `-`.

  In the `Nil{}` case both sides are `P.is_mult3_b(x)`, the left with a trailing
  `Bool.and(_, True{})`, so rewrite with `and_true(P.is_mult3_b(x))`.
  In the `h <> t` case the hypothesis at `t` has `all_mult3(append(t, x <> Nil{}))`
  on its left, where the goal needs it on the right, so flip it with
  `Equal.sym` before rewriting. Then `and_assoc(P.is_mult3_b(h), all_mult3(t),
  P.is_mult3_b(x))` moves the head's test to the front, and `{==}` closes.
