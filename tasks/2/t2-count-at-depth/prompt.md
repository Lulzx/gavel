# How many nodes sit at a depth

`count_at_depth(t, d)` is the number of nodes the tree carries at depth `d`,
counting the root as depth `0n`, and `0n` wherever the tree is shallower than
`d`:

    count_at_depth(Bin{Tip{}, 1n, Tip{}}, 0n)          ==  1n
    count_at_depth(Bin{Tip{}, 1n, Tip{}}, 1n)          ==  0n
    count_at_depth(Bin{Bin{Tip{}, 1n, Tip{}}, 2n,
                       Bin{Tip{}, 3n, Tip{}}}, 1n)     ==  2n
    count_at_depth(Bin{Bin{Tip{}, 1n, Tip{}}, 2n,
                       Bin{Tip{}, 3n, Tip{}}}, 2n)     ==  0n

`prelude.bend` declares the tree, and it is this task's own type: `P.Tip{}` is
the empty tree and `P.Bin{l, key, r}` is one node with a key of its own between
its two subtrees. A tip is not a node and carries no key, so only the bins are
counted. The constructors are reached through the prelude alias, in patterns and
in terms alike.

The bank has neighbours of this function and none of them is this one. The
bank's `tree_level_sum(t, d)` sums the *values* carried at depth `d` rather than
counting the nodes, so on the tree above it answers `2n` at depth `0n` where this
answers `1n`. The bank's `leaf_count_at(t, d)` counts one kind of node of a
value-carrying tree -- the leaves -- rather than every node of a tree whose
leaves are empty. The bank's `tree_depth_sum` adds depths up, and the bank's
`longest_row` is about a list of rows and not about a tree at all. Nothing in the
bank asks how many nodes a tree has at a given depth.

Recurse on the tree first and on the depth second. `P.Tip{}` answers `0n` at
every depth, and `P.Bin{l, key, r}` answers `1n` at depth `0n` and otherwise
hands the depth one less to both subtrees and adds the two answers. Nothing in
the body reads the key: a count is not a sum.

The depth is read twice on the recursive path -- once for each subtree -- so it
is declared reusable in the successor pattern, `1n++dp`, in the reference. The
tree comes before the depth in the signature because the checker reads a
recursive call's arguments left to right and asks that each be passed on
unchanged until one shrinks; here both shrink, and the tree is the first.

`count_at_depth_tip` fixes what a tip contributes at any depth, and it is a
pin: the step law below is stated at `P.Bin{l, key, r}`, so it never reaches a
tip, and a body that counted a tip as a node would be caught only here.

`count_at_depth_root` fixes a bin's answer at depth `0n`, and it is the other
pin: the step law is stated at `1n + d`, so it never reaches depth `0n`, and a
body that answered a bin with a subtree's reading there, or with `0n`, is caught
only here.

`count_at_depth_step` is the step, and it is the law with content: below a bin,
depth `1n + d` is depth `d` of the two subtrees, added. It says the answer is
built from *both* subtrees and that descending costs exactly one level. A body
that descended one side only, or that carried `1n + d` into the subtrees
unchanged, leaves the two sides unconvertible.

`count_at_depth_three` is one closed tree read at depth `1n`: the root's two
children are bins, so the answer is `2n`, and a body that treated a tip as a
node, or that answered `1n` at every non-zero depth, fails it.

Together the laws determine the body, by induction on the tree and the depth: a
tip is `count_at_depth_tip` at every depth, and a bin is `count_at_depth_root` at
`0n` and `count_at_depth_step` below that, which hands strictly smaller depths to
strictly smaller trees.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.count_at_depth_tip(d)`, `def L.count_at_depth_root(l, key, r)`, `def
L.count_at_depth_step(l, key, r, d)` and `def L.count_at_depth_three()`.
