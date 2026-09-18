import Base
import ./prelude.bend as P

# TODO(policy): decode a run list -- one entry per run, its value and its count
# -- into the flat list it stands for. Each step takes one run off the front and
# puts its values before the decoding of the rest, so the run list is matched
# once and its tail is passed on once. The element type is written `&2` because
# a run is a record and the proof has to use the tail twice; a `List<P.Run>`
# infers `&1` and is then `consumed more than once`.
def expand(rs: List<&2, P.Run>) -> List<&2, Nat>:
  ?TODO
