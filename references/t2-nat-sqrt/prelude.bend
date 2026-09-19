import Base

# `1n` when `a` is at most `b`, `0n` otherwise, by structural descent on both. It
# is here because the step below *adds* the decision to the answer -- one more
# when the next square still fits -- and a `match` cannot scrutinise a comparison
# it has computed, so the comparison has to be a def that returns a number. It is
# the whole of the arithmetic the task adds to `Base`: the square itself is
# `Nat.mul`, and the successor is `Nat.add`.
def le_ind(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      1n
    case 0n 1n+bp:
      1n
    case 1n+ap 0n:
      0n
    case 1n+ap 1n+bp:
      le_ind(ap, bp)
