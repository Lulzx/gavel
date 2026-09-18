import Base

# A body a person would plausibly write: every count on a cons cell answers the
# head, as if the index had been checked for zero-ness rather than followed.
# Rejected by `at_len_append`: for a list `h <> t` the law's left-hand side is
# `h` while its right-hand side is the appended element `y`, and the two are
# different variables. `at_succ` fails as well: its left-hand side reduces to
# `h` while its right-hand side is `at(xs, k)`, which this body leaves stuck on
# a variable list.
def at(xs: List<Nat>, n: Nat) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      match n:
        case 0n:
          h
        case 1n+k:
          h
