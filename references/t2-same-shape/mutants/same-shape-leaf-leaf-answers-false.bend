import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `same_shape_leaf_leaf`. Two leaves are the same shape
# whatever they carry, so the walk's leaf/leaf case answers `True{}`; this body
# answers `False{}` there instead. It is the answer of the match's first case,
# which the generator's rules do not rewrite -- the other eight corpus entries
# fail to type-check instead -- and no other law applies `same_shape` to two
# leaves, so this law has no kill without this file.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.h2.json check
# t2-same-shape --solution <this file> --proof
# references/t2-same-shape/PROOF.bend --backend plain --json`: **tier 3**,
# `laws_failed = ["same_shape_leaf_leaf", "same_shape_relabel",
# "same_shape_self"]`. The two value laws go too, because both reduce to a
# leaf/leaf comparison at the bottom of their induction.
def same_shape(t1: P.Tree, t2: P.Tree) -> Bool:
  match t1 t2:
    case P.Leaf{v} P.Leaf{w}:
      False{}
    case P.Leaf{v} P.Node{l, key, r}:
      False{}
    case P.Node{l, key, r} P.Leaf{w}:
      False{}
    case P.Node{l1, key1, r1} P.Node{l2, key2, r2}:
      Bool.and(same_shape(l1, l2), same_shape(r1, r2))
