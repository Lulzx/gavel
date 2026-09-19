import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `path_sum_node`, and the two closed laws with it. An
# interior key lies on the path of every leaf beneath it, so it is counted once
# per leaf; this body counts it once for the node itself instead -- the
# whole-tree sum's shape, and the reading that makes `path_sum` and a sum of all
# the values the same function. Both sides of the node law are then different
# terms, the two closed trees come out `6n` and `17n` rather than `8n` and
# `27n`, and the leaf anchor still holds because this body never touches it.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.h2.json check
# t2-path-sum --solution <this file> --proof references/t2-path-sum/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["path_sum_node",
# "path_sum_three", "path_sum_deep", "path_sum_zeroed"]`. The leaf anchor
# survives, and `path_sum_zeroed` goes too: `Nat.add` recurses on its first
# argument, so `0n + (0n + path_sum(r))` and the reference's tree of adds are
# different terms even when every value is zero.
def path_sum(t: P.Tree) -> Nat:
  match t:
    case P.Leaf{v}:
      v
    case P.Node{l, key, r}:
      Nat.add(Nat.add(path_sum(l), key), path_sum(r))
