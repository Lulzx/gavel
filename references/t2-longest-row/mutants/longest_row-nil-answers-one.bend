import Base
import ./prelude.bend as P

# `longest_row` answers `1n` on the empty list of rows.
#
# This file exists for `longest_row_nil`, which no other mutant in the corpus
# fails. `longest_row_nil` is the pin on the empty case, and the empty case is
# an *answer*: the generated rules rewrite a step, and there is no step here to
# rewrite. `longest_row_cons` cannot see it either, since its left-hand side is
# a cons.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `longest_row_map_len`, `longest_row_nil`.
def map_len(xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  match xss:
    case Nil{}:
      Nil{}
    case l <> t:
      P.len(l) <> map_len(t)

def longest_row(xss: List<&2, List<&2, Nat>>) -> Nat:
  match xss:
    case Nil{}:
      1n
    case l <> t:
      P.max(P.len(l), longest_row(t))
