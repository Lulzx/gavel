The reference matches on the list: `Nil{}` gives `Nil{}`, and `+h <> +t` gives
`P.keep_if(P.le(P.len(h <> t), k), h <> t, take_last(t, k))`. The decision is
computed outside the match because a `match` cannot scrutinise a call, which is
why `P.keep_if` exists. `k`, `h` and `t` are used more than once, so they are
reusable (`+k`, `+h`, `+t`).

`take_last_nil`, `take_last_step`, `take_last_three` and `take_last_all` close
by `{==}`.

- `take_last_single`: the decision is `P.le(1n + 0n, 1n + k)`, which steps to
  `P.le(0n, k)` and is then stuck on the variable `k`.
  Prove a `Policy.` lemma `{True{} == P.le(0n, k) : Bool}` by a match on `k`
  (both cases `{==}`), rewrite with it at `k`, then `{==}`.
- `take_last_zero`: induction on `xs`. `Nil{}` closes by `{==}`. In the cons
  case the length of a cons is a successor against `0n`, so `P.le` answers
  `False{}` at once, `P.keep_if` picks the tail, and the hypothesis at `t`
  finishes: `%L.take_last_zero(t) : {S.take_last(t, 0n) == _ : List<&2, Nat>}`.
- `take_last_long`: match on `xs`. `Nil{}` closes by `{==}`. For `h <> t`, the
  hypothesis `e` has its sides the wrong way round for a rewrite; a `Policy.`
  lemma flips it, `{True{} == P.le(P.len(xs), k) : Bool}`, proved by rewriting
  with `e` and `{==}`. Rewrite with it at `h <> t`, so `P.keep_if` sees
  `True{}`, then `{==}`.
