# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g3.json check
# t2-zip-longest --solution
# references/t2-zip-longest/mutants/zl-pad-right-nil-answers-a-phantom-pair.bend
# --proof references/t2-zip-longest/PROOF.bend --backend plain --json`:
# **tier 3**, laws_failed = [zl_pad_right_nil, zip_longest_pads_the_right]. The
# mirror of the mutant above, and its reading is narrower for a reason worth
# recording: `zip_longest_nil_nil` goes through the *left* walk, so this arm is
# invisible to it, and the law that names the right walk is the only one that
# reaches it besides the closed run that ends on the right. Neither pad walk has
# a closed value of its own here; the answer's laws are what expose them.
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
      P.MkPair{d, d} <> Nil{}
    case h <> t:
      P.MkPair{h, d} <> zl_pad_right(t, d)

def zip_longest(xs: List<&2, Nat>, ys: List<&2, Nat>, +d: Nat) -> List<&2, P.Pair>:
  match xs:
    case Nil{}:
      zl_pad_left(ys, d)
    case hx <> tx:
      match ys:
        case Nil{}:
          P.MkPair{hx, d} <> zl_pad_right(tx, d)
        case hy <> ty:
          P.MkPair{hx, hy} <> zip_longest(tx, ty, d)
