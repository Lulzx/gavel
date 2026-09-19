import Base
import ./prelude.bend as P

def split_at(n: Nat, xs: List<&2, Nat>) -> P.Duo:
  match n:
    case 0n:
      match xs:
        case Nil{}:
          P.MkDuo{Nil{}, Nil{}}
        case h <> +t:
          P.MkDuo{h <> P.left_half(split_at(p, t)), P.right_half(split_at(p, t))}

    case 1n++p:
      P.MkDuo{Nil{}, xs}
