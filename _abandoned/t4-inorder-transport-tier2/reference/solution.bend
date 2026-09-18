import Base
import ./prelude.bend as P

# Both subtrees are used once, and the key goes between them: the left
# traversal, then the key as a one-element list, then the right traversal.
# `P.append` matches on its first argument, so with a variable left subtree the
# result does not reduce -- which is why the laws that mention an append need a
# lemma about the fold over an append.
def inorder(t: P.Tree) -> List<&2, Nat>:
  match t:
    case P.Tip{}:
      Nil{}
    case P.Bin{l, key, r}:
      P.append(inorder(l), key <> inorder(r))
