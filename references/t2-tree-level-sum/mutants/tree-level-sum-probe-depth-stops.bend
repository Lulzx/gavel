# PROBE (2026-09-19, tag f1): the candidate body the assignment warned about --
# "a law set that only mentions `k` at `0n` and `1n + k` may still leave the
# interior free". This body is the reference at depth zero and depth one and
# answers `0n` at every depth below: its node case splits on the *decremented*
# depth, so a second descent stops.
#
# The set is sound against it: `tree_level_sum_node_step` is quantified over
# `k` and applies the target to the subtrees, so with `k = 1n` its right-hand
# side reaches the interior (depth one of the subtrees) while the left-hand side
# has already stopped -- there is no way to make the two agree.
#
# Measured 2026-09-19: **tier 3**, `laws_failed = ["tree_level_sum_node_step"]`.
# The negation is concrete, not a proof shape: at `k = 1n` under a node, the
# law's right-hand side is `f(l, 1n) + f(r, 1n)`, which this body evaluates by
# descending once more, and its left-hand side has already answered `0n`. The two
# differ at `P.Node{P.Node{P.Leaf{1n}, 2n, P.Leaf{3n}}, 5n, P.Leaf{4n}}` at depth
# `2n` (`4n` against `0n`), so no submission proof exists.
import Base
import ./prelude.bend as P

def tree_level_sum(t: P.Tree, k: Nat) -> Nat:
  match t:
    case P.Leaf{v}:
      match k:
        case 0n:
          v
        case 1n+kp:
          0n
    case P.Node{l, key, r}:
      match k:
        case 0n:
          key
        case 1n+kp:
          match kp:
            case 0n:
              P.root(l) + P.root(r)
            case 1n+kp2:
              0n
