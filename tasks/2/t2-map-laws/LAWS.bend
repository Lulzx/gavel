import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the length of a mapped cons is one more than the length of the tail.
# This is the law that pins `len`: the whole-list `len_map` is satisfied by a
# `len` that ignored its argument entirely and returned `0n`, because then both
# sides are `0n`.
law len_map_cons:
  for h: Nat
  for t: List<Nat>
  {S.len(S.map(h <> t)) == 1n+S.len(t) : Nat}

# LAW: mapping a cons maps its head and its tail. This is the law that pins
# `map` -- `len_map_cons` is satisfied by the identity function `map(xs) = xs`
# however `len` is written.
law map_cons:
  for h: Nat
  for t: List<Nat>
  {S.map(h <> t) == (1n+h) <> S.map(t) : List<Nat>}

# LAW: a one-element list has length one. `len_map_cons` relates `len` to
# itself through `map`, so its value at the empty list is free: a `len` that
# answered `1n` there and added one per cons proved both laws at full reward,
# because the offset appears on both sides and cancels. This law fixes the
# value at a closed term rather than comparing the function with itself, which
# anchors the offset.
law len_single:
  for h: Nat
  {S.len(h <> Nil{}) == 1n : Nat}
