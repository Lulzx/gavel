The reference has two defs. `ext_go(xs, lo, hi)` matches on `xs`: `Nil{}`
answers `lo <> hi <> Nil{}`, and `+h <> t` answers
`ext_go(t, P.min2(h, lo), P.max2(h, hi))`. `extremes` matches on its list:
`Nil{}` answers `Nil{}`, and `+h <> t` answers `ext_go(t, h, h)`.

- `extremes_nil`, `extremes_single`, `extremes_cons`, `ext_go_nil` and
  `ext_go_cons` all close by `{==}`: each one steps a match on a constructor.
- `ext_go_len` is an induction on `xs`, for every `lo` and `hi`. `Nil{}` is
  `{==}`, since the answer is a two-element list. In the cons case the goal
  reduces to the length of the walk at `t` with the updated pair, which is the
  hypothesis at that pair, so the proof is just
  `L.ext_go_len(t, P.min2(h, lo), P.max2(h, hi))` with no rewrite.
