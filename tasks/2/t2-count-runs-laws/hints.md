The reference matches on the list, then on its tail: `Nil{}` answers `0n`,
`h <> Nil{}` answers `1n`, and `h <> (h2 <> t2)` answers
`P.nsub(1n, P.is_eq(h, h2)) + count_runs(h2 <> t2)`. The step adds the
decision rather than branching on it, since a match cannot scrutinise a call.
`h2` is used twice, so bind it `+h2`.

- `count_runs_nil`, `count_runs_single`: close by `{==}`.
- `count_runs_same`: `P.is_eq(a, a)` is stuck on a variable, so a `Policy.`
  lemma `is_eq_refl(a)`: `1n == P.is_eq(a, a)`, an induction on `a` (the step
  rewrites with the hypothesis, goal `{1n == _ : Nat}`). Then
  `%Policy.is_eq_refl(a) : {P.nsub(1n, _) + S.count_runs(a <> t) == S.count_runs(a <> t) : Nat}`
  and `{==}`, since `P.nsub(1n, 1n)` is `0n`.
- `count_runs_diff`: the premise `e : P.is_eq(a, b) == 0n` is flipped with
  `Equal.sym` so the `0n` replaces the comparison, then `{==}`:

      %Equal.sym(Nat, P.is_eq(a, b), 0n, e) : {P.nsub(1n, _) + S.count_runs(b <> t) == 1n + S.count_runs(b <> t) : Nat}
      {==}
