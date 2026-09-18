import Base
import ./prelude.bend as P

# `run` hands back the state it was given, so the program is never executed.
# This is the degenerate body `run_compose` cannot see: under it that law reads
# `s == s`, and `effect_hom` is an equation between two copies of the same body.
# `run_inc` is the law with an opinion, because the accumulator a single
# instruction produces is not the accumulator the machine was given.
def step(s: Nat, i: P.Instr) -> Nat:
  match i:
    case P.Inc{}:
      1n + s
    case P.Add{n}:
      n + s

def run(prog: List<&2, P.Instr>, s: Nat) -> Nat:
  s

def effect(prog: List<&2, P.Instr>) -> Nat:
  match prog:
    case Nil{}:
      0n
    case P.Inc{} <> t:
      1n + effect(t)
    case P.Add{n} <> t:
      n + effect(t)
