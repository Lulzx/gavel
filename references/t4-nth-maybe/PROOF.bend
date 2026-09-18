import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The transports: from an equation between the two booleans anything follows,
# because every value is equal to itself once the two are identified. The trick
# is the one the queue proof uses -- an `ite` indexed by the boolean, so that
# `Equal.cong` carries the equation `{False{} == True{}}` to the equation
# between the two values. Two of them, because the branches that need it produce
# goals of two different types: a `Bool` (the `Some` law) and a `Maybe<&2, Nat>`
# (the `None` law). Neither is a law and neither cites one.

def Policy.bool_ite(c: Bool, x: Bool, y: Bool) -> Bool:
  match c:
    case True{}:
      x
    case False{}:
      y

def Policy.maybe_ite(c: Bool, x: Maybe<&2, Nat>, y: Maybe<&2, Nat>) -> Maybe<&2, Nat>:
  match c:
    case True{}:
      x
    case False{}:
      y

def Policy.absurd_bool(L: Bool, R: Bool, e: {False{} == True{} : Bool}) -> {L == R : Bool}:
  Equal.cong(Bool, Bool, c => Policy.bool_ite(c, R, L), False{}, True{}, e)

def Policy.absurd_maybe(L: Maybe<&2, Nat>, R: Maybe<&2, Nat>, e: {False{} == True{} : Bool})
    -> {L == R : Maybe<&2, Nat>}:
  Equal.cong(Bool, Maybe<&2, Nat>, c => Policy.maybe_ite(c, R, L), False{}, True{}, e)

# The two clauses are the unfolding of `nth` at a constructor. Nothing beyond
# `{==}` is needed for either: the index is matched first, so `0n` and `1n + p`
# are what makes both sides compute.
def L.nth_zero(h, t):
  {==}

def L.nth_succ(k, h, t):
  {==}

# In range means the answer is there. The proof is a case split on the index and
# then on the list, and the premise is what carries the induction: at `1n + p`
# the hypothesis wants `{Nat.is_lt(p, P.len(t)) == True{}}`, and the binder `e`
# has type `{Nat.is_lt(1n + p, P.len(h <> t)) == True{}}` -- `P.len` and
# `Nat.cmp` both reduce through the `1n` on the two sides, so the checker
# accepts `e` at the smaller index without a lemma. On the empty list the
# premise has reduced to `{False{} == True{}}` and there is nothing true to
# prove it with, so the goal follows from it by transport.
def L.nth_some(k, xs, e):
  match k:
    case 0n:
      match xs:
        case Nil{}:
          Policy.absurd_bool(P.is_some(S.nth(0n, Nil{})), True{}, e)
        case h <> t:
          {==}
    case 1n+p:
      match xs:
        case Nil{}:
          Policy.absurd_bool(P.is_some(S.nth(1n + p, Nil{})), True{}, e)
        case h <> t:
          L.nth_some(p, t, e)

# Out of range means the answer is missing. The same case split, with the two
# roles of the premise exchanged: on the empty list the premise reduces to
# `{False{} == False{}}`, which is the goal's own unfolding after one step, so
# `{==}` closes it; on the cons at `1n + p` the hypothesis takes `e` at the
# smaller index exactly as above; and on the cons at `0n` the premise has become
# `{True{} == False{}}` -- the index is in range where the law says it is not --
# so the goal follows by transport, with the equation flipped because the
# binder is an equation between `True{}` and `False{}` in that order.
def L.nth_none(k, xs, e):
  match k:
    case 0n:
      match xs:
        case Nil{}:
          {==}
        case h <> t:
          Policy.absurd_maybe(S.nth(0n, h <> t), None{}, Equal.sym(Bool, True{}, False{}, e))
    case 1n+p:
      match xs:
        case Nil{}:
          {==}
        case h <> t:
          L.nth_none(p, t, e)
