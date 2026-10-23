A `match` cannot scrutinise `P.le(h, n)`, so the reference's `filter` defers the
decision to the prelude: `Nil{}` answers `Nil{}`, and `+h <> t` answers
`P.filter_put(h, filter(t, n), P.le(h, n))`, with `n` declared `+`. `len` is
`0n` on `Nil{}` and `1n + len(t)` on a cons.

- `filter_len`: induction on `xs`. `Nil{}` is `{==}`. In the cons case rebind
  `+m = n`; the goal is then
  `S.len(P.filter_put(h, S.filter(t, m), P.le(h, m))) == P.below_put(P.below_count(t, m), P.le(h, m))`,
  with a computed decision. Hand it to a `Policy.` def that takes the decision
  as a parameter:

      def Policy.step(k: Bool, -h: Nat, -r: List<Nat>, -c: Nat, ih: {S.len(r) == c : Nat})
          -> {S.len(P.filter_put(h, r, k)) == P.below_put(c, k) : Nat}:

  matching on `k`: `False{}` returns `ih`; `True{}` rewrites `S.len(r)` with
  `ih` (flipped) under `1n + _` and closes by `{==}`. The law's step is
  `Policy.step(P.le(h, m), h, S.filter(t, m), P.below_count(t, m), L.filter_len(t, m))`.
- `filter_keep`: one rewrite of `P.le(h, h)` to `True{}` with a `Policy.`
  lemma `P.le(a, a) == True{}` (induction on `a`), flipped, in the motive
  `P.filter_put(h, S.filter(t, h), _) == h <> S.filter(t, h)`; then `{==}`.
- `filter_drop`: the same, rewriting `P.le(y, h)` to `False{}` with the
  hypothesis `e` (flipped); then `{==}`.
