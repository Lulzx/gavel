The reference matches on the tree: `P.Leaf{x}` gives `P.Node{P.Leaf{x}, P.Leaf{v}}`,
and `P.Node{l, r}` gives `P.Node{l, snoc_tree(r, v)}`, so the new leaf goes down
the right spine only.

All three laws match on `t` into `P.Leaf{x}` (closes by `{==}`) and
`P.Node{l, r}`. The tree is used twice in the second and third statements, so
those bind `+t`.

- `snoc_tree_rightmost`, node case: `P.rightmost` descends the right side, so the
  goal reduces to the statement at `r`; the proof is the hypothesis itself,
  `L.snoc_tree_rightmost(r, v)`, with no rewrite.
- `snoc_tree_leftmost`, node case: closes by `{==}`, since `P.leftmost` never
  reaches the right subtree that was rebuilt.
- `snoc_tree_right_spine`, node case: both sides reduce to
  `1n + ...` around the hypothesis at `r`. It is stated with the `1n` in front
  because `+` steps on its left argument. Flip the hypothesis with `Equal.sym`:

      %Equal.sym(Nat, P.right_spine(S.snoc_tree(r, v)), 1n + P.right_spine(r), L.snoc_tree_right_spine(r, v)) : {1n + _ == 1n + (1n + P.right_spine(r)) : Nat}
      {==}
