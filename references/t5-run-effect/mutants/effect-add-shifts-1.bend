import Base
import ./prelude.bend as P

# `Add{n}` is read as `n + 1`. Both readings of the program are changed
# together, so `run` and `effect` still agree and both program-level laws still
# hold; what is left to disagree is the pins, which name the instruction's
# number rather than the relation between the two functions.
def step(s: Nat, i: P.Instr) -> Nat:
  match i:
    case P.Inc{}:
      1n + s
    case P.Add{n}:
      1n + n + s

def run(prog: List<&2, P.Instr>, s: Nat) -> Nat:
  match prog:
    case Nil{}:
      s
    case h <> t:
      run(t, step(s, h))

def effect(prog: List<&2, P.Instr>) -> Nat:
  match prog:
    case Nil{}:
      0n
    case P.Inc{} <> t:
      1n + effect(t)
    case P.Add{n} <> t:
      1n + n + effect(t)
