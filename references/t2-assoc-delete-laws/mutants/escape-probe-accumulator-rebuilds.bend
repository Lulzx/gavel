import Base
import ./prelude.bend as P

# ESCAPE PROBE (alternative algorithm, not a perturbation). The removal written
# as a walk that carries the kept prefix in an accumulator and rebuilds the
# answer from it: the entries before the first match are pushed onto the
# accumulator one at a time and appended in front of the tail at the match. It is
# the plausible loop -- the constant-stack version a reader reaches for -- and it
# computes the same association list the reference does at every input.
#
# Measured 2026-09-19 against the four-law set: **tier 3, three laws unproven --
# `assoc_delete_step`, `assoc_delete_hit`, `assoc_delete_skip`; only
# `assoc_delete_nil` proven.** It does not escape, and the reason is the shape of
# the law set rather than a mistake in the body: `assoc_delete_step` names *every*
# cons cell -- and `key_select` is part of its right-hand side -- so its
# left-hand side normalises to the reference's own unfolding, and a body that
# reaches the same list by another route has a different normal form at that
# point. The value of the probe is the negative reading: no input position is
# left free for an alternative algorithm to hide in.
def Policy.app(xs: List<&2, P.Entry>, ys: List<&2, P.Entry>) -> List<&2, P.Entry>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> Policy.app(t, ys)

def Policy.snoc(xs: List<&2, P.Entry>, +e: P.Entry) -> List<&2, P.Entry>:
  match xs:
    case Nil{}:
      e <> Nil{}
    case +h <> +t:
      h <> Policy.snoc(t, e)

def Policy.ago(+k: Nat, xs: List<&2, P.Entry>, +acc: List<&2, P.Entry>) -> List<&2, P.Entry>:
  match xs:
    case Nil{}:
      acc
    case P.Mk{+hk, hv} <> +t:
      P.key_select(hk, k, Policy.app(acc, t), Policy.ago(k, t, Policy.snoc(acc, P.Mk{hk, hv})))

def assoc_delete(+k: Nat, kvs: List<&2, P.Entry>) -> List<&2, P.Entry>:
  Policy.ago(k, kvs, Nil{})
