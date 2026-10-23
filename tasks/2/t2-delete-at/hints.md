The reference matches on `n` and, inside each case, on the list: at `0n`,
`Nil{}` answers `Nil{}` and `h <> t` answers `t`; at `1n+p`, `Nil{}` answers
`Nil{}` and `h <> t` answers `h <> delete_at(p, t)`.

- `delete_at_zero` and `delete_at_succ`: close by `{==}`.
- `delete_at_nil`: match on `n`; both cases close by `{==}` (the inner match on
  the `Nil{}` list answers `Nil{}` at either count). No hypothesis.
- `delete_at_take_drop`: induction on `n` with a match on `xs` in each case.
  The `0n` case (both list shapes) and the `1n+p`/`Nil{}` case close by `{==}`.
  In the `1n+p` / `h <> t` case the head survives on both sides, and the
  hypothesis at `p` and `t` has `delete_at(p, t)` on its left, so flip it with
  `Equal.sym`:

      %Equal.sym(List<Nat>, S.delete_at(p, t), P.append(P.take(p, t), P.drop(1n, P.drop(p, t))), L.delete_at_take_drop(p, t)) : {h <> _ == h <> P.append(P.take(p, t), P.drop(1n, P.drop(p, t))) : List<Nat>}
      {==}
