import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: there is nothing to count on the empty list. Both sides compute, so this
# one is definitional, and it is the pin on the empty case: `count_if_cons`
# names a record in front of a list, so on its own it says nothing about the
# list that has no records in it, and `0n` is the only answer the laws below can
# start from.
law count_if_nil:
  {S.count_if(Nil{}) == 0n : Nat}

# LAW: the step, and the law that says what each record contributes. Both sides
# compute, so this is definitional: a record's contribution is `P.same` of its
# two halves, and then the tail is counted. It is the law that pins that both
# halves are read -- a body that counted every record, or that tested one half
# against itself, leaves the two sides unconvertible for a variable record -- and
# it is the only law that says where in the sum the contribution lands.
law count_if_cons:
  for a: Nat
  for b: Nat
  for t: List<&2, P.Pair>
  {S.count_if(P.MkPair{a, b} <> t) == P.same(a, b) + S.count_if(t) : Nat}

# LAW: appending one record on the right adds that record's contribution and
# changes nothing else. `P.append` matches on its first argument, so with a
# variable list the goal does not reduce on its own: this one is inductive, and
# it is the law that pins the count over a list the recursion reaches one record
# at a time: a body that counted the first record twice, or that dropped the
# last one, satisfies the step law and fails here.
law count_if_snoc:
  for ps: List<&2, P.Pair>
  for a: Nat
  for b: Nat
  {S.count_if(P.append(ps, P.MkPair{a, b} <> Nil{})) == S.count_if(ps) + P.same(a, b) : Nat}
