import Base

# A body a person would plausibly write: stepping into the tail passes `0n`
# instead of the decremented count, as if each cell were looked up from the
# start of what remains. Rejected by `at_succ` (on a variable list the two sides
# are `at(xs, 0n)` and `at(xs, k)`, which the body is in no position to equate)
# and by `at_len_append`, which wants `y` where this body answers the head of
# the tail.
def at(xs: List<Nat>, n: Nat) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      match n:
        case 0n:
          h
        case 1n+k:
          at(t, 0n)
