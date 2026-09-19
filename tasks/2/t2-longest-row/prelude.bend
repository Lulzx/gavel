import Base

# Immutable, and owned by the task rather than the policy: the interaction law
# below is stated in terms of all three, so the policy's two functions may lean
# on them. Each matches on its first argument -- `max` on both of its at once --
# which is what makes a goal about one of them at a variable stuck.
def len(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

def max(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      1n + bp
    case 1n+ap 0n:
      1n + ap
    case 1n+ap 1n+bp:
      1n + max(ap, bp)

def max_list(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      max(h, max_list(t))
