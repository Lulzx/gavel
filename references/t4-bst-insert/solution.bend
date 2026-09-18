import Base
import ./prelude.bend as P

# Which way a descent goes is decided by comparing the key against the node's
# own key, and a `match` cannot scrutinise the computed `P.le(k, key)` -- the
# checker asks for that comparison to be given its own def. So `insert` matches
# the tree, computes the comparison at the root, and hands it to `ins_at` as an
# argument. `ins_at` matches on the argument and on the subtree it is about to
# enter, and computes the *next* comparison with `P.root_key` on that subtree,
# which is how the descent keeps going without `ins_at` and `insert` having to
# call each other. The subtree is the first parameter so that the recursive
# call is a structural descent on it.
def ins_at(t: P.Tree, c: Bool, +k: Nat) -> P.Tree:
  match t:
    case P.Tip{}:
      P.Bin{P.Tip{}, k, P.Tip{}}
    case P.Bin{+l, +key, +r}:
      match c:
        case True{}:
          P.Bin{ins_at(l, P.le(k, P.root_key(l)), k), key, r}
        case False{}:
          P.Bin{l, key, ins_at(r, P.le(k, P.root_key(r)), k)}

def insert(t: P.Tree, +k: Nat) -> P.Tree:
  match t:
    case P.Tip{}:
      P.Bin{P.Tip{}, k, P.Tip{}}
    case P.Bin{+l, +key, +r}:
      ins_at(P.Bin{l, key, r}, P.le(k, key), k)

# The multiset, read off as a count: the indicator of each node's key at `x`,
# summed over the tree. It is a sum of `0n`s and `1n`s rather than a `Bool`
# comparison, because the law that pins it is an equation between sums.
def count(t: P.Tree, +x: Nat) -> Nat:
  match t:
    case P.Tip{}:
      0n
    case P.Bin{+l, +key, +r}:
      P.is_eq(key, x) + count(l, x) + count(r, x)
