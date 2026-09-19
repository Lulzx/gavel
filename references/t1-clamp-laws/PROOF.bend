import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# No induction and no rewriting: every law hands its branch's decision in as a
# literal, so the cascade takes its case and both sides are the same term. This
# is also why the laws are stated over the decisions rather than over `P.le` of
# the three numbers -- a law that carried `P.le(x, lo) == True{}` as a premise
# would need its proof to rewrite the goal, and the goal's unfolded shape is
# then fixed by the prelude, which leaves no room for a body that answers a
# different branch to be *checked* rather than rejected.

# The first decision is `True{}`, so the outer match takes its first case.
def L.clamp_below(x, lo, hi, khi):
  {==}

# The first decision is `False{}` and the second is `True{}`, so the cascade
# reaches the middle case.
def L.clamp_above(x, lo, hi):
  {==}

# Both decisions are `False{}`, so the cascade falls through to the value.
def L.clamp_inside(x, lo, hi):
  {==}
