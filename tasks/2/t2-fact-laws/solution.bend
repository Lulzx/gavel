import Base
import ./prelude.bend as P

# TODO(policy): implement both. `fact(n)` is the product of the numbers `1`
# through `n`, with `fact(0n)` being `1n`; recurse on `n`, and note the step
# names the predecessor twice, so its pattern has to be written `1n++p`.
# `facts(xs)` is the list of the factorials of the elements of `xs`, in order,
# and it is a plain map: `Nil{}` answers `Nil{}` and a cons cell answers the
# factorial of its head onto the factorials of its tail. `P.len` is the
# prelude's and is immutable.
def fact(n: Nat) -> Nat:
  ?TODO

def facts(xs: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO
