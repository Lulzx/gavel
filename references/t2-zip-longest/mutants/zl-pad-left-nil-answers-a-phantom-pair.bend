# Measured 2026-09-19, `uv run gavel --manifest manifest.scratch.g3.json check
# t2-zip-longest --solution
# references/t2-zip-longest/mutants/zl-pad-left-nil-answers-a-phantom-pair.bend
# --proof references/t2-zip-longest/PROOF.bend --backend plain --json`:
# **tier 3**, laws_failed = [zl_pad_left_nil, zip_longest_nil_nil,
# zip_longest_equal_lengths, zip_longest_pads_the_left]. The left-padding walk
# emits a pair when there is nothing left to pad. `zl_pad_left_cons` still holds
# -- the step is untouched -- so the error shows up only where the walk actually
# reaches its nil arm: at `zip_longest(Nil{}, Nil{}, d)`, where it is the whole
# answer, and at the end of the two closed runs that go through it. Recorded
# here because it is the only measurement of `zl_pad_left_nil` and of
# `zip_longest_nil_nil`.
import Base
import ./prelude.bend as P

def zl_pad_left(ys: List<&2, Nat>, +d: Nat) -> List<&2, P.Pair>:
  match ys:
    case Nil{}:
      P.MkPair{d, d} <> Nil{}
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
      zl_pad_left(ys, d)
    case hx <> tx:
      match ys:
        case Nil{}:
          P.MkPair{hx, d} <> zl_pad_right(tx, d)
        case hy <> ty:
          P.MkPair{hx, hy} <> zip_longest(tx, ty, d)
