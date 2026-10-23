The reference answers `P.PCons{Nil{}, P.PNil{}}` on `Nil{}` and
`P.PCons{Nil{}, P.cons_all(h, prefixes(t))}` on `h <> t`.

- `prefixes_nil` and `prefixes_cons`: `{==}`.
- `prefixes_len`: induction on `xs`, but the step is about
  `P.llen(P.cons_all(h, S.prefixes(t)))` while the hypothesis is about
  `P.llen(S.prefixes(t))`. First prove a `Policy.` lemma that `P.cons_all` does
  not change the count:

      def Policy.llen_cons_all(x: Nat, ps: P.Prefixes)
          -> {P.llen(P.cons_all(x, ps)) == P.llen(ps) : Nat}:

  by induction on `ps` (patterns `case P.PNil{}:` and `case P.PCons{p, rest}:`),
  rewriting the cons case with the hypothesis at `rest`:
  `{1n + P.llen(P.cons_all(x, rest)) == 1n + _ : Nat}`.

  In the law's cons case the right side stays `1n + P.len(h <> t)`. Rewrite
  twice under the motive `{1n + _ == 1n + P.len(h <> t) : Nat}`: first with the
  lemma at `(h, S.prefixes(t))` flipped by `Equal.sym`, then with the
  hypothesis `L.prefixes_len(t)` flipped, leaving `1n + (1n + P.len(t))`,
  which is what `1n + P.len(h <> t)` computes to; `{==}` closes. `Nil{}` is
  `{==}`.
