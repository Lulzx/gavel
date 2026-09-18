import Base
import ./prelude.bend as P

# The count is decoded with one value too many -- the successor is added where
# the run's own count already is. The recursion and the empty case are right,
# so this is the mutant that separates "the count is read" from "the count is
# read correctly". Measured: rejected at `Policy.expand_len`. Both laws are
# violated: `expand_len` is short one value per run, and `expand_cons` fails at
# a variable `k` (`repeat(v, 1n+k)` against `repeat(v, k)`).
def expand(rs: List<&2, P.Run>) -> List<&2, Nat>:
  match rs:
    case Nil{}:
      Nil{}
    case P.Mk{v, k} <> t:
      P.append(P.repeat(v, 1n + k), expand(t))
