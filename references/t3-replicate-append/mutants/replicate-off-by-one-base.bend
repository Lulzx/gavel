import Base

# The empty case is off by one: zero copies comes back with one copy in it, so
# every run is one longer than its count. The generated body changes the other
# direction (`case 1n:` for the whole match), and this one keeps the reference's
# successor case, which is what makes the two different probes of the same law.
# Measured: `proof_tier=3 bare_tier=2`, `rev_replicate` proven and
# `replicate_len` failing first.
def replicate(n: Nat, +x: Nat) -> List<Nat>:
  match n:
    case 0n:
      x <> Nil{}
    case 1n+k:
      x <> replicate(k, x)
