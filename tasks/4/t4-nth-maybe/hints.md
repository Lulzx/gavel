The reference matches on `k` first and on the list inside each branch: `Nil{}`
answers `None{}` at either index, `0n` with `h <> t` answers `Some{h}`, and
`1n+p` with `h <> t` answers `nth(p, t)`. The list cannot be matched first and
the index second, since nested scrutinees must follow binder order.

- `nth_zero`, `nth_succ`: `{==}`, the index is a constructor.
- `nth_some`: match `k`, then `xs`. On a cons at `0n` it is `{==}`. On a cons
  at `1n+p`, `e`'s type `Nat.is_lt(1n + p, P.len(h <> t)) == True{}` reduces to
  the one at `p` and `t`, so `L.nth_some(p, t, e)` closes it. On `Nil{}` the
  premise has become `{False{} == True{}}`, and the goal follows from it by
  transport: define a `Policy.bool_ite(c, x, y)` that matches on `c`, then
  `Equal.cong(Bool, Bool, c => Policy.bool_ite(c, R, L), False{}, True{}, e)`
  proves `{L == R}` for any `L` and `R`.
- `nth_none`: the same split. On `Nil{}` the premise holds and the goal is
  `{==}`. At `1n+p` on a cons, `L.nth_none(p, t, e)`. At `0n` on a cons the
  premise is `{True{} == False{}}`: flip it with
  `Equal.sym(Bool, True{}, False{}, e)` and transport as above, with a
  `Maybe<&2, Nat>`-valued `ite` since the goal is about a `Maybe`.
