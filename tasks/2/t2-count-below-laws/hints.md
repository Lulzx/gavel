The reference matches on `xs` in both defs: `Nil{}` answers `0n`, and `h <> t`
answers `P.cb_put(count_below(x, t), P.le(h, x))` (and `P.ca_put(...)` for
`count_above`). `P.cb_put(r, k)` adds one when `k` is `True{}`; `P.ca_put` adds
one when `k` is `False{}`. The decision goes through them because a match cannot
scrutinise `P.le(h, x)`. `x` is read twice, so declare `+x`.

- `count_below_nil`: closes by `{==}`.
- `count_below_keep` and `count_below_drop`: the premise `e` is
  `P.le(h, x) == True{}` (or `False{}`), and the goal needs that literal where
  the comparison sits, so flip it with `Equal.sym` and rewrite, then `{==}`:

      %Equal.sym(Bool, P.le(h, x), True{}, e) : {P.cb_put(S.count_below(x, t), _) == 1n + S.count_below(x, t) : Nat}
      {==}

- `count_below_split`: induction on `xs`. `Nil{}` is `{==}`. The cons case is a
  `Policy.split_step(+t, x, cb, ca, k, ih)` lemma taking the comparison as a
  `Bool` parameter `k` and the tail hypothesis `ih : cb + ca == P.len(t)` as
  an argument, concluding `P.cb_put(cb, k) + P.ca_put(ca, k) == 1n + P.len(t)`.
  It matches on `k`. On `True{}`, `(1n + cb) + ca` already steps, so rewrite
  with `Equal.sym` of `ih` and close by `{==}`. On `False{}` the sum is
  `cb + (1n + ca)`, which is stuck, so first rewrite with a second lemma
  `add_succ_right(a, b)`: `1n + (a + b) == a + (1n + b)` (induction on `a`,
  rewriting with the hypothesis at the predecessor), then proceed as before.
  The law calls the lemma at `P.le(h, x)` and `L.count_below_split(t, x)`.
