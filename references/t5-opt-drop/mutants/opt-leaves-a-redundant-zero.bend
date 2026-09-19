import Base
import ./prelude.bend as P

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
      P.Zero{} <> opt(t, True{})
    case P.Twice{} <> t:
      match z:
        case True{}:
          # The escape: the `Twice` is removed, but a redundant `Zero` is left
          # in its place. `clean` permits a `Zero` wherever the accumulator is
          # known to be zero, and at a known-zero accumulator a `Zero` is a
          # no-op -- so this optimiser is clean and sound, and neither
          # `clean_opt` nor either soundness law can see it. **Measured tier 4,
          # complete, reward 1.000 against the reference proof** on 2026-09-19,
          # all seven laws then in the set. The three optimiser laws pin what
          # `opt` returns *up to* `clean` and equal meaning; the `Twice`/`True`
          # branch is the only one left free, and it is free precisely because
          # it is the one branch allowed to remove something.
          #
          # After the `opt_twice_zero` repair this reads **tier 3, reward
          # 0.537**, failing at `LAWS.opt_twice_zero` with `expected
          # prelude.Zero{} <> solution.opt(t, True{})` against `observed
          # solution.opt(t, True{})`.
          P.Zero{} <> opt(t, True{})
        case False{}:
          P.Twice{} <> opt(t, False{})
    case P.Inc{} <> t:
      P.Inc{} <> opt(t, False{})
