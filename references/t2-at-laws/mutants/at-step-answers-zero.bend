import Base

# A body a person would plausibly write: any count past the first answers `0n`,
# as if only the element at zero were being looked up. Rejected by
# `at_len_append`: at the cons case of its induction the law wants `y`, while
# this body answers `0n`. `at_succ` fails too: its right-hand side is
# `at(xs, k)`, which is stuck on a variable list, and this body leaves the left
# side at `0n` with nothing to reduce the right side against.
def at(xs: List<Nat>, n: Nat) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      match n:
        case 0n:
          h
        case 1n+k:
          0n
