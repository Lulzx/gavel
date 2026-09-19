import Base
import ./prelude.bend as P

# HAND MUTANT (the *first* is dropped). On a hit the entry is removed and the
# removal continues in the tail, so every entry under the query goes; the
# reference answers the tail as it stands. One character of difference in the
# hit branch, and the miss branch is the reference's.
#
# Measured 2026-09-19 against the four-law set: **tier 3, three laws unproven --
# `assoc_delete_step`, `assoc_delete_hit`, `assoc_delete_skip`.** The law it
# exists to be killed by is `assoc_delete_hit` (`Mk{k, w} <> kvs` with `k` again
# inside `kvs` is the one input where the two disagree); `assoc_delete_step`
# catches it too because the hit branch no longer answers the tail the step law
# names, and `assoc_delete_skip` because the skip branch now recurses into a tail
# whose removal the law requires to be the empty-prefix one.
def assoc_delete(+k: Nat, kvs: List<&2, P.Entry>) -> List<&2, P.Entry>:
  match kvs:
    case Nil{}:
      Nil{}
    case P.Mk{+hk, hv} <> +t:
      P.key_select(hk, k, assoc_delete(k, t), P.Mk{hk, hv} <> assoc_delete(k, t))
