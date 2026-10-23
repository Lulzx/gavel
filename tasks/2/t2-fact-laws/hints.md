The reference `fact` matches on `n`: `0n` answers `1n`, and the pattern `1n++p`
(`p` reusable, since it is used twice) answers `Nat.mul(1n+p, fact(p))`. The
reference `facts` matches on the list: `Nil{}` answers `Nil{}`, and
`+h <> +t` answers `fact(h) <> facts(t)`.

- `fact_zero`, `fact_succ`, `facts_nil` and `facts_cons` close by `{==}`: each
  argument is a constructor, so the match steps.
- `facts_len` is an induction on `xs`, because both sides are stuck on a
  variable. `Nil{}` is `{==}`. In the cons case the goal reduces to
  `1n + P.len(facts(t)) == 1n + P.len(t)`:

      %L.facts_len(t) : {1n + P.len(S.facts(t)) == 1n + _ : Nat}
      {==}
