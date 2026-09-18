import Base

# `add` answers its second argument: the recursion is present and the base case
# is the reference's, the step just returns `b`. This is the body the law's own
# comment describes as the reason the law was written the way it was -- against
# a step law it would satisfy the goal by answering `1n+y == 1n+y`, and against
# `add_plus` it has to answer `y == x + y`.
# Measured: `proof_tier=2 bare_tier=2`, nothing proven, first failure at
# `LAWS.add_plus`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      b
    case 1n+p:
      b
