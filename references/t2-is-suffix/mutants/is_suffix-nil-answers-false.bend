import Base
import ./prelude.bend as P

# `is_suffix` answers `False{}` when the first list is empty, so the empty list
# is not recognised as a suffix of anything.
#
# This file exists for the three laws that ask the walk to succeed, none of
# which any other mutant in the corpus fails. It is the reference with the
# first stopped match's answer replaced, so it type-checks and every recursive
# step is untouched. `xs` is a `+` parameter, so leaving it unread on that
# branch is allowed.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `is_suffix_nil`, `is_suffix_self` and `is_suffix_append`, and
# proving `is_suffix_nil_right` and `is_suffix_cons`.
def is_suffix(+xs: List<&2, Nat>, ys: List<&2, Nat>) -> Bool:
  match ys:
    case Nil{}:
      False{}
    case k <> +u:
      Bool.or(P.eq_list(xs, k <> u), is_suffix(xs, u))
