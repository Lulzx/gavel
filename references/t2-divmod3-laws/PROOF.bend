import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `shift` leaves the remainder alone, so the remainder of a step is the
# remainder of the answer it stepped from. It is not a law: a law that cited
# one would make the credit for both depend on the citation. It is definitional
# -- `shift` and `snd` both step on the pair -- so the proof is one reduction
# per field, and `p` is a parameter rather than a variable to match.
def Policy.snd_shift(p: P.Pair) -> {P.snd(P.shift(p)) == P.snd(p) : Nat}:
  match p:
    case P.MkPair{q, r}:
      {==}

# The input is a literal `0n`, which is the first case of the match.
def L.divmod3_zero():
  {==}

# `1n` is the second case, and it answers a literal pair.
def L.divmod3_one():
  {==}

# `2n` is the third case, and it answers a literal pair.
def L.divmod3_two():
  {==}

# `3n + k` is a successor three deep, so the match takes the step case and both
# sides are `P.shift(S.divmod3(k))`.
def L.divmod3_succ3(k):
  {==}

# Inductive in `n`. The step leaves the remainder of `P.shift(S.divmod3(k))`
# against the bound at `3n`, and the fact about `shift` says that is the
# remainder of `S.divmod3(k)` -- which is the hypothesis at `k` on the nose. The
# fact has to be read backwards: `Equal.sym` states it with `S.divmod3(k)`
# first, so the term the goal holds is the one a rewrite replaces.
def L.divmod3_rem(n):
  match n:
    case 0n:
      {==}
    case 1n:
      {==}
    case 2n:
      {==}
    case 3n++k:
      %Equal.sym(Nat, P.snd(P.shift(S.divmod3(k))), P.snd(S.divmod3(k)), Policy.snd_shift(S.divmod3(k))) :
          {Nat.is_lt(_, 3n) == True{} : Bool}
      %L.divmod3_rem(k) : {Nat.is_lt(P.snd(S.divmod3(k)), 3n) == _ : Bool}
      {==}
