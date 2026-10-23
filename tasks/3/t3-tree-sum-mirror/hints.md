The reference answers `0n` at a leaf and `tree_sum(l) + key + tree_sum(r)` at a
node.

- `tree_sum_leaf` and `tree_sum_node` close by `{==}`.
- `tree_sum_mirror` is an induction on the tree. The leaf case is `{==}`. The
  node case unfolds to
  `(tree_sum(mirror(r)) + key) + tree_sum(mirror(l)) == (tree_sum(l) + key) + tree_sum(r)`.
  The reference:
  1. rewrites `tree_sum(mirror(r))` and then `tree_sum(mirror(l))` with their
     hypotheses (each flipped), leaving `(s_r + key) + s_l` on the left;
  2. rewrites `s_l + key` on the right into `key + s_l` with
     `Policy.add_comm(s_l, key)` (flipped);
  3. rewrites the left `(s_r + key) + s_l` from `s_r + (key + s_l)` with
     `Policy.add_assoc(s_r, key, s_l)`;
  4. returns `Policy.add_comm(s_r, key + s_l)` as the last line, which is the
     remaining goal exactly.

The arithmetic, each an induction on `a`:

- `add_zero_right(a)`: `a == a + 0n`.
- `add_assoc(a, -b, -c)`: `a + (b + c) == (a + b) + c`.
- `add_succ_right(a, -b)`: `a + (1n + b) == 1n + (a + b)`.
- `add_comm(a, +b)`: `a + b == b + a`, using the first and third.
