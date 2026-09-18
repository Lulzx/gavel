import Base
import ./prelude.bend as P

# TODO(policy): whether any element of `xs` is `True{}`. The answer folds the
# head into the search of the tail with `Bool.or`, so the empty list answers
# `False{}`. `xs` is used once per branch and is a plain binder.
def any(xs: List<&2, Bool>) -> Bool:
  ?TODO
