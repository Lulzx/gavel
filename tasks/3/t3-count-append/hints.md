The reference matches on the list: `Nil{}` answers `0n` and `h <> t` answers
`P.is_eq(x, h) + count(x, t)`. `x` is used twice, so it is `+x` (the stub
already says so).

- `count_nil` and `count_cons`: both sides compute, so `{==}`.
- `count_self`: the left side is `P.is_eq(x, x) + 0n`. Two `Policy.` lemmas:
  `P.is_eq(x, x) == 1n` by induction on `x` (the successor case steps to
  `P.is_eq(p, p)` and is the hypothesis), and `a == a + 0n` by induction on
  `a`. Rewrite the indicator to `1n` with the first (flipped with `Equal.sym`),
  then `1n + 0n` with `add_zero_right(1n)`, and close by `{==}`.
- `count_append`: induction on `xs`. `Nil{}` is `{==}`. In the cons case rebind
  `+x = x`, rewrite `S.count(x, P.append(t, ys))` with the hypothesis
  `L.count_append(x, t, ys)` (flipped), which leaves
  `P.is_eq(x, h) + (S.count(x, t) + S.count(x, ys))` against
  `(P.is_eq(x, h) + S.count(x, t)) + S.count(x, ys)`. Close it with a `Policy.`
  lemma `a + (b + c) == (a + b) + c`, by induction on `a`, whose `b` and `c`
  are **erased** (`-b: Nat, -c: Nat`). The tail `t` has already had its one
  live use in the hypothesis; passing it to an erased position is free, while
  rebinding `+t = t` fails with `expected : Data, observed : Type`.
