import Base
import ./prelude.bend as P

# The walk. `t` is what is left to read -- it comes first because the checker
# reads a recursive call's arguments left to right and asks that each be passed
# on unchanged until one shrinks -- `cont` says whether the element `h` in hand
# continues the run that ended at the element before it, and `cur` is the length
# that run had reached by the time it got there. A `match` cannot scrutinise a
# computed value in Bend, so the comparison the step has to branch on is decided
# where both elements are in hand -- the element just read and the next one,
# which the nested match below exposes -- and handed to the recursion as an
# argument. That is why the decision is a parameter rather than a `match` on
# `P.same`: the walk never matches a comparison it computed itself.
def run_lengths_go(t: List<&2, Nat>, cont: Bool, cur: Nat, h: Nat) -> List<&2, Nat>:
  match t:
    case Nil{}:
      match cont:
        case True{}:
          (1n + cur) <> Nil{}
        case False{}:
          cur <> (1n <> Nil{})
    case +h2 <> +t2:
      match cont:
        case True{}:
          run_lengths_go(t2, P.same(h, h2), 1n + cur, h2)
        case False{}:
          cur <> run_lengths_go(t2, P.same(h, h2), 1n, h2)

# The answer. An empty list has no runs. A singleton is one run of one element,
# and it is answered here rather than by the walk because the walk needs a second
# element in hand before its first comparison is decided. A longer list opens the
# first run at `1n` -- the head is in it and nothing is known to continue it --
# and hands the second element and the rest to the walk with the comparison of
# the two heads decided.
def run_lengths(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      match t:
        case Nil{}:
          1n <> Nil{}
        case +h2 <> +t2:
          run_lengths_go(t2, P.same(h, h2), 1n, h2)
