The reference matches on `n`: `0n` gives `Nil{}`, and `1n+p` gives
`P.append(xs, nappend(xs, p))`. `xs` is `+` because it is used twice.

- `nappend_zero` and `nappend_succ`: both sides compute, so `{==}`.
- `nappend_len` needs the length of an append, which is not definitional
  because `P.append` matches on its first argument. Prove as `Policy.` lemmas:
  - `a + (b + c) == (a + b) + c`, induction on `a`.
  - `P.len(P.append(xs, ys)) == P.len(xs) + P.len(ys)`, induction on `xs`. In
    the cons case rewrite with the hypothesis (flipped by `Equal.sym`) to get
    `1n + (P.len(t) + P.len(ys))`, then regroup to
    `(1n + P.len(t)) + P.len(ys)` with associativity at `(1n, P.len(t), P.len(ys))`
    (flipped).
  - The law itself as `Policy.nappend_len(+xs, n)`, induction on `n` with the
    successor case written `case 1n++p:` since `p` is used twice. Rewrite
    `P.len(P.append(xs, S.nappend(xs, p)))` with the append-length lemma
    (flipped), then `P.len(S.nappend(xs, p))` with the hypothesis (flipped);
    the right side `(1n + p) * P.len(xs)` reduces to
    `P.len(xs) + p * P.len(xs)`, so `{==}` closes.

  No generalization is needed: `xs` is carried unchanged. `L.nappend_len` is
  one rewrite with that lemma and `{==}`.
