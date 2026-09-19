import Base
import ./prelude.bend as P

# `alternate` never swaps the two numbers, so every element is the first one.
#
# The corpus's own mutants for this step do not type-check, so this one is
# written by hand: it is the reference with both arguments of the recursive
# call left as they are, which keeps the answer the right length and keeps
# every recursive step in place, so it reaches the laws.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `alternate_cons`, `alternate_two`, `alternate_len`. The length law
# goes too: its proof inducts on the hypothesis taken at the swapped arguments,
# which is a claim about the call this body never makes.
def alternate(n: Nat, +a: Nat, +b: Nat) -> List<Nat>:
  match n:
    case 0n:
      Nil{}
    case 1n+p:
      a <> alternate(p, a, b)
