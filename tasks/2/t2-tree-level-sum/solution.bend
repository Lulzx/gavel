import Base
import ./prelude.bend as P

# TODO(policy): implement. Match on the tree first and on the depth second: a
# leaf answers its own value at depth zero and nothing below it, and a node
# answers its own key at depth zero and otherwise descends the depth by one into
# both subtrees and adds what they answer.
def tree_level_sum(t: P.Tree, k: Nat) -> Nat:
  ?TODO
