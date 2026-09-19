import Base
import ./prelude.bend as P

# TODO(policy): implement. `alternate(n, a, b)` is the list of length `n` that
# alternates the two numbers, `a` first. Recurse on the count: zero answers
# nothing, and a successor puts `a` in front of the same list with one fewer to
# go and the two numbers the other way round. `a` is read twice -- once as the
# element itself and once as the element the tail ends up starting with after
# the swap -- so the parameter is marked reusable.
def alternate(n: Nat, +a: Nat, +b: Nat) -> List<Nat>:
  ?TODO
