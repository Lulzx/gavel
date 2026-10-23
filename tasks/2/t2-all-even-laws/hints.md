The reference matches on the list: `Nil{}` answers `True{}`, and `h <> t`
answers `Bool.and(P.is_even_b(h), all_even(t))`.

- `all_even_nil`: closes by `{==}`.
- `all_even_snoc`: induction on `xs`, and it needs two `Policy.` lemmas about
  `Bool.and`, both a match on the first `Bool` with `{==}` in each case:
  - `and_true(b)`: `Bool.and(b, True{}) == b`.
  - `and_assoc(a, -b, -c)`: `Bool.and(a, Bool.and(b, c)) == Bool.and(Bool.and(a, b), c)`.
    Erase `b` and `c` with `-`.

  In the `Nil{}` case both sides are `P.is_even_b(x)`, the left with a trailing
  `Bool.and(_, True{})`, so rewrite with `and_true(P.is_even_b(x))`.
  In the `h <> t` case the hypothesis at `t` has `all_even(append(t, x <> Nil{}))`
  on its left, where the goal needs it on the right, so flip it with
  `Equal.sym` before rewriting. Then `and_assoc(P.is_even_b(h), all_even(t),
  P.is_even_b(x))` moves the head's test to the front, and `{==}` closes.
