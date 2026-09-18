import Base
import ./prelude.bend as P

# `ins_at` is the stub's first obligation but no law about `insert` can see it,
# and the gate's name rule leaves `Policy.*` open inside solution.bend. So the
# descent can live in `Policy.go`, `insert` can call that, and `ins_at` can
# answer its own tree: **all five laws proved at tier 4, reward 1.000**,
# measured 2026-09-19. The generated `ins-at-*` mutants in this directory do not
# cover it -- they mutate `ins_at` while `insert` still calls it, so `insert`'s
# own laws catch them through the call. `ins_at_tip`, `ins_at_left` and
# `ins_at_right` pin `ins_at` itself and close it; this file now measures tier 3.

# Which way a descent goes is decided by comparing the key against the node's
# own key, and a `match` cannot scrutinise the computed `P.le(k, key)` -- the
# checker asks for that comparison to be given its own def. So `insert` matches
# the tree, computes the comparison at the root, and hands it to `ins_at` as an
# argument. `ins_at` matches on the argument and on the subtree it is about to
# enter, and computes the *next* comparison with `P.root_key` on that subtree,
# which is how the descent keeps going without `ins_at` and `insert` having to
# call each other. The subtree is the first parameter so that the recursive
# call is a structural descent on it.
def Policy.go(t: P.Tree, c: Bool, +k: Nat) -> P.Tree:
  match t:
    case P.Tip{}:
      P.Bin{P.Tip{}, k, P.Tip{}}
    case P.Bin{+l, +key, +r}:
      match c:
        case True{}:
          P.Bin{Policy.go(l, P.le(k, P.root_key(l)), k), key, r}
        case False{}:
          P.Bin{l, key, Policy.go(r, P.le(k, P.root_key(r)), k)}

def insert(t: P.Tree, +k: Nat) -> P.Tree:
  match t:
    case P.Tip{}:
      P.Bin{P.Tip{}, k, P.Tip{}}
    case P.Bin{+l, +key, +r}:
      Policy.go(P.Bin{l, key, r}, P.le(k, key), k)

# The multiset, read off as a count: the indicator of each node's key at `x`,
# summed over the tree. It is a sum of `0n`s and `1n`s rather than a `Bool`
# comparison, because the law that pins it is an equation between sums.
def count(t: P.Tree, +x: Nat) -> Nat:
  match t:
    case P.Tip{}:
      0n
    case P.Bin{+l, +key, +r}:
      P.is_eq(key, x) + count(l, x) + count(r, x)

def ins_at(t: P.Tree, c: Bool, +k: Nat) -> P.Tree:
  t
