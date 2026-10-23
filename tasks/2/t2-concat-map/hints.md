The reference matches on the list: `Nil{}` answers `Nil{}`, and `h <> t` answers
`P.append(P.expand(h), concat_map(t))`.

- `concat_map_nil`, `concat_map_cons`: close by `{==}`.
- `concat_map_concat`: induction on `xs`; the `Nil{}` case is `{==}`. In the
  cons case `P.expand(h)` is a concrete cons cell, so `append` steps through
  it, and the goal is `h <> (h + 1n) <> concat_map(t)` against the same prefix
  followed by `P.concat(P.map_expand(t))`. The hypothesis at `t` has
  `concat_map(t)` on its left, so flip it with `Equal.sym`:

      %Equal.sym(List<&2, Nat>, S.concat_map(t), P.concat(P.map_expand(t)), L.concat_map_concat(t)) : {h <> (h + 1n) <> _ == h <> (h + 1n) <> P.concat(P.map_expand(t)) : List<&2, Nat>}
      {==}

- `concat_map_len`: induction on `xs`; `Nil{}` is `{==}`. In the cons case both
  `P.len` and `P.elen` unfold, and the goal is `1n + (1n + P.len(concat_map(t)))`
  against `1n + (1n + P.elen(t))`. Rewrite with the hypothesis at `t` (no flip):

      %L.concat_map_len(t) : {1n + (1n + P.len(S.concat_map(t))) == 1n + (1n + _) : Nat}
      {==}
