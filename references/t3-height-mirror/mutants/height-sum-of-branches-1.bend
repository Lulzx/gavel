import Base
import ./prelude.bend as P

# Adds the two subtree heights instead of taking the larger: a plausible slip
# because the two branches are combined either way, and it type-checks. The step
# law rejects it -- `P.max(h, k)` and `h + k` are not convertible while the
# heights are variables -- and so does the mirror law, on any tree whose two
# subtrees differ. The leaf case is the reference's and is the one law it keeps.
def height(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{}:
      0n
    case P.Node{l, r}:
      1n + height(l) + height(r)
