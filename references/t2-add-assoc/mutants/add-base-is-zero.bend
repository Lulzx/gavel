import Base

# The base case answers `0n` instead of the second argument, as if addition
# never contributed the addend at the bottom. `add_one` catches it at `x = 0n`;
# the associativity law does not, because both sides of `add_assoc` shift their
# second argument the same way -- the base case is invisible to it.
# Measured: `proof_tier=3 bare_tier=2`, proven ['add_assoc'], first failure
# at `LAWS.add_one`.
def add(a: Nat, b: Nat) -> Nat:
  match a:
    case 0n:
      0n
    case 1n+p:
      1n + add(p, b)
