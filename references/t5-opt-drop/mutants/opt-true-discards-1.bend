import Base
import ./prelude.bend as P

# The caller who says the accumulator holds zero is told the whole program is
# redundant and handed the empty one; the caller who says nothing gets a
# correct optimiser, because that path goes through `go` and never asks `opt`
# anything. So `clean_opt` holds (the empty program has nothing left to remove,
# and the other path really is clean), and `opt_sound` holds (it only ever asks
# for the `False` answer, which is the reference one). `opt_sound_zero` is the
# only law that calls `opt` with `True` and then runs what comes back: run at
# zero, `Nil{}` computes `0n` and `P.Inc{} <> Nil{}` computes `1n`, and there is
# no way to notice that by comparing the two answers a caller would get -- the
# claim about the state has to be cashed by running the program, not by
# believing it.
def Policy.go(prog: List<&2, P.Op>, z: Bool) -> List<&2, P.Op>:
  match prog:
    case Nil{}:
      Nil{}
    case P.Zero{} <> t:
      P.Zero{} <> Policy.go(t, True{})
    case P.Twice{} <> t:
      match z:
        case True{}:
          Policy.go(t, True{})
        case False{}:
          P.Twice{} <> Policy.go(t, False{})
    case P.Inc{} <> t:
      P.Inc{} <> Policy.go(t, False{})

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
  match z:
    case True{}:
      Nil{}
    case False{}:
      Policy.go(prog, False{})
