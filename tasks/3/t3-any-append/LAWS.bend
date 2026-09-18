import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the empty list has nothing to find. Both sides compute, so this one is
# definitional, and it is the weak half: a body that answered `True{}`
# everywhere would satisfy nothing else here, but a body that answered `False{}`
# everywhere satisfies this one and is ruled out by the law below.
law any_nil:
  {S.any(Nil{}) == False{} : Bool}

# LAW: one step of the search. Both sides compute, so this is definitional too,
# and it is the law that says the answer folds the head in: a body that ignored
# the head and searched only the tail -- or that answered its first element --
# agrees with no law here, because the head is a *variable* of type `Bool` and
# both its values have to come out right.
law any_cons:
  for h: Bool
  for t: List<&2, Bool>
  {S.any(h <> t) == Bool.or(h, S.any(t)) : Bool}

# LAW: searching two lists in turn is searching each and taking either answer.
# This is the work, and it needs an induction on the list: the step unfolds the
# left-hand side into a search of the tail and applies the hypothesis there,
# which leaves `Bool.or` associated the other way round. `or` is not associative
# because it is a definition, so the step is closed by a helper.
law any_append:
  for +xs: List<&2, Bool>
  for +ys: List<&2, Bool>
  {S.any(P.append(xs, ys)) == Bool.or(S.any(xs), S.any(ys)) : Bool}
