import Base
import ./prelude.bend as P

# `run` executes the first instruction and stops. Both singleton pins hold,
# since a one-instruction program has no tail to drop, and `effect` is the
# reference one, so every pin and the summary's own homomorphism are satisfied.
# What fails is `run_compose`: running a concatenation has to be running the
# halves in turn, and the tail here is never run at all.
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
      step(s, h)

def effect(prog: List<&2, P.Instr>) -> Nat:
  match prog:
    case Nil{}:
      0n
    case P.Inc{} <> t:
      1n + effect(t)
    case P.Add{n} <> t:
      n + effect(t)
