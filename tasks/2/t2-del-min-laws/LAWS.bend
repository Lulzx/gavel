import Base
import ./prelude.bend as P
import ./solution.bend as S

law del_min_nil:
  {S.del_min(Nil{}) == Nil{} : List<&2, Nat>}

law del_min_single:
  for x: Nat
  {S.del_min(x <> Nil{}) == Nil{} : List<&2, Nat>}

law del_min_keep:
  for x: Nat
  for y: Nat
  for +t: List<&2, Nat>
  for e: {P.le(x, P.min_go(y <> t, y)) == True{} : Bool}
  {S.del_min(x <> y <> t) == y <> t : List<&2, Nat>}

law del_min_drop:
  for x: Nat
  for y: Nat
  for +t: List<&2, Nat>
  for e: {P.le(x, P.min_go(y <> t, y)) == False{} : Bool}
  {S.del_min(x <> y <> t) == x <> S.del_min(y <> t) : List<&2, Nat>}

law del_min_len:
  for h: Nat
  for +t: List<&2, Nat>
  {P.len(S.del_min(h <> t)) == P.len(t) : Nat}
