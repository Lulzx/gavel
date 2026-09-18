import Base
import ./prelude.bend as P

# TODO(policy): the element of `xs` at index `k`, as a `Maybe<&2, Nat>` --
# `Some{x}` when the index is one the list has, `None{}` when it is not.
#
# Which of the two it is, is not a matter of taste: the conditional laws say the
# domain is exactly the indices `Nat.is_lt(k, P.len(xs))` accepts, so the body
# has to answer `Some{}` on the whole of that set and `None{}` on the rest. The
# index is consumed first: `match k:` with the list read inside each branch,
# since a nested `match` on a variable the outer pattern did not bind is refused
# with "match scrutinees in binder order".
def nth(k: Nat, xs: List<&2, Nat>) -> Maybe<&2, Nat>:
  ?TODO
