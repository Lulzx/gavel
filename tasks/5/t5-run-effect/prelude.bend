import Base

# A straight-line machine. The instruction set is two operations, and a program
# is a list of them; the machine itself holds one number, the accumulator. What
# makes this a program rather than an arithmetic expression is that the same
# text is read two ways -- `run` executes it, `effect` summarises it without
# running it -- and the laws are the claim that the summary is correct.
type Instr is Data:
  Inc{}
  Add{n: Nat}

# Concatenation. `<>` in Bend is the list *constructor*, not append: `x <> xs`
# puts `x` on the front of `xs`, so gluing two programs needs a def of its own.
# It lives in the prelude rather than in the solution because both `run` and
# `effect` are read against it, and a law stated over the policy's own append
# would be a law about the policy's code rather than about the machine.
def cat(p: List<&2, Instr>, q: List<&2, Instr>) -> List<&2, Instr>:
  match p:
    case Nil{}:
      q
    case h <> t:
      h <> cat(t, q)
