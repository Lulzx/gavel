The reference answers `Nil{}` on `Nil{}` and, on `P.Mk{v, k} <> t`,
`P.append(P.repeat(v, k), expand(t))`.

- `expand_nil` and `expand_cons`: `{==}`.
- `expand_len` needs three `Policy.` lemmas:
  - `a + (b + c) == (a + b) + c`, induction on `a`.
  - `P.len(P.append(xs, ys)) == P.len(xs) + P.len(ys)`, induction on `xs`: the
    cons case rewrites with the flipped hypothesis to
    `1n + (P.len(t) + P.len(ys))`, then regroups with associativity at
    `(1n, P.len(t), P.len(ys))` (flipped).
  - `P.len(P.repeat(x, k)) == k`, induction on `k` with `case 1n++p:`; rewrite
    under `{1n + _ == 1n + p : Nat}` with the flipped hypothesis.

  The law itself is proved as `Policy.expand_len(rs)`, induction on `rs` with
  the cons pattern `case P.Mk{+v, +k} <> +t:` (each is used twice). The left
  is `P.len(P.append(P.repeat(v, k), S.expand(t)))` and the right
  `k + P.sum_k(t)`. Rewrite three times, each lemma flipped by `Equal.sym`:
  the append-length lemma (`{_ == k + P.sum_k(t) : Nat}`), then the
  repeat-length lemma (`{_ + P.len(S.expand(t)) == k + P.sum_k(t) : Nat}`),
  then the hypothesis at `t` (`{k + _ == k + P.sum_k(t) : Nat}`); then `{==}`.
  `L.expand_len` is one rewrite with that lemma and `{==}`.

Write motives in the reduced form the goal has reached, with the fields, not
the `P.Mk{...}` application.
