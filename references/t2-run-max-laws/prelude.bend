import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the composition law; `run_max` is what the policy writes.

# `append` matches on its first argument, so with a variable list the goal does
# not reduce, and that is what leaves the composition law below to the induction
# rather than to the unfolding.
def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> append(t, ys)

# The larger of two numbers. It matches on both arguments at once, so with a
# variable in either position the goal does not reduce until something splits on
# it.
def max(a: Nat, b: Nat) -> Nat:
  match a b:
    case 0n 0n:
      0n
    case 0n 1n+bp:
      1n+bp
    case 1n+ap 0n:
      1n+ap
    case 1n+ap 1n+bp:
      1n+max(ap, bp)

# What the running maximum stands at after walking `xs` from `m`: the largest of
# `m` and everything walked. It steps its own running value exactly the way
# `run_max` does, so both sides of the composition law mention the same term and
# neither needs a lemma about `max`.
def after_max(xs: List<Nat>, m: Nat) -> Nat:
  match xs:
    case Nil{}:
      m
    case h <> t:
      after_max(t, max(m, h))
