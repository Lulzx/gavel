The reference matches on `n`: `0n` gives `Nil{}`, and `1n+k` gives
`x <> replicate(k, x)`. `x` is `+`.

- `replicate_len`: induction on `n`. The step is `1n + P.len(S.replicate(p, x))`
  against `1n + p`; rewrite with the hypothesis flipped by `Equal.sym`
  (`{1n + _ == 1n + p : Nat}`), then `{==}`.
- `replicate_append`: induction on `n` with `m` carried as a parameter.
  `(1n + p) + m` reduces to `1n + (p + m)`, so the left steps to
  `x <> S.replicate(p + m, x)` and the right's `P.append` steps on its cons;
  rewrite the tail with the flipped hypothesis
  (`{x <> _ == x <> P.append(S.replicate(p, x), S.replicate(m, x)) : List<Nat>}`).
- `replicate_single`: `{==}`.
- `rev_replicate`: the step reverses a cons into
  `P.snoc(P.rev(S.replicate(p, x)), x)`, and closing it needs two `Policy.`
  lemmas, both inductions on `n` with `+x` (a law-def's binders are bare, and
  `x` is used twice):
  - `S.replicate(1n + n, x) == P.snoc(S.replicate(n, x), x)`: `0n` is `{==}`;
    in the step rewrite the tail with the flipped hypothesis.
  - `P.rev(S.replicate(n, x)) == S.replicate(n, x)`: write the successor case
    as `case 1n++p:`. Rewrite `P.rev(S.replicate(p, x))` under
    `{P.snoc(_, x) == x <> S.replicate(p, x) : List<Nat>}` with the flipped
    hypothesis, then rewrite the whole left side with the snoc lemma at
    `(p, x)` used bare, then `{==}`.

  The law is one rewrite with the second lemma and `{==}`.
