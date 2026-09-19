import Base
import ./prelude.bend as P

# TODO(policy): implement. Walk the list one element at a time, keeping the
# block being built, the blocks already finished, and the number of slots left
# in the block being built. An element with a slot left joins the block; an
# element with no slot left starts a new block, closing the old one first. At
# the end of the list the block being built is closed too, however full it is,
# which is what keeps a short final block. The block size is read twice -- once
# as the size itself and once as the size below it -- so the parameter is marked
# reusable.
def chunks_go(xs: List<&2, Nat>, +n: Nat, k: Nat, cur: List<&2, Nat>, out: List<&2, List<&2, Nat>>) -> List<&2, List<&2, Nat>>:
  ?TODO

# TODO(policy): implement. The entry point: no blocks yet, no block being built,
# and a full block's worth of slots. `Nil{}` has nothing to split and a size of
# `0n` cannot form a block, so both answer `Nil{}`; otherwise the first element
# opens the first block. Recurse on the list, and note that the match has to
# follow the parameter order.
def chunks(xs: List<&2, Nat>, +n: Nat) -> List<&2, List<&2, Nat>>:
  ?TODO
