The reference matches on `xs`: `Nil{}` answers `0n`, and `h <> t` answers
`P.is_zero(h) + count_zeros(t)`.

`count_zeros_nil` closes by `{==}`.

`count_zeros_snoc` is an induction on `xs` and needs two `Policy.` lemmas, both
inductions on their first argument. Mark `b` and `c` as erased (`-b`, `-c`) in
the second.

- `Policy.add_zero(x)`: `x + 0n == x`.
- `Policy.add_assoc(a, b, c)`: `a + (b + c) == (a + b) + c`.

In the `Nil{}` case both sides are `P.is_zero(x)`, the left with a trailing
`+ 0n`; rewrite with `Policy.add_zero(P.is_zero(x))`, then `{==}`. In the cons
case the hypothesis `L.count_zeros_snoc(t, x)` has `count_zeros(append(t, x <>
Nil{}))` on its left, which is where the goal has it, so flip it with
`Equal.sym` before rewriting. The goal is then
`P.is_zero(h) + (count_zeros(t) + P.is_zero(x))` against
`(P.is_zero(h) + count_zeros(t)) + P.is_zero(x)`, and a rewrite with
`Policy.add_assoc(P.is_zero(h), S.count_zeros(t), P.is_zero(x))` aligns them.
