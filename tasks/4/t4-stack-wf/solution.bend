import Base
import ./prelude.bend as P

# TODO(policy): one step of the machine -- read `s` and push it onto the stack.
# `P.snoc` is the prelude's push; `xs` is used in both branches, so it needs to
# be declared `+` if you write the body in terms of it.
def step(xs: List<&2, P.Sym>, s: P.Sym) -> List<&2, P.Sym>:
  ?TODO
