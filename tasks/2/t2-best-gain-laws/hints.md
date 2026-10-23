The reference matches on the list: `Nil{}` answers `0n`, and `h <> +t` answers
`Nat.max(P.max_sub(h, t), best_gain(t))`. The tail is read twice, so bind it
`+t` and type the list `List<&2, Nat>`.

- `best_gain_nil`, `best_gain_single`, `best_gain_cons`: close by `{==}`.
  For the singleton, `P.max_sub(x, Nil{})` and `best_gain(Nil{})` are both `0n`
  and `Nat.max(0n, 0n)` reduces.
- `best_gain_pair`: the goal reduces to `Nat.max(Nat.sub(b, a), 0n)` against
  `Nat.sub(b, a)`, stuck on the variables. A `Policy.` lemma `max_zero(a)`:
  `a == Nat.max(a, 0n)`, by a match on `a` with `{==}` in both cases, applied at
  `Nat.sub(b, a)`. Use it twice with goal
  `{Nat.max(_, 0n) == Nat.sub(b, a) : Nat}` then `{_ == Nat.sub(b, a) : Nat}`,
  then `{==}`. Declare `+a` and `+b`.
