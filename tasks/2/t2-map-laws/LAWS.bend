import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: mapping preserves the length.
law len_map:
  for xs: List<Nat>
  {S.len(S.map(xs)) == S.len(xs) : Nat}

# LAW: mapping a cons maps its head and its tail.
law map_cons:
  for h: Nat
  for t: List<Nat>
  {S.map(h <> t) == (1n+h) <> S.map(t) : List<Nat>}
