import Base
import ./prelude.bend as P

# TODO(policy): `inorder(t)` is the keys of `t` in ascending order: the left
# subtree's traversal, then the node's key, then the right subtree's. One
# recursion, no helper: `l`, `key` and `r` are each used exactly once per
# branch, so neither the node nor its parts need to be passed on.
def inorder(t: P.Tree) -> List<&2, Nat>:
  ?TODO

# TODO(policy): `all_le_put(t, b, k)` is `k` conjoined with "every key in `t` is
# at most `b`" -- it takes the answer for the part already walked, the way the
# list-side fold `P.all_le_list_put` does, so that a proof can thread the two in
# the same order. `k` is used in the accumulator and in the recursive call, and
# `b` is used at every node, so both are declared `+`.
def all_le_put(t: P.Tree, +b: Nat, +k: Bool) -> Bool:
  ?TODO

# TODO(policy): the same for "every key in `t` is at least `b`".
def all_ge_put(t: P.Tree, +b: Nat, +k: Bool) -> Bool:
  ?TODO

# TODO(policy): `bst(t, lo, hi, k)` is the range invariant -- `k` conjoined with
# "every key in `t` lies between `lo` and `hi`". At a node the left subtree is
# bounded by the node's key and the right subtree by it too, which is why the
# key is threaded into both recursive calls. `k` is the accumulator the
# traversal starts from, so the invariant and the traversal are statements about
# the same walk.
def bst(t: P.Tree, +lo: Nat, +hi: Nat, k: Bool) -> Bool:
  ?TODO
