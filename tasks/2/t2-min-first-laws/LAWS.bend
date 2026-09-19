import Base
import ./prelude.bend as P
import ./solution.bend as S

law min_first_nil:
  {S.min_first(Nil{}) == Nil{} : List<&2, Nat>}

law min_first_single:
  for x: Nat
  {S.min_first(x <> Nil{}) == x <> Nil{} : List<&2, Nat>}

law min_first_cons:
  for h: Nat
  for +t: List<&2, Nat>
  {S.min_first(h <> t) == P.mf_put(h, S.min_first(t)) : List<&2, Nat>}

law min_first_keep:
  for x: Nat
  for y: Nat
  for e: {P.le(x, y) == True{} : Bool}
  {S.min_first(x <> y <> Nil{}) == x <> y <> Nil{} : List<&2, Nat>}

law min_first_swap:
  for x: Nat
  for y: Nat
  for e: {P.le(x, y) == False{} : Bool}
  {S.min_first(x <> y <> Nil{}) == y <> x <> Nil{} : List<&2, Nat>}

law min_first_len:
  for +xs: List<&2, Nat>
  {P.len(S.min_first(xs)) == P.len(xs) : Nat}
