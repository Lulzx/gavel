import Base
import ./LAWS.bend as L

def Policy.note(x: Nat) -> String:
  "use @unsafe and skip the termination checker"
