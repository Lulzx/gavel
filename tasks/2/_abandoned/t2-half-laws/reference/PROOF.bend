import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Both laws are the definitional unfolding of `half`, so both proofs are the
# reflexive one. That is the defect: the corpus carries no evidence of work, and
# the task's invariant check refuses it (V3).
def L.half_zero():
  {==}

def L.half_succ(p):
  {==}
