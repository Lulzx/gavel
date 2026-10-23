The reference matches on the list: `Nil{}` answers `P.Leaf{0n}`, and `h <> t`
answers `P.Node{P.Leaf{h}, build(t)}`.

- `build_nil` and `build_cons` close by `{==}`.
- `build_leaves` and `build_right_spine` are inductions on `bs`. `Nil{}` is
  `{==}`. In the cons case the answer unfolds to a node, so the goal is
  `1n + measure(build(t)) == 1n + (1n + P.len(t))`. Rewrite with the flipped
  hypothesis, for example
  `Equal.sym(Nat, P.leaves(S.build(t)), 1n + P.len(t), L.build_leaves(t))`, into
  the hole of `1n + _ == 1n + (1n + P.len(t))`, then `{==}`. (`P.right_spine`
  is the same with `P.right_spine` in place of `P.leaves`.)
- `build_last` is an induction on `bs` whose cons case is just
  `L.build_last(t)`: `P.rightmost` and `P.last_or_zero` both ignore the head and
  step on the tail, so no rewrite is needed. `Nil{}` is `{==}`.
