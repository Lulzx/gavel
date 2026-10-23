Implement `ins_at`, `insert` and `count`, then prove the nine laws in `LAWS.bend`.

The trees are the prelude's `P.Tree`: `P.Tip{}` is the empty tree and
`P.Bin{l, key, r}` a node with key `key` and subtrees `l` and `r`.

`insert(t, k)` is `t` with `k` added as a new leaf: every key already in `t`
stays where it is, and the new node hangs below the existing ones, reached by
going left at each node whose key is at least `k` and right at each node whose
key is less than `k`. A key equal to a node's key therefore goes to its left.
On the empty tree the answer is the one-node tree holding `k`.

`ins_at(t, c, k)` is the same insertion when the decision at the root of `t` has
already been made and handed over as `c`: `True{}` means `k` goes into the left
subtree, `False{}` the right. Below the root every decision is the usual one,
`P.le(k, P.root_key(s))` for the subtree `s` being entered. On `P.Tip{}` the
decision is ignored and the answer is the one-node tree holding `k`.

`count(t, x)` is how many keys in `t` are equal to `x`; equal keys are counted
separately, and the empty tree counts `0n`.

    insert(P.Bin{P.Tip{}, 5n, P.Tip{}}, 2n) == P.Bin{P.Bin{P.Tip{}, 2n, P.Tip{}}, 5n, P.Tip{}}
    insert(P.Bin{P.Bin{P.Tip{}, 2n, P.Tip{}}, 5n, P.Tip{}}, 7n) == P.Bin{P.Bin{P.Tip{}, 2n, P.Tip{}}, 5n, P.Bin{P.Tip{}, 7n, P.Tip{}}}
    ins_at(P.Bin{P.Tip{}, 5n, P.Tip{}}, False{}, 2n) == P.Bin{P.Tip{}, 5n, P.Bin{P.Tip{}, 2n, P.Tip{}}}
    count(P.Bin{P.Bin{P.Tip{}, 5n, P.Tip{}}, 5n, P.Tip{}}, 5n) == 2n

Prelude names: `P.le(a, b)` is `True{}` when `a` is at most `b`.
`P.root_key(t)` is the key at the root of `t`, and `0n` for `P.Tip{}`.
`P.all_le(t, b)` says every key in `t` is at most `b`, and `P.all_ge(t, b)` that
every key is at least `b`. `P.ordered(t)` says that at every node all keys in
the left subtree are at most the node's key and all keys in the right subtree
at least it. `P.is_eq(a, b)` is `1n` when `a` and `b` are equal and `0n`
otherwise.

- `insert_leaf`: inserting `k` into the empty tree gives the one-node tree
  holding `k`.
- `insert_le`: when `y` is at most `x`, inserting `y` into the one-node tree
  holding `x` puts `y` in a new left leaf.
- `insert_gt`: when `y` is not at most `x`, inserting `y` into the one-node tree
  holding `x` puts `y` in a new right leaf.
- `ins_at_tip`: `ins_at` on the empty tree gives the one-node tree holding `k`,
  whatever the decision `c`.
- `ins_at_left`: `ins_at` on `P.Bin{l, key, r}` with decision `True{}` keeps
  `key` and `r` and replaces `l` by `ins_at(l, P.le(k, P.root_key(l)), k)`.
- `ins_at_right`: `ins_at` on `P.Bin{l, key, r}` with decision `False{}` keeps
  `l` and `key` and replaces `r` by `ins_at(r, P.le(k, P.root_key(r)), k)`.
- `insert_ordered`: when `t` is ordered, `insert(t, k)` is ordered.
- `insert_count`: the count of `x` in `insert(t, k)` is the count of `x` in `t`
  plus `P.is_eq(k, x)`, so it goes up by one exactly when `k` is `x`.
- `count_tip`: the empty tree counts `0n` of any key.
