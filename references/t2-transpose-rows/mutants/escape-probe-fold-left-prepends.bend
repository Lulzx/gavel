import Base
import ./prelude.bend as P

# ESCAPE PROBE (alternative algorithm, not a perturbation). The transpose built
# as a left fold: walk the rows front to back and prepend each row's elements to
# the columns built so far. It is a plausible way to write the same idea -- the
# fold is the transpose read right-to-left -- and it produces the same columns
# with the rows in the opposite order inside each one.

def Policy.prepend_row(r: List<&2, Nat>, cols: List<&2, List<&2, Nat>>) -> List<&2, List<&2, Nat>>:
  match r:
    case Nil{}:
      cols
    case h <> t:
      match cols:
        case Nil{}:
          (h <> Nil{}) <> Policy.prepend_row(t, Nil{})
        case c <> cs:
          (h <> c) <> Policy.prepend_row(t, cs)

def Policy.xpose_go(rows: List<&2, List<&2, Nat>>, cols: List<&2, List<&2, Nat>>) -> List<&2, List<&2, Nat>>:
  match rows:
    case Nil{}:
      cols
    case r <> rs:
      Policy.xpose_go(rs, Policy.prepend_row(r, cols))

def insert_row(r: List<&2, Nat>, cols: List<&2, List<&2, Nat>>) -> List<&2, List<&2, Nat>>:
  Policy.prepend_row(r, cols)

def transpose(rows: List<&2, List<&2, Nat>>) -> List<&2, List<&2, Nat>>:
  Policy.xpose_go(rows, Nil{})
