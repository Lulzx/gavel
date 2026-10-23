The reference matches on the list: `Nil{}` answers `False{}`, and `h <> t`
answers `Bool.or(P.is_mult5_b(h), has_mult5(t))`. `Bool.or` matches on its first
argument, so the head's test goes on the left and the recursion on the right.

- `has_mult5_nil` closes by `{==}`.
- `has_mult5_snoc` is an induction on `xs`, and needs two `Policy.` lemmas about
  `Bool.or`, each proved by a match on the first argument with both cases
  `{==}`: `or_false(b) : Bool.or(b, False{}) == b`, and
  `or_assoc(a, -b, -c) : Bool.or(a, Bool.or(b, c)) == Bool.or(Bool.or(a, b), c)`
  (`b` and `c` are erased `-` parameters).
- `Nil{}` case: both sides are `P.is_mult5_b(x)`, the left with a trailing
  `Bool.or(_, False{})`, so rewrite with `or_false(P.is_mult5_b(x))` then `{==}`.
- `h <> t` case: flip the hypothesis with `Equal.sym` and rewrite the
  right-hand `Bool.or(has_mult5(t), P.is_mult5_b(x))` into the right-hand
  association, then rewrite with
  `or_assoc(P.is_mult5_b(h), has_mult5(t), P.is_mult5_b(x))`, then `{==}`.
