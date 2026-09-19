import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `append` matches on its first argument, so its right identity and its
# associativity are not definitional: the base case below needs the first, and
# the step case needs the second. Both are proved here as lemmas of their own,
# under the reserved Policy.* namespace.
def Policy.append_nil(xs: List<&2, Nat>) -> {P.append(xs, Nil{}) == xs : List<&2, Nat>}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Policy.append_nil(t) : {h <> P.append(t, Nil{}) == h <> _ : List<&2, Nat>}
      {==}

# `ys` and `zs` are erased: they appear in the statement, never in the
# computation, so calling this lemma does not consume them and the step case
# below keeps each of the caller's variables to a single live use.
def Policy.append_assoc(xs: List<&2, Nat>, -ys: List<&2, Nat>, -zs: List<&2, Nat>) -> {P.append(xs, P.append(ys, zs)) == P.append(P.append(xs, ys), zs) : List<&2, Nat>}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Policy.append_assoc(t, ys, zs) : {h <> P.append(t, P.append(ys, zs)) == h <> _ : List<&2, Nat>}
      {==}

# The base anchor. `concat(Nil{})` unfolds to `Nil{}`: the fold has nothing to
# put in front of the empty list, so the two sides are the same term.
def L.concat_nil():
  {==}

# The base case unfolds to `append(ys, Nil{}) == ys`, which is the identity
# lemma; the step case leaves `a` outside both sides and reassociates.
def L.concat_append(xss, ys):
  match xss:
    case Nil{}:
      %Policy.append_nil(ys) : {P.append(ys, Nil{}) == _ : List<&2, Nat>}
      {==}
    case a <> rest:
      # Fold the tail first: the hypothesis has `concat(append_ll(rest, ys))` on
      # the left, which is where the goal has it too, so it is flipped. What is
      # left is `a` in front of both sides.
      %Equal.sym(List<&2, Nat>, S.concat(P.append_ll(rest, ys)), P.append(S.concat(rest), ys), L.concat_append(rest, ys)) : {P.append(a, _) == P.append(P.append(a, S.concat(rest)), ys) : List<&2, Nat>}
      # Then reassociate so that `a` is the outer `append` on both sides.
      %Policy.append_assoc(a, S.concat(rest), ys) : {P.append(a, P.append(S.concat(rest), ys)) == _ : List<&2, Nat>}
      {==}
