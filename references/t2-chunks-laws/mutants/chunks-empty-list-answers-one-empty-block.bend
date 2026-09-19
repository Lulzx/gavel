import Base
import ./prelude.bend as P

def chunks_go(xs: List<&2, Nat>, +n: Nat, k: Nat, cur: List<&2, Nat>, out: List<&2, List<&2, Nat>>) -> List<&2, List<&2, Nat>>:
  match xs:
    case Nil{}:
      P.push(out, cur)
    case h <> t:
      match k:
        case 0n:
          chunks_go(t, n, Nat.sub(n, 1n), h <> Nil{}, P.push(out, cur))
        case 1n++j:
          chunks_go(t, n, j, P.snoc(cur, h), out)

# The reference with the empty-list arm answering a list holding one empty
# block, which is the reading "there is always at least one block". It is the
# hand-written evidence for `chunks_nil`, which no generated mutant reaches --
# the generator rewrites a step, and this arm is an answer reached by a match
# that has stopped. It also fails `chunks_zero`, because the size arm is not
# looked at until the list arm has been.
# Measured: `proof_tier=3 bare_tier=2`, first failure at `LAWS.chunks_nil`
# (also caught by `LAWS.chunks_zero`).
def chunks(xs: List<&2, Nat>, +n: Nat) -> List<&2, List<&2, Nat>>:
  match xs:
    case Nil{}:
      Nil{} <> Nil{}
    case h <> t:
      match n:
        case 0n:
          Nil{}
        case 1n++j:
          chunks_go(t, n, Nat.sub(n, 1n), h <> Nil{}, Nil{})
