The reference matches on `xss`: `Nil{}` answers `Nil{}` and `h <> t` answers
`P.append(h, concat(t))`.

`P.append` matches on its first argument, so the arithmetic needs `Policy.`
lemmas, each an induction on its first argument:

- `P.append(xs, Nil{}) == xs` (rewrite the tail with the hypothesis).
- `a + (b + c) == (a + b) + c`, with `b` and `c` erased.
- `P.len(P.append(xs, ys)) == P.len(xs) + P.len(ys)`, `ys` erased: the cons
  case rewrites with the hypothesis at `t`, then with `add_assoc(1n, ...)`.
- `P.sum(P.append(xs, ys)) == P.sum(xs) + P.sum(ys)`: the same, with
  `add_assoc(h, ...)`.

The laws:

- `concat_len`: induction on `xss`. `Nil{}` is `{==}`. In the cons case the left
  side is `P.len(P.append(h, S.concat(t)))`; rewrite it with the length lemma
  at `(h, S.concat(t))` (flipped), then rewrite `P.len(S.concat(t))` with the
  hypothesis `L.concat_len(t)` (flipped), and close by `{==}`.
- `concat_sum`: the same induction with the sum lemma and `L.concat_sum(t)`.
- `concat_single`: the left side unfolds to `P.append(xs, Nil{})`; one rewrite
  with the right-identity lemma (flipped), then `{==}`.
- `concat_cons`: the match steps on the cons, so `{==}`.
