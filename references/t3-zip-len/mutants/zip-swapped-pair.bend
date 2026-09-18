import Base
import ./prelude.bend as P

# PROBE: the pair components are swapped, so every pair is in the wrong order
# while the list of pairs has the right length. The zip law's comment names this
# body, so the question is whether the added `zip_cons` law closes it: both nil
# laws and the length law are measures and cannot tell one component from the
# other. Measured: caught -- `proof_tier=3 bare_tier=2`, with `zip_nil_l`,
# `zip_nil_r` and `zip_len` proven and `zip_cons` failing first. The pairing
# law is what closes the hole this body used to fall through, so it ships as a
# corpus entry recording that the three measure laws alone would not.
def zip(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, P.P2>:
  match xs:
    case Nil{}:
      Nil{}
    case hx <> tx:
      match ys:
        case Nil{}:
          Nil{}
        case hy <> ty:
          P.Mk{hy, hx} <> zip(tx, ty)
