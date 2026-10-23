The reference `inorder` is `P.append(inorder(l), key <> inorder(r))`, `Nil{}` at
a tip. `all_le_put` is `all_le_put(r, b, Bool.and(all_le_put(l, b, k), P.le(key, b)))`
(and the mirror for `all_ge_put`); `bst` is the conjunction the `bst_bin` law
spells out. All three answer `k` at a tip. With those bodies the eight pins
(`inorder_tip` through `all_ge_put_bin`) are all `{==}`.

- `inorder_len`: a `Policy.inorder_size` by induction on `t`. The node case
  rewrites with `len(append(xs, ys)) == len(xs) + len(ys)` (induction on `xs`),
  then the hypothesis on each side, then `a + (1n + b) == 1n + (a + b)` to match
  `P.size`'s `1n + (size(l) + size(r))`.
- `inorder_all_le` / `inorder_all_ge`: a transport
  `P.all_le_list_put(S.inorder(t), b, k) == S.all_le_put(t, b, k)` by induction
  on `t`, generalised over `k`. Its node case needs
  `all_le_list_put(append(xs, ys), b, k) == all_le_list_put(ys, b, all_le_list_put(xs, b, k))`
  (induction on `xs`, the cons case is the hypothesis at the new accumulator),
  then the hypothesis at `r` (with the accumulator built from `l`) and at `l`.
  The law is `Equal.trans` of the transport and `e`.
- `inorder_sorted`: proved through a stronger `Policy.bst_ind(t, lo, hi, k, e)`:
  `bst(t, lo, hi, k)` gives the conjunction of
  `P.sorted_put(inorder(t), lo, k)`, `P.all_le_list(inorder(t), hi)` and
  `P.all_ge_list(inorder(t), lo)`. The law takes its first conjunct. `bst_ind`
  is an induction on `t`: at a node, split `e` with `and_l`/`and_r` (the
  `False` case of `and_r` transports along `False{} == True{}` via
  `Equal.cong`), apply the hypothesis to `l` (bounds `lo, key`, accumulator `k`)
  and to `r` (bounds `key, hi`, accumulator `True{}`), and rebuild with
  `and_i`. Further lemmas, each an induction on the list or on `a`:
  - `between`: from `sorted_put(X, p, k)`, `le(p, key)`, `all_le_list(X, key)`
    and `sorted_put(Y, key, True{})`, get
    `sorted_put(append(X, key <> Y), p, k) == True{}` (match `X`, then `k`).
  - `all_le_list(append(xs, ys), b) == Bool.and(all_le_list(xs, b), all_le_list(ys, b))`
    and the `all_ge_list` mirror, using `Bool.and` associativity (match on `a`).
  - `le_trans`, and monotonicity: `all_le_list(xs, b)` with `le(b, c)` gives
    `all_le_list(xs, c)`; `all_ge_list(xs, c)` with `le(b, c)` gives
    `all_ge_list(xs, b)`. These lift the subtree bounds `key` to `hi` and `lo`.
