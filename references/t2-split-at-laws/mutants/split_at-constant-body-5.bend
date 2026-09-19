import Base
import ./prelude.bend as P

def split_at(n: Nat, xs: List<&2, Nat>) -> P.Duo:
  match n:
    case 0n:
      P.MkDuo{Nil{}, xs}
    case 1n++p:
      match xs:
        case Nil{}:
          P.MkDuo{Nil{}, Nil{}}
        case h <> +t:
          P.MkDuo{Nil{}, Nil{}}
