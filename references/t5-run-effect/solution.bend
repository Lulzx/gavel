import Base
import ./prelude.bend as P

def step(s: Nat, i: P.Instr) -> Nat:
  match i:
    case P.Inc{}:
      1n + s
    case P.Add{n}:
      n + s

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
      n + effect(t)
