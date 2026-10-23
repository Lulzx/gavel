The reference matches on the list: `Nil{}` gives `acc`, and `h <> t` gives
`sum_acc(t, h + acc)`, adding the head into the accumulator before walking the
tail.

- `sum_acc_single`: the left side reduces to `h + 0n`, and `+` is stuck on a
  variable left argument. Prove a `Policy.` lemma `{x + 0n == x : Nat}` by
  induction on `x` (the successor case rewrites with the lemma at `p` under
  `1n +`), then rewrite with it at `h`:

      %Policy.add_zero(h) : {h + 0n == _ : Nat}
      {==}

- `sum_acc_append`: induction on `xs`. `Nil{}` closes by `{==}`. In the cons
  case the goal is `sum_acc(append(t, ys), h + acc)` against
  `sum_acc(ys, sum_acc(t, h + acc))`, which is the hypothesis at `t`, `ys` and
  accumulator `h + acc`:

      %L.sum_acc_append(t, ys, h + acc) : {S.sum_acc(P.append(t, ys), h + acc) == _ : Nat}
      {==}
