import Base
import ./prelude.bend as P

# `is_suffix` answers `True{}` when the second list has run out under a
# non-empty first list.
#
# This file exists for a law that no other mutant in the corpus fails. It is
# the reference with the stopped match's answer flipped, so it type-checks and
# every recursive step is untouched. `xs` is a `+` parameter, so leaving it
# unread on that branch is allowed.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `is_suffix_nil_right`.
def is_suffix(+xs: List<&2, Nat>, ys: List<&2, Nat>) -> Bool:
  match ys:
    case Nil{}:
      True{}
    case k <> +u:
      Bool.or(P.eq_list(xs, k <> u), is_suffix(xs, u))
