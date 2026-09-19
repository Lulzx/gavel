import Base
import ./prelude.bend as P

# ESCAPE PROBE. An independently invented body: the walk as a policy would
# write it, with the one mistake a counter-walk invites. When the element in hand
# starts a new run, this body carries `0n` rather than `1n` as the length that
# run has reached -- "the element is not in the run yet, so the run is empty" --
# and every run after the first therefore comes out one short. The reference
# counts the element in the run as it starts it.
#
# The probe exists to ask whether the laws notice. The first run is still
# right, since it is opened by `run_lengths` itself, and every law about a run
# that has already been entered is satisfied -- which is why this is not a
# degenerate attempt but a plausible one. `run_lengths_go_last_alone` is the law
# that carries the same fact at the end of the list, and `run_lengths_three`
# reads a list whose second run is one element long, so the two agree here.
#
# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.i1.json check
# t2-run-lengths --solution <this file> --proof references/t2-run-lengths/PROOF.bend
# --backend plain --json`: **tier 3**, `laws_failed = ["run_lengths_go_fresh"]`.
# The law that carries the fact is the fresh step, which is where the law set
# reads `1n`; the probe is not an escape, and the law set has no hole here.
def run_lengths_go(t: List<&2, Nat>, cont: Bool, cur: Nat, h: Nat) -> List<&2, Nat>:
  match t:
    case Nil{}:
      match cont:
        case True{}:
          (1n + cur) <> Nil{}
        case False{}:
          cur <> (1n <> Nil{})
    case +h2 <> +t2:
      match cont:
        case True{}:
          run_lengths_go(t2, P.same(h, h2), 1n + cur, h2)
        case False{}:
          cur <> run_lengths_go(t2, P.same(h, h2), 0n, h2)

def run_lengths(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      match t:
        case Nil{}:
          1n <> Nil{}
        case +h2 <> +t2:
          run_lengths_go(t2, P.same(h, h2), 1n, h2)
