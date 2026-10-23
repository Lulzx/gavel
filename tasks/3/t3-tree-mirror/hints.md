The reference answers `P.Leaf{v}` at a leaf and `P.Node{mirror(r), mirror(l)}`
at a node.

All four laws are inductions on the tree; the leaf case is `{==}` in each.

- `mirror_mirror`, node case: the goal is
  `P.Node{S.mirror(S.mirror(l)), S.mirror(S.mirror(r))} == P.Node{l, r}`.
  Rewrite each child with its hypothesis (flipped with `Equal.sym`), the hole
  sitting inside the constructor, e.g.
  `{P.Node{_, S.mirror(S.mirror(r))} == P.Node{l, r} : P.Tree}`, then `{==}`.
- `mirror_leftmost`, node case: `P.rightmost` of the mirror steps into
  `S.mirror(l)` and `P.leftmost` into `l`, so the goal is exactly the hypothesis:
  the body is `L.mirror_leftmost(l)`.
- `mirror_rightmost`: symmetric, the body is `L.mirror_rightmost(r)`.
- `mirror_size`, node case: rewrite `P.size(S.mirror(r))` and
  `P.size(S.mirror(l))` with their hypotheses, leaving
  `P.size(r) + P.size(l) == P.size(l) + P.size(r)`, which is
  `Policy.add_comm(P.size(r), P.size(l))` returned as the last line.

`Policy.add_comm(a, +b)`: `a + b == b + a`, an induction on `a` that needs
`add_zero_right(a)`: `a == a + 0n` and `add_succ_right(a, -b)`:
`a + (1n + b) == 1n + (a + b)`, both inductions on `a`.
