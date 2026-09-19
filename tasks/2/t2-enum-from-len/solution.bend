import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on the count; a count of zero enumerates
# nothing, and a successor count answers the start in front of the run of one
# fewer number that starts one above it. The start is read twice -- once as the
# element itself and once as the start of the tail's run -- so the parameter is
# marked reusable.
def enum_from(n: Nat, +a: Nat) -> List<Nat>:
  ?TODO
