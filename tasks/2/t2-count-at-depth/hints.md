The reference matches on the tree first and then, inside the bin case, on the
depth: `P.Tip{}` answers `0n`; `P.Bin{l, key, r}` answers `1n` at `0n` and
`count_at_depth(l, dp) + count_at_depth(r, dp)` at `1n++dp`. The tree must be
the first parameter. `dp` is used twice, which the successor pattern handles.

- `count_at_depth_tip`, `count_at_depth_step`, `count_at_depth_three`: close by
  `{==}`. The tip answers `0n` without looking at the depth; the step law has a
  bin and a successor depth, so both matches step; the closed tree computes.
- `count_at_depth_zero`: the depth is the literal `0n` and the tree is a
  variable, so match on `t`. The `P.Tip{}` and `P.Bin{l, key, r}` cases each
  close by `{==}` (`P.is_tip` and `P.at_if` reduce). No induction.
