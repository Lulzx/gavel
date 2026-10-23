The reference matches on `xs` in both defs: `append` answers `ys` on `Nil{}`
and `h <> append(t, ys)` on a cons; `len` answers `0n` on `Nil{}` and
`1n + len(t)` on a cons.

- `len_cons`, `append_cons`, `append_nil_left`: each closes by `{==}`, since the
  list is a constructor and both defs step.
- `len_append`: induction on `xs`. The `Nil{}` case closes by `{==}`. In the
  cons case the goal is `1n + len(append(t, ys)) == (1n + len(t)) + len(ys)`.
  First rewrite the hypothesis in, flipped with `Equal.sym` so that the
  `len(append(t, ys))` on the left of the hypothesis is the term replaced:

      %Equal.sym(Nat, S.len(S.append(t, ys)), S.len(t) + S.len(ys), L.len_append(t, ys)) : {1n + _ == (1n+S.len(t)) + S.len(ys) : Nat}

  Then reassociate with a `Policy.` lemma `add_assoc(a, -b, -c)`:
  `a + (b + c) == (a + b) + c`, an induction on `a` (erase `b` and `c`), used
  as `%Policy.add_assoc(1n, S.len(t), S.len(ys)) : {1n + (S.len(t) + S.len(ys)) == _ : Nat}`
  before the closing `{==}`.
