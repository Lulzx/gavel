import Base
import ./prelude.bend as P

# PROBE. The anchor holds, the node is counted once, and both subtrees are
# walked -- but the two subtree answers are added the other way round, `1n +
# internal_count(r) + internal_count(l)`. That is what an author who wrote the
# right subtree first would leave behind, and it asks whether the law set pins
# the order the answers are combined in. `Nat.add` does not commute on a
# variable, so the node law should separate it; the inner law should separate it
# again, because `P.inner` reads left first and `P.len` of a cons counts one in
# front of the rest.
def internal_count(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      0n
    case P.Node{l, key, r}:
      1n + internal_count(r) + internal_count(l)
