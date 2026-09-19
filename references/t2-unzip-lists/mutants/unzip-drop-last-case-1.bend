import Base
import ./prelude.bend as P

def unzip(ps: List<&2, P.Pair>) -> P.ZP:
  match ps:
    case Nil{}:
      P.MkZ{Nil{}, Nil{}}
