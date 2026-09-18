import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The auxiliary fact the length law needs: putting one more element on the front
# of every prefix is a step of `P.cons_all`, and it does not change how many
# prefixes there are, because `P.cons_all` maps a non-empty outer list to a
# non-empty one of the same length. It is an induction on the outer list.
def Policy.llen_cons_all(x: Nat, ps: P.Prefixes) -> {P.llen(P.cons_all(x, ps)) == P.llen(ps) : Nat}:
  match ps:
    case P.PNil{}:
      {==}
    case P.PCons{p, rest}:
      %Policy.llen_cons_all(x, rest) : {1n + P.llen(P.cons_all(x, rest)) == 1n + _ : Nat}
      {==}

def L.prefixes_nil():
  {==}

def L.prefixes_cons(h, t):
  {==}

# The step is one unfolding of `P.cons_all` and then the auxiliary fact, which
# is what brings the hypothesis's subject back into view.
def L.prefixes_len(xs):
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, P.llen(P.cons_all(h, S.prefixes(t))), P.llen(S.prefixes(t)), Policy.llen_cons_all(h, S.prefixes(t)))
          : {1n + _ == 1n + P.len(h <> t) : Nat}
      %Equal.sym(Nat, P.llen(S.prefixes(t)), 1n + P.len(t), L.prefixes_len(t))
          : {1n + _ == 1n + P.len(h <> t) : Nat}
      {==}
