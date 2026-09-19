import Base
import ./prelude.bend as P

# `opt`'s `Zero` branch emits a dead `Inc` in front of the `Zero`.
#
# The same hole as `opt-zero-leaves-a-redundant-zero.bend` on a different
# instruction: the `Inc` runs and is then thrown away by the `Zero` that
# follows, so `exec` cannot tell the two programs apart and neither can `clean`.
# A second body is kept because the two variants differ in *why* the inserted
# instruction is dead -- one is swallowed by the reset, the other is a
# duplicate -- and a law that pinned only one of them would still be a law the
# other escaped.
#
# Measured 2026-09-19, before the repair: tier 4, complete, reward 1.000, all
# eight laws then in the set proven by the reference proof unchanged.
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
      P.Inc{} <> P.Zero{} <> opt(t, True{})
    case P.Twice{} <> t:
      match z:
        case True{}:
          opt(t, True{})
        case False{}:
          P.Twice{} <> opt(t, False{})
    case P.Inc{} <> t:
      P.Inc{} <> opt(t, False{})
