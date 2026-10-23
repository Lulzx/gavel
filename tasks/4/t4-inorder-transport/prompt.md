Implement `inorder`, `all_le_put`, `all_ge_put` and `bst`, then prove the twelve
laws in `LAWS.bend`.

The trees are the prelude's `P.Tree`: `P.Tip{}` is the empty tree and
`P.Bin{l, key, r}` a node with key `key` and subtrees `l` and `r`.

`inorder(t)` is the in-order traversal of `t`: the traversal of the left
subtree, then the node's key, then the traversal of the right subtree. The empty
tree gives `Nil{}`. For a search tree this lists the keys in ascending order.

`all_le_put(t, b, k)` is `k` and "every key in `t` is at most `b`", as one
`Bool`. `k` is the answer for whatever was checked before `t`, and the keys of
`t` are added to it one at a time in in-order, left to right, the same order the
prelude's list fold `P.all_le_list_put` uses. On the empty tree the answer is
`k`. `all_ge_put(t, b, k)` is the same with "at least `b`".

`bst(t, lo, hi, k)` is `k` and the range invariant: every node's key lies
between `lo` and `hi` (inclusive), where at each node the key becomes the upper
bound for its left subtree and the lower bound for its right subtree. On the
empty tree the answer is `k`.

    inorder(P.Bin{P.Bin{P.Tip{}, 1n, P.Tip{}}, 3n, P.Bin{P.Tip{}, 5n, P.Tip{}}}) == [1n, 3n, 5n]
    inorder(P.Bin{P.Tip{}, 4n, P.Bin{P.Tip{}, 2n, P.Tip{}}}) == [4n, 2n]
    bst(P.Bin{P.Tip{}, 4n, P.Bin{P.Tip{}, 2n, P.Tip{}}}, 0n, 9n, True{}) == False{}
    all_le_put(P.Bin{P.Tip{}, 4n, P.Tip{}}, 3n, True{}) == False{}

Prelude names: `P.le(a, b)` is `True{}` when `a` is at most `b`. `P.append`
concatenates two lists, `P.len` counts a list's elements and `P.size(t)` counts
the nodes of `t`. `P.all_le_list_put(xs, b, k)` is `k` and "every element of
`xs` is at most `b`", and `P.all_ge_list_put` the same with "at least `b`".
`P.all_le_list` and `P.all_ge_list` are the same bounds without the `k`.
`P.sorted_put(xs, p, k)` is `k` and "`p`, then the elements of `xs`, are in
non-decreasing order"; `P.is_sorted(xs)` is `P.sorted_put(xs, 0n, True{})`.

- `inorder_tip`: the traversal of the empty tree is `Nil{}`.
- `inorder_bin`: the traversal of `P.Bin{l, key, r}` is the traversal of `l`
  appended to `key` followed by the traversal of `r`.
- `bst_tip`: on the empty tree `bst` answers `k`, whatever `lo` and `hi`.
- `bst_bin`: `bst(P.Bin{l, key, r}, lo, hi, k)` is the conjunction, in this
  nesting, of `bst(l, lo, key, k)`, `bst(r, key, hi, True{})`, `P.le(lo, key)`
  and `P.le(key, hi)`.
- `all_le_put_tip`: on the empty tree `all_le_put` answers `k`.
- `all_le_put_bin`: `all_le_put(P.Bin{l, key, r}, b, k)` is `all_le_put` of `r`
  and `b`, started from `all_le_put(l, b, k)` conjoined with `P.le(key, b)`.
- `all_ge_put_tip`: on the empty tree `all_ge_put` answers `k`.
- `all_ge_put_bin`: `all_ge_put(P.Bin{l, key, r}, b, k)` is `all_ge_put` of `r`
  and `b`, started from `all_ge_put(l, b, k)` conjoined with `P.le(b, key)`.
- `inorder_len`: the traversal has as many elements as the tree has nodes.
- `inorder_all_le`: when `all_le_put(t, b, k)` is `True{}`, so is
  `P.all_le_list_put` of the traversal of `t`, with the same `b` and `k`.
- `inorder_all_ge`: when `all_ge_put(t, b, k)` is `True{}`, so is
  `P.all_ge_list_put` of the traversal of `t`, with the same `b` and `k`.
- `inorder_sorted`: when `bst(t, lo, hi, True{})` is `True{}`, the traversal of
  `t` is sorted starting from `lo`: `P.sorted_put(inorder(t), lo, True{})` is
  `True{}`.
