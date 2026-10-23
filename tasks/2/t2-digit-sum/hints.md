The signature `digit_sum(w: Nat, +n: Nat)` is forced. The width must come first
because it is the argument that shrinks: the number is divided by ten, which is
a computed term and not a subterm, so it cannot be the decreasing argument. `n`
is used twice in the successor branch (`Nat.mod` and `Nat.div`), hence `+n`.

The reference matches on `w`: `0n` answers `0n`, and `1n+p` answers
`Nat.mod(n, 10n) + digit_sum(p, Nat.div(n, 10n))`.

All four laws close by `{==}`:

- `digit_sum_no_fuel`: the width is the literal `0n`, so the match takes its
  first case.
- `digit_sum_step`: the width is `1n + w`, so the match steps into the successor
  case with `p` bound to `w`, and both sides are the same term.
- `digit_sum_123` and `digit_sum_thousand`: both sides are closed, so the walk
  just computes.
