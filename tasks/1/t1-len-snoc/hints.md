Both targets match on `xs`. `len` answers `0n` and `1n + len(t)`; `snoc`
answers `x <> Nil{}` and `h <> snoc(t, x)`.

- `len_single` and `snoc_cons` close by `{==}`: the target is applied to a
  literal cons, so it steps.
- `len_snoc` is an induction on `xs`. The `Nil{}` case is `{==}`. In the cons
  case the left side reduces to `1n + S.len(S.snoc(t, x))`; rewrite with the
  hypothesis at `t` (hole in `1n + _`), then `{==}`.
