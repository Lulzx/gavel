import Base
import ./prelude.bend as P

# `Inc` bumps the accumulator by two. Only the pins can see this: `run` and
# `effect` are both built on `step`, so the two readings of the program stay in
# agreement and both program-level laws still hold. `step_inc` and `run_inc` are
# the two that name the number, and they are why the pins exist at all.
def step(s: Nat, i: P.Instr) -> Nat:
  match i:
    case P.Inc{}:
      1n + 1n + s
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
      1n + 1n + effect(t)
    case P.Add{n} <> t:
      n + effect(t)
