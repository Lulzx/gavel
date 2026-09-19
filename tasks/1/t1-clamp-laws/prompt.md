Implement `clamp`, then prove all three laws.

`clamp(x, lo, hi, klo, khi)` answers `x` held inside the range from `lo` up to
`hi`. `klo` is the decision `P.le(x, lo)` -- `True{}` when the value is at or
below the lower bound -- and `khi` is the decision `P.le(hi, x)` -- `True{}`
when the value is above the upper bound. The answer is `lo` when `klo` is
`True{}`, and otherwise `hi` when `khi` is `True{}` and `x` when it is not. So
with `lo = 2n` and `hi = 6n`, the answers are `2n` for `x = 1n`, `6n` for
`x = 9n` and `5n` for `x = 5n`.

The two decisions arrive as arguments rather than being computed in the body,
because a `match` cannot take a **computed** comparison as its scrutinee: with
`x`, `lo` and `hi` variables, `P.le(x, lo)` is stuck, so the body would have
nothing to case-split on. `P.le` is the prelude's and is immutable; it is the
comparison a caller takes the two decisions from, and it is named in each law
only through them.

Each argument is read exactly once, in one branch or as a scrutinee, so none of
them needs `+`.

Each law hands one branch's decision in as a literal, so both sides are the same
term once the cascade takes its case. `clamp_below` fixes the first test
answering `True{}` and answers the lower bound; it quantifies over `khi`, which
says the second decision does not matter on that branch. `clamp_above` fixes the
first test failing and the second passing, and answers the upper bound;
`clamp_inside` fixes both failing and answers the value itself. `clamp_inside`
is what stops a body that answered a bound on the branch that should have
returned the value.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.clamp_below(x, lo, hi, khi)`, `def L.clamp_above(x, lo, hi)` and
`def L.clamp_inside(x, lo, hi)`. Every law's proof is `{==}`: there is no
induction and no rewriting.
