import Base
import ./prelude.bend as P

# When the right list is exhausted, the left list's head is emitted and its
# tail is thrown away: the drain case looks like a single element rather than
# like what is left. `interleave_nil_r` fails definitionally -- `hx <> Nil{}`
# against `hx <> tx` at a variable `tx` -- and `interleave_len` is short by
# everything after the first leftover. Probed because the pair case's *order*
# is not pinned by any law in this set; this body is caught by the drain law
# instead, so the corpus does not rest on the unprotected direction.
def interleave(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case hx <> tx:
      match ys:
        case Nil{}:
          hx <> Nil{}
        case hy <> ty:
          hx <> hy <> interleave(tx, ty)
