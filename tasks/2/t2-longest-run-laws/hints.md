The reference matches on the list: `Nil{}` answers `0n`, and `h <> +t` answers
`Nat.max(P.run_len(h <> t), longest_run_len(t))`. The tail is bound `+t` because
it is used twice.

All five laws close by `{==}`, with no lemma and no induction: each argument is
a constructor shape or a closed list, so the match steps and `Nat.max`
computes. For `longest_run_len_single`, `P.run_len` of a one-element list is
`1n`, the recursion on the empty tail is `0n`, and `Nat.max(1n, 0n)` is `1n`.
