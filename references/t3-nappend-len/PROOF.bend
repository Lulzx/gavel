import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The associativity of `+`. `Nat.add` matches on its left argument, so the
# regrouping the append-length step needs is not definitional for a variable on
# the left.
def Policy.add_assoc(a: Nat, -b: Nat, -c: Nat) -> {a + (b + c) == (a + b) + c : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_assoc(p, b, c) : {1n + (p + (b + c)) == 1n + _ : Nat}
      {==}

# The length of an append. This is the lemma the prelude does not have, and it
# is an induction on the list because `append` matches on its first argument.
# `ys` is `+` because the step uses it in the goal and passes it to the
# recursive call.
def Policy.len_append(+xs: List<&2, Nat>, +ys: List<&2, Nat>)
    -> {P.len(P.append(xs, ys)) == P.len(xs) + P.len(ys) : Nat}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, P.len(P.append(t, ys)), P.len(t) + P.len(ys),
                 Policy.len_append(t, ys)) : {1n + _ == (1n + P.len(t)) + P.len(ys) : Nat}
      %Equal.sym(Nat, 1n + (P.len(t) + P.len(ys)), (1n + P.len(t)) + P.len(ys),
                 Policy.add_assoc(1n, P.len(t), P.len(ys))) : {_ == (1n + P.len(t)) + P.len(ys) : Nat}
      {==}

# The repetition law. The induction is on `n`, and the list is carried
# unchanged, so the hypothesis lands exactly where the step needs it -- the work
# is in the append-length lemma the step calls, not in generalizing this.
def Policy.nappend_len(+xs: List<&2, Nat>, n: Nat)
    -> {P.len(S.nappend(xs, n)) == n * P.len(xs) : Nat}:
  match n:
    case 0n:
      {==}
    case 1n++p:
      %Equal.sym(Nat, P.len(P.append(xs, S.nappend(xs, p))),
                 P.len(xs) + P.len(S.nappend(xs, p)),
                 Policy.len_append(xs, S.nappend(xs, p)))
          : {_ == (1n + p) * P.len(xs) : Nat}
      %Equal.sym(Nat, P.len(S.nappend(xs, p)), p * P.len(xs),
                 Policy.nappend_len(xs, p)) : {P.len(xs) + _ == (1n + p) * P.len(xs) : Nat}
      {==}

def L.nappend_zero(xs):
  {==}

def L.nappend_succ(xs, p):
  {==}

def L.nappend_len(xs, n):
  %Policy.nappend_len(xs, n) : {P.len(S.nappend(xs, n)) == _ : Nat}
  {==}
