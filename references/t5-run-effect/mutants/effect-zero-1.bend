import Base
import ./prelude.bend as P

# The summary of every program is zero. `effect_hom` is happy -- `0n == 0n + 0n`
# -- and so is any proof by reflexivity, because that law is an equation between
# two copies of the same body. What it cannot answer is `effect_add`, which
# names the instruction's own number, or `run_effect`, which would then ask
# `run` to leave the state alone.
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
  0n
