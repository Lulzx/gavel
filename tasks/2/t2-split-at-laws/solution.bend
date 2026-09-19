import Base
import ./prelude.bend as P

# TODO(policy): implement. Recurse on the count; a count of `0n` takes nothing,
# so the first half is empty and the second half is the whole list, and a
# successor count takes the head of a non-empty list into the first half and
# recurses on the tail with the count below it. The tail is read twice -- once
# for each half of the tail's pair -- so it is marked reusable, and the pair is
# built by projecting the tail's pair twice rather than by matching on it, since
# a match cannot scrutinise a computed value.
def split_at(n: Nat, xs: List<&2, Nat>) -> P.Duo:
  ?TODO
