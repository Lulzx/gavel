import Base
import ./prelude.bend as P

def split_at(n: Nat, xs: List<&2, Nat>) -> P.Duo:
  match n:
    case 0n:
      P.MkDuo{Nil{}, xs}
    case 1n++p:
      match xs:
        case Nil{}:
          P.MkDuo{h <> P.left_half(split_at(p, t)), P.right_half(split_at(p, t))}

        case h <> +t:
          P.MkDuo{Nil{}, Nil{}}
