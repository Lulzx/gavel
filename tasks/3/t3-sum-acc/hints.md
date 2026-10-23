The reference matches on `xs`: `Nil{}` answers `a`, and `h <> t` answers
`sum_acc(t, a + h)`.

- `sum_acc_nil` and `sum_acc_cons` close by `{==}`.
- `sum_acc_zero` cannot be proved by an induction of its own: the step needs the
  hypothesis at accumulator `0n + h`, and it is only available at `0n`. The
  generalized statement `sum_acc(xs, a) == a + P.sum(xs)` with `a` free is what
  goes through, and it is `sum_acc_add`.
- The reference proves the generalization once as
  `Policy.sum_acc_general(+xs, +a)`, an induction on `xs`, and both
  `sum_acc_add` and `sum_acc_zero` are a single rewrite with it then `{==}`
  (at `0n`, `0n + P.sum(xs)` computes to `P.sum(xs)`). Proving it as a Policy
  def rather than citing `L.sum_acc_add` keeps `sum_acc_zero` independent of
  another law's credit.
  - `Nil{}`: the goal is `a == a + 0n`; rewrite with
    `Policy.add_zero_right(a)`: `a == a + 0n`.
  - `h <> t`: the goal is `sum_acc(t, a + h) == a + (h + P.sum(t))`. Rewrite the
    left with the hypothesis at `(t, a + h)` (flipped with `Equal.sym`), giving
    `(a + h) + P.sum(t)`, then rewrite the right with
    `Policy.add_assoc(a, -b, -c)`: `a + (b + c) == (a + b) + c`, then `{==}`.

Both arithmetic facts are inductions on `a`.
