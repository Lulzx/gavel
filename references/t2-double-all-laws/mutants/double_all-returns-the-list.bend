import Base

# The list is handed back unchanged: the identity body. `double_all_single`
# asks for `(h + h) <> Nil{}` and gets `h <> Nil{}`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.double_all_single`.
def double_all(xs: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      xs
