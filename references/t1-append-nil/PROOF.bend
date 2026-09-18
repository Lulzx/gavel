import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def L.append_nil(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %L.append_nil(t) : {h <> S.append(t, Nil{}) == h <> _ : List<Nat>}
      {==}
