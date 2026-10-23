The reference matches on `xs`: `Nil{}` answers `P.MkL{Nil{}, Nil{}}`, and
`h <> t` answers `P.MkL{h <> P.odds(split(t)), P.evens(split(t))}`. The tail is
used twice, so the parameter is `+xs`.

- `split_nil` and `split_cons` close by `{==}`: both sides are the unfolding at a
  constructor.
- `split_len` is an induction on `xs`, written as a `Policy.` def with the law's
  own statement (`Policy.split_len_induction(+xs)`) that the law then uses in
  one rewrite. In the `Nil{}` case both sides are `0n`. In the cons case the
  goal unfolds to `1n + (A + B) == 1n + P.len(t)`, with `A` the length of the
  odd half of `split(t)` and `B` that of the even half, while the hypothesis is
  `B + A == P.len(t)`. So first swap the two with `Policy.add_comm` (rewrite
  under `1n + _`), then rewrite with the hypothesis, then `{==}`.

The arithmetic, each an induction on its first argument:

- `Policy.add_zero_right(a)`: `a + 0n == a`.
- `Policy.add_succ_right(b, -p)`: `b + (1n + p) == 1n + (b + p)`.
- `Policy.add_comm(a, +b)`: `a + b == b + a`, using the two above (the reference
  also defines `add_assoc`, `a + (b + c) == (a + b) + c`, but does not need it).
