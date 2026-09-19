import Base
import ./prelude.bend as P

# ESCAPE PROBE (alternative algorithm, not a perturbation). The removal written
# as a tail-recursive walk that carries the kept prefix in an accumulator and
# rebuilds the answer from it: the entries before the first match are pushed
# onto the accumulator one at a time and appended in front of the tail at the
# match. It is the plausible loop -- the one a reader reaching for a
# constant-stack version writes -- and it computes the same list the reference
# does at every input.
#
# Measured 2026-09-19 against the four-law set: **tier 3, three laws unproven --
# `delete_step`, `delete_hit`, `delete_miss`; only `delete_nil` proven.** It does
# not escape, and the reason is the shape of the law set rather than a mistake in
# the body: `delete_step` names *every* cons cell, so its left-hand side
# normalises to the reference's own unfolding, and a body that reaches the same
# list by another route has a different normal form at that point. The value of
# the probe is the negative reading -- there is no input position left free for an
# alternative algorithm to hide in, because the step law is not restricted to a
# closed list or a literal count.
def Policy.app(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> Policy.app(t, ys)

def Policy.snoc(xs: List<&2, Nat>, v: Nat) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      v <> Nil{}
    case +h <> +t:
      h <> Policy.snoc(t, v)

def Policy.dgo(+x: Nat, xs: List<&2, Nat>, +acc: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      acc
    case +h <> +t:
      P.at_if(P.eq(h, x), Policy.app(acc, t), Policy.dgo(x, t, Policy.snoc(acc, h)))

def delete(+x: Nat, xs: List<&2, Nat>) -> List<&2, Nat>:
  Policy.dgo(x, xs, Nil{})
