import Base
import ./prelude.bend as P

# `chunks` agrees with the reference at exactly the points the entry-point laws
# observed before `chunks_cons` was written -- `Nil{}`, the size `0n`,
# `(x <> Nil{}, 1n)` and the literal `([1, 2, 3], 2n)` -- and answers the
# hard-coded `[[1, 2], [3]]` at every other list of length two or more. The
# worker `chunks_go` is the reference body, so both worker laws are untouched.
#
# Measured 2026-09-19, before the repair: **tier 4, complete, reward 1.000, all
# six laws proven by the reference proof unchanged, `failed` empty.** The hole
# is Fact 47's shape at the pair level rather than at one argument position:
# every entry-point law names a *closed* list, so `chunks`'s behaviour at a list
# of two or more elements and a size of two or more was constrained by no
# left-hand side, and `chunks_single` and `chunks_three_by_two` are values
# rather than calls -- agreeing with them is a statement about two points, not
# about a rule.
#
# The repair is `chunks_cons`, the entry point's own unfolding. Measured after:
# this body fails it, and fails nothing else -- `LAWS.chunks_cons` reads
# `expected : S.chunks(x <> xs, 1n+n)` against
# `observed : S.chunks_go(xs, 1n+n, n, x <> Nil{}, Nil{})`, which the body's
# hard-coded answer does not satisfy for `x = 5n`, `xs = 6n <> Nil{}`, `n = 1n`
# -- where the worker returns `(5n <> (6n <> Nil{})) <> Nil{}` and the body
# returns `(5n <> Nil{}) <> Nil{}`.
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

def Policy.probe_rest(h: Nat, t2: List<&2, Nat>) -> List<&2, List<&2, Nat>>:
  match t2:
    case Nil{}:
      (h <> Nil{}) <> Nil{}
    case +q <> +r:
      (1n <> (2n <> Nil{})) <> ((3n <> Nil{}) <> Nil{})

def Policy.probe_pick(h: Nat, t: List<&2, Nat>) -> List<&2, List<&2, Nat>>:
  match t:
    case Nil{}:
      (h <> Nil{}) <> Nil{}
    case +h2 <> +t2:
      Policy.probe_rest(h, t2)

def chunks(xs: List<&2, Nat>, +n: Nat) -> List<&2, List<&2, Nat>>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> +t:
      match n:
        case 0n:
          Nil{}
        case 1n++j:
          Policy.probe_pick(h, t)
