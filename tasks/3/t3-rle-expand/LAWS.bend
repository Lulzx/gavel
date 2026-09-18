import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: no runs, nothing to decode. Both sides compute, so this one is
# definitional, and it is the weak half: it fixes the empty case, and a body
# that answered the empty list everywhere would satisfy it.
law expand_nil:
  {S.expand(Nil{}) == Nil{} : List<&2, Nat>}

# LAW: one run, then the rest. Both sides compute, so this is definitional too,
# and it is the law that says a run is *flattened*: a body that dropped the
# count -- decoding `P.Mk{v, k} <> t` as `v <> S.expand(t)` -- agrees with every
# value law below on runs of length one and leaves the two sides here
# unconvertible.
law expand_cons:
  for v: Nat
  for k: Nat
  for t: List<&2, P.Run>
  {S.expand(P.Mk{v, k} <> t) == P.append(P.repeat(v, k), S.expand(t)) : List<&2, Nat>}

# LAW: the decoded list has as many values as the runs say. This is the work.
# Its step needs the length of an `append` and the length of a `repeat`, neither
# of which is in the prelude and both of which are inductions of their own:
# `append` and `repeat` match on a variable, so the goal is stuck until
# something inducts on that argument too.
law expand_len:
  for rs: List<&2, P.Run>
  {P.len(S.expand(rs)) == P.sum_k(rs) : Nat}
