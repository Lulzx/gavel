import Base
import ./prelude.bend as P

# TODO(policy): implement. `internal_count(t)` is how many interior nodes `t`
# has: a leaf is not one of them and the value it carries is not read, an
# interior node is one of them and its key is not read either. Recurse on the
# tree: `P.Leaf{v}` contributes `0n`, and `P.Node{l, key, r}` contributes `1n`
# of its own plus the interior nodes of both subtrees, left first.
#
# `P.inner(t)` lists the keys of the interior nodes, one entry per interior
# node, and `P.len` counts a list; the third law states the answer against
# those, so the count is fixed by the prelude's own reading of the tree.
def internal_count(t: P.Tree) -> Nat:
  ?TODO
