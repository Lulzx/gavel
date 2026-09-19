import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the composition law; `scan_add` is what the policy writes.

# `append` matches on its first argument, so with a variable list the goal does
# not reduce, and that is what leaves the composition law below to the induction
# rather than to the unfolding.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

# Where the accumulator has got to after walking `xs` from `acc`: the sum of the
# elements walked, on top of what it started with. It threads its accumulator
# exactly the way `scan_add` does, so both sides of the composition law mention
# the same term and neither needs a lemma about `+`.
def acc_after(xs: List<Nat>, acc: Nat) -> Nat:
  match xs:
    case Nil{}:
      acc
    case h <> t:
      acc_after(t, acc + h)
