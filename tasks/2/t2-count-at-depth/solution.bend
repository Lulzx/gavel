import Base
import ./prelude.bend as P

# TODO(policy): implement. `count_at_depth(t, d)` is the number of nodes the tree
# carries at depth `d`, counting the root as depth `0n`, and `0n` wherever the
# tree is shallower than `d`. A `P.Tip{}` is the empty tree and not a node, so it
# contributes nothing at any depth; a `P.Bin{l, key, r}` is one node, so it
# contributes `1n` at depth `0n`, and below that it hands the depth one less to
# both subtrees and adds the two answers. The key a bin carries is never read: a
# count is not a sum.
#
# So on `P.Bin{P.Bin{P.Tip{}, 1n, P.Tip{}}, 2n, P.Bin{P.Tip{}, 3n, P.Tip{}}}` the
# answer is `1n` at depth `0n` (the root itself), `2n` at depth `1n` (the two
# children), and `0n` at depth `2n` (a tip is not a node).
#
# Recurse on the tree first and on the depth second, and match in that order too:
# the checker reads a match's scrutinee in binder order, so the tree -- the first
# parameter -- is the one matched first, and the depth is matched inside each
# branch. The depth binder is reused on both recursive calls, so it is declared
# reusable in the successor pattern: `1n++dp` in the reference.
def count_at_depth(t: P.Tree, d: Nat) -> Nat:
  ?TODO
