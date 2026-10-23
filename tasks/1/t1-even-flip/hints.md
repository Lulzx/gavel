The reference matches on `n`: `0n` answers `True{}`, and `1n+p` answers
`Bool.not(even(p))`.

`even_zero` closes by `{==}`.

`even_flip` needs no induction. `even(1n+x)` steps to `Bool.not(even(x))`, so
the goal is `even(x) == Bool.not(Bool.not(even(x)))`. Prove a `Policy.` lemma
`Policy.not_not(b) : b == Bool.not(Bool.not(b))` by a match on `b` (both
cases `{==}`). Citing it uses `S.even(x)` twice (in the argument and in the
rewrite motive), so first rebind `+e = S.even(x)`, then
`%Policy.not_not(e) : {e == _ : Bool}` and `{==}`.
