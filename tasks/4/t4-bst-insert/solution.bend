import Base
import ./prelude.bend as P

# TODO(policy): `ins_at(t, c, k)` is `t` with `k` stored in it, where `c` is the
# decision taken at the node above: `c` is `P.le(k, P.root_key(t))`, so `True`
# means the key belongs in the left subtree and `False` in the right. A `match`
# cannot scrutinise a computed comparison, which is why the decision arrives as
# a parameter rather than being written `match P.le(k, key)`. `ins_at` is its own
# recursion: it computes the decision for the subtree it is about to enter with
# `P.root_key`, and it does not call `insert`.
def ins_at(t: P.Tree, c: Bool, +k: Nat) -> P.Tree:
  ?TODO

# TODO(policy): `insert(t, k)` is `t` with `k` stored in it: the keys already
# there are kept and `k` is added, so an ordered tree stays ordered. `k` is used
# in the comparison and again in the new node, so it is declared `+`.
def insert(t: P.Tree, +k: Nat) -> P.Tree:
  ?TODO

# TODO(policy): how many keys in `t` are equal to `x`. Equal keys are counted,
# so the answer is a sum of `P.is_eq` indicators rather than a `Bool`. `x` is
# used in the indicator and in both recursive calls, so it is declared `+`.
def count(t: P.Tree, +x: Nat) -> Nat:
  ?TODO
