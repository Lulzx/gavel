# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g3.json check
# t2-zip-longest --solution
# references/t2-zip-longest/mutants/zip-longest-stops-at-the-shorter-list.bend
# --proof references/t2-zip-longest/PROOF.bend --backend plain --json`:
# **tier 3**, laws_failed = [zip_longest_nil_cons, zip_longest_cons_nil,
# zip_longest_pads_the_right, zip_longest_pads_the_left]. An ordinary `zip`:
# both nil arms answer `Nil{}` and the padding walks are never called. The two
# hand-off laws are what refuse it, exactly as their text claims -- a body that
# stopped at the shorter list answers the empty list on their right-hand sides.
import Base
import ./prelude.bend as P

def zl_pad_left(ys: List<&2, Nat>, +d: Nat) -> List<&2, P.Pair>:
  match ys:
    case Nil{}:
      Nil{}
    case h <> t:
      P.MkPair{d, h} <> zl_pad_left(t, d)

def zl_pad_right(xs: List<&2, Nat>, +d: Nat) -> List<&2, P.Pair>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      P.MkPair{h, d} <> zl_pad_right(t, d)

def zip_longest(xs: List<&2, Nat>, ys: List<&2, Nat>, +d: Nat) -> List<&2, P.Pair>:
  match xs:
    case Nil{}:
      Nil{}
    case hx <> tx:
      match ys:
        case Nil{}:
          Nil{}
        case hy <> ty:
          P.MkPair{hx, hy} <> zip_longest(tx, ty, d)
