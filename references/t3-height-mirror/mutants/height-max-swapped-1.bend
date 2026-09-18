import Base
import ./prelude.bend as P

# Takes the maximum of the two subtrees with the arguments the wrong way round.
# `P.max` is commutative, so this is the same function -- and it is still a
# mutant, which is the interesting part: convertibility in this checker is
# syntactic, and `P.max(S.height(r), S.height(l))` does not reduce to
# `P.max(S.height(l), S.height(r))` while the two heights are variables. So both
# non-base laws reject a body that is morally correct, and a policy that ships it
# loses the whole task.
def height(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{}:
      0n
    case P.Node{l, r}:
      1n + P.max(height(r), height(l))
