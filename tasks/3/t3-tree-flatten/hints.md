The reference answers `v <> Nil{}` at a leaf and
`P.append(flatten(l), flatten(r))` at a node.

- `flatten_leaf` and `flatten_node` close by `{==}`.
- `flatten_leaves` and `flatten_mirror` are inductions on the tree, with two
  hypotheses (at `l` and at `r`) in the `P.Node{l, r}` case. The leaf case is
  `{==}` in both.

`flatten_leaves`, node case: the left side is
`P.len(P.append(S.flatten(l), S.flatten(r)))`, stuck because `append` matches
on a variable list. Rewrite it with `Policy.len_append(+xs, +ys)`:
`P.len(P.append(xs, ys)) == P.len(xs) + P.len(ys)`, then each length with its
hypothesis, then `{==}`.

`flatten_mirror`, node case: the left side unfolds to
`P.append(S.flatten(P.mirror(r)), S.flatten(P.mirror(l)))`. Rewrite each part
with its hypothesis, giving `P.append(P.rev(S.flatten(r)), P.rev(S.flatten(l)))`,
then rewrite the right side `P.rev(P.append(S.flatten(l), S.flatten(r)))` with
`Policy.rev_append`, then `{==}`.

The list lemmas, each an induction on `xs` with `+` parameters:

- `append_nil(xs)`: `P.append(xs, Nil{}) == xs`.
- `len_append(xs, ys)`: as above.
- `snoc_append(xs, ys, y)`:
  `P.snoc(P.append(xs, ys), y) == P.append(xs, P.snoc(ys, y))`.
- `rev_append(xs, ys)`:
  `P.rev(P.append(xs, ys)) == P.append(P.rev(ys), P.rev(xs))`. Its `Nil{}` case
  uses `append_nil` at `P.rev(ys)`; its cons case uses the hypothesis inside
  `P.snoc(_, h)` and then `snoc_append` at `(P.rev(ys), P.rev(t), h)`.
