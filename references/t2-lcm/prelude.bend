import Base

# Immutable, and owned by the task rather than the policy. `lcm` and `lcm_go`
# are what the policy implements; `is_zero` and `divides` are here because the
# walk has to answer a question about a remainder, and a `match` cannot
# scrutinise a computed value.

def is_zero(n: Nat) -> Bool:
  match n:
    case 0n:
      True{}
    case 1n+p:
      False{}

# `divides(a, b)` is `b` goes into `a` exactly. It compares a term rather than
# matching on one, which is what keeps the step law below definitional: with
# variables on both sides the test is stuck, so both sides of the law unfold the
# same way instead of one of them computing.
def divides(a: Nat, b: Nat) -> Bool:
  is_zero(Nat.mod(a, b))
