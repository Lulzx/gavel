import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The law has no binders: the width of the argument is the constant `Nil{}`, the
# reference body matches on the list and takes its empty case, and both sides
# are the sentinel leaf.
def L.build_nil():
  {==}

# The list in the law is `h <> t`, which the reference body's match steps into
# its cons case with the head and the tail already in scope; the two sides are
# then the same term.
def L.build_cons(h, t):
  {==}

# The induction is on the list. Its empty case is the sentinel leaf on both
# sides. Its successor case unfolds the answer into a node, so the goal is
# `1n + P.leaves(build(t)) == 1n + (1n + P.len(t))`; the rewrite needs
# `Equal.sym` because the hypothesis points the other way -- it states
# `P.leaves(build(t)) == 1n + P.len(t)`, and what has to come out of the goal is
# the `P.leaves(build(t))` occurrence.
def L.build_leaves(bs):
  match bs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, P.leaves(S.build(t)), 1n + P.len(t), L.build_leaves(t)) :
          {1n + _ == 1n + (1n + P.len(t)) : Nat}
      {==}

# The same induction as `build_leaves`, with `P.right_spine` in place of
# `P.leaves`; both are a sum at a node, so the step is the same rewrite.
def L.build_right_spine(bs):
  match bs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, P.right_spine(S.build(t)), 1n + P.len(t), L.build_right_spine(t)) :
          {1n + _ == 1n + (1n + P.len(t)) : Nat}
      {==}

# `P.rightmost` and `P.last_or_zero` both ignore the head and both step on the
# tail, so the goal after unfolding is the hypothesis at the tail itself.
def L.build_last(bs):
  match bs:
    case Nil{}:
      {==}
    case h <> t:
      L.build_last(t)
