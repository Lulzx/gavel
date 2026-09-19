import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on `t`; a leaf becomes a node holding the new
# number and the number that was there, and a node inserts into its left
# subtree and leaves the right one standing.
def tree_insert(t: P.Tree, v: Nat) -> P.Tree:
  ?TODO
