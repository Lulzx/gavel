import Base
import ./prelude.bend as P

# HAND MUTANT (base case). The reference with the empty-list answer given a
# non-empty list: `Nil{}` replaced by a one-entry list. Everything else is the
# reference verbatim, so a law that only ever looks at a cons cell still holds.
#
# Measured 2026-09-19 against the four-law set: **tier 3, one law unproven --
# `assoc_delete_nil`.** `assoc_delete_step`, `assoc_delete_hit` and
# `assoc_delete_skip` are all stated at a variable tail, so no proof of them ever
# reaches the base case; this mutant is the only one that measures the empty-list
# law, and it is what stops a body that conses an entry onto the front of an
# association list that carries no key at all.
def assoc_delete(+k: Nat, kvs: List<&2, P.Entry>) -> List<&2, P.Entry>:
  match kvs:
    case Nil{}:
      P.Mk{0n, 0n} <> Nil{}
    case P.Mk{+hk, hv} <> +t:
      P.key_select(hk, k, t, P.Mk{hk, hv} <> assoc_delete(k, t))
