The reference matches on both arguments at once: `0n 0n` is `0n`, `0n 1n+bp`
is `1n+bp`, `1n+ap 0n` is `1n+ap`, and `1n+ap 1n+bp` is `1n+max(ap, bp)`.

- `max_self`: induction on `x`. `0n` is `{==}`. In `1n+p` the call unfolds to
  `1n+max(p, p)`; rewrite with the hypothesis at `p`, then `{==}`:
  `%L.max_self(p) : {1n+S.max(p, p) == 1n+_ : Nat}`.
- `max_comm`: match on `x`, and inside each case on `y`. The three cases with a
  zero are `{==}`. In `1n+p` / `1n+q` both sides are `1n + max`; rewrite with
  `L.max_comm(p, q)` and close with `{==}`.
- `max_zero_left`: not definitional with `y` a variable, so match on `y`; both
  cases are `{==}`.
- `max_succ_succ`: `{==}`, since both arguments are successors.
