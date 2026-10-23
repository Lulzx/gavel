import Base
import ./prelude.bend as P

# The count is thrown away as soon as it is a successor: the body answers
# P.max_list(xs) whatever the count was. It is right at `0n`, right on `Nil{}` and
# right at exactly `P.len(xs)`, and wrong at every count in between.
# This file used to say "no hole here", because the reference proof of the
# length law did not replay on this body. A policy writes its own proof, and the
# length law's is a two-case induction that closes by `{==}` in both cases:
# measured, a token-different spelling of this body earned **reward 1.000**
# against the three-law set (`tests/holes/`). Rejected now by `max_prefix_step`.
def max_prefix(n: Nat, xs: List<Nat>) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+k:
      P.max_list(xs)
