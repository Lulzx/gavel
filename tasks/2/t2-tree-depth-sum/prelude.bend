import Base

# Immutable, and owned by the task rather than the policy. The tree is declared
# here and not in `solution.bend`, so the policy never has to name a constructor
# context: the constructors are reached through the prelude alias -- `P.Leaf{v}`
# and `P.Node{l, key, r}`, in patterns and in terms alike. Every node carries a
# value, a key at an interior node and a value at a leaf, and this task's answer
# counts where the nodes *are* rather than what they carry, so the prelude needs
# nothing beyond the type itself.
type Tree is Data:
  Leaf{value: Nat}
  Node{l: Tree, key: Nat, r: Tree}
