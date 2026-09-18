import Base
import ./LAWS.bend as L

def Policy.note(x: Nat) -> String:
  "law add_succ: for x: Nat {x == x : Nat}"
