import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The law has one binder, the number, and the width is the constant `0n`, so
# there is nothing to induct on: the reference body matches on the width and
# takes its empty case, and both sides are the empty list.
def L.nat_bits_zero(n):
  {==}

# The width in the law is `1n + w`, which the reference body's match steps into
# its successor case with `p` bound to `w`; the two sides are then the same term
# with the number halved on both.
def L.nat_bits_succ(w, n):
  {==}

# The induction is on the width. Its successor case unfolds the answer into a
# cons, so the goal is `1n + P.len(nat_bits(p, Nat.div(n, 2n))) == 1n + p`. The
# rewrite needs `Equal.sym` because the hypothesis points the other way: it
# states `P.len(nat_bits(...)) == p`, and what has to come out of the goal is the
# `P.len(nat_bits(...))` occurrence. Note that the hypothesis is cited at the
# halved number -- such a term is available because the number is quantified
# alongside the width in the law, not fixed by the match.
def L.nat_bits_len(w, n):
  match w:
    case 0n:
      {==}
    case 1n+p:
      %Equal.sym(Nat, P.len(S.nat_bits(p, Nat.div(n, 2n))), p, L.nat_bits_len(p, Nat.div(n, 2n))) :
          {1n + _ == 1n + p : Nat}
      {==}
