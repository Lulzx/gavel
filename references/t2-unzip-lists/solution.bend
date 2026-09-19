import Base
import ./prelude.bend as P

def unzip(ps: List<&2, P.Pair>) -> P.ZP:
  match ps:
    case Nil{}:
      P.MkZ{Nil{}, Nil{}}
    case +h <> +t:
      P.MkZ{P.pfst(h) <> P.zfst(unzip(t)), P.psnd(h) <> P.zsnd(unzip(t))}
