import Base
import ./prelude.bend as P

# HAND MUTANT. Target: `replace_first_three` and `replace_first_hit` -- the two
# laws that say *first*. This body walks the tail after a hit instead of
# discarding it, so every occurrence of `k` is replaced: `[1n, 2n, 1n]` comes out
# `[9n, 2n, 9n]`. The step it needs is not the prelude's `P.rp_branch` -- whose
# `True{}` answer is built from the untouched tail -- so it carries its own
# `Policy.`-namespaced step, which is the only name the gate lets a solution
# introduce beside the targets. This is the reading the task is *named* against:
# a policy that writes the obvious "replace them all" fold satisfies every law
# about the length and about a miss and is separated only by a law that reads a
# list with the same element twice.
#
# Measured 2026-09-19, same command as the other hand mutants: **tier 3**,
# `laws_failed = ["replace_first_hit", "replace_first_miss",
# "replace_first_len", "replace_first_three"]`. `replace_first_three` is the law
# that says *first*, and it reads a list with the same element twice; the other
# three fail because the `P.rp_branch` step the reference proof is written
# against is not the step this body takes.
def Policy.rp_branch_all(b: Bool, h: Nat, y: Nat, r: List<&2, Nat>) -> List<&2, Nat>:
  match b:
    case True{}:
      y <> r
    case False{}:
      h <> r

def replace_first(xs: List<&2, Nat>, +k: Nat, +y: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> +t:
      Policy.rp_branch_all(P.eq(h, k), h, y, replace_first(t, k, y))
