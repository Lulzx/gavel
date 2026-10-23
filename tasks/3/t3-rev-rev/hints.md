The reference answers `Nil{}` on `Nil{}` and `P.snoc(rev(t), h)` on `h <> t`:
the head goes on the right. Since `P.snoc`, `P.len` and `P.append` all match
on their first argument, and that argument is the opaque `S.rev(t)`, each
law's step needs a `Policy.` lemma, each an induction on `xs`:

- `P.append(xs, Nil{}) == xs`
- `P.len(P.snoc(xs, y)) == 1n + P.len(xs)`
- `P.snoc(P.append(xs, ys), y) == P.append(xs, P.snoc(ys, y))`
- `S.rev(P.snoc(xs, y)) == y <> S.rev(xs)` (its step rewrites the inner
  `S.rev(P.snoc(t, y))` with the flipped hypothesis under
  `{P.snoc(_, h) == y <> P.snoc(S.rev(t), h) : List<&2, Nat>}`).

Every law but `rev_singleton` is an induction on `xs`, with `Nil{}` closing by
`{==}` except where noted. Each rewrite below uses the lemma flipped by
`Equal.sym`:

- `rev_len`: cons case, rewrite the left `P.len(P.snoc(S.rev(t), h))` with the
  snoc-length lemma at `(S.rev(t), h)` to `1n + P.len(S.rev(t))`, then with the
  hypothesis under `{1n + _ == 1n + P.len(t) : Nat}`.
- `rev_append`: `Nil{}` case is `S.rev(ys) == P.append(S.rev(ys), Nil{})`;
  rewrite with the append-nil lemma at `S.rev(ys)` under
  `{S.rev(ys) == _ : ...}`. Cons case: the left is
  `P.snoc(S.rev(P.append(t, ys)), h)`; rewrite the inner reverse with the
  hypothesis, then the whole left side with the snoc-append lemma at
  `(S.rev(ys), S.rev(t), h)`; the right already computes to
  `P.append(S.rev(ys), P.snoc(S.rev(t), h))`.
- `rev_rev`: cons case, the left is `S.rev(P.snoc(S.rev(t), h))`; rewrite it
  with the rev-snoc lemma at `(S.rev(t), h)` to `h <> S.rev(S.rev(t))`, then
  the tail with the hypothesis under `{h <> _ == h <> t : ...}`.
- `rev_singleton`: `{==}`.
