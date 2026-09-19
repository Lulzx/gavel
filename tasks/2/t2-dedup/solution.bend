import Base
import ./prelude.bend as P

# TODO(policy): implement. `dedup(xs)` deletes adjacent duplicates: the empty
# list answers `Nil{}`, a one-element list answers itself, and from two elements
# on the answer keeps the first when `P.same` says it differs from the second and
# continues with the deduction of the rest from the second on. The decision goes
# through `P.same_put`, because a `match` cannot scrutinise `P.same(h, h2)`.
def dedup(xs: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO
