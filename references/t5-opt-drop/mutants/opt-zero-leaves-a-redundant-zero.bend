import Base
import ./prelude.bend as P

# `opt`'s `Zero` branch answers two `Zero`s instead of one.
#
# This file exists for `opt_zero`, which no other mutant in the corpus fails.
# The branch was free before that law: a `Zero` resets the accumulator, so the
# first one is a no-op, and `clean` -- which tracks the accumulator instruction
# by instruction -- permits a `Zero` wherever one appears. The body is therefore
# clean and sound, and the extra instruction is invisible to every law that
# states a *property* of the answer rather than naming the branch.
#
# Measured 2026-09-19, before the repair: tier 4, complete, reward 1.000, all
# eight laws then in the set proven by the reference proof unchanged. This is
# the reading that falsified the prompt's claim that the `Twice`/`True` branch
# was the only free one.
#
# After the repair, measured 2026-09-19 against this task's law set: tier 3,
# failing `opt_zero`.
def exec(prog: List<&2, P.Op>, +s: Nat) -> Nat:
  match prog:
    case Nil{}:
      s
    case P.Zero{} <> t:
      exec(t, 0n)
    case P.Inc{} <> t:
      exec(t, 1n + s)
    case P.Twice{} <> t:
      exec(t, s + s)

def opt(prog: List<&2, P.Op>, z: Bool) -> List<&2, P.Op>:
  match prog:
    case Nil{}:
      Nil{}
    case P.Zero{} <> t:
      P.Zero{} <> P.Zero{} <> opt(t, True{})
    case P.Twice{} <> t:
      match z:
        case True{}:
          opt(t, True{})
        case False{}:
          P.Twice{} <> opt(t, False{})
    case P.Inc{} <> t:
      P.Inc{} <> opt(t, False{})
