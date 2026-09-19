import Base
import ./prelude.bend as P

# TODO(policy): implement. `nat_bits(w, n)` is the low `w` bits of `n`, least
# significant first: `Nil{}` at width zero, and at width `1n + p` the low bit of
# `n` followed by the low `p` bits of `n` halved. The width comes first because
# a recursive call is only accepted when every argument before the shrinking one
# is passed unchanged, and here `w` is the argument that shrinks while `n` is
# halved rather than passed on; `n` is therefore declared `+n`.
def nat_bits(w: Nat, +n: Nat) -> List<&2, Nat>:
  ?TODO
