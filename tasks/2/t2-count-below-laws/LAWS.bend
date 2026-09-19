import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: nothing is at most `x` in an empty list. Both sides compute, so this one
# is definitional, and it is a pin: the two cons laws below name a cons cell and
# never reach the empty case.
law count_below_nil:
  for x: Nat
  {S.count_below(x, Nil{}) == 0n : Nat}

# LAW: a head at most `x` is counted, and the rest of the count is the tail's.
# The premise is the predicate's own answer and it is what makes the law say
# anything: with `h` and `x` variables `P.le(h, x)` is stuck, so neither side
# reduces without it. This is one of the two laws that fix `count_below`.
law count_below_keep:
  for +h: Nat
  for +t: List<&2, Nat>
  for +x: Nat
  for e: {P.le(h, x) == True{} : Bool}
  {S.count_below(x, h <> t) == 1n + S.count_below(x, t) : Nat}

# LAW: a head above `x` is not counted. The other answer of the comparison, and
# without it a body that counted every element would keep `count_below_keep`.
law count_below_drop:
  for +h: Nat
  for +t: List<&2, Nat>
  for +x: Nat
  for e: {P.le(h, x) == False{} : Bool}
  {S.count_below(x, h <> t) == S.count_below(x, t) : Nat}

# LAW: every element is on one side of `x` or the other, and none is counted
# twice, so the two counts add up to the length of the list. This is the work
# and the whole of what pins `count_above`: the three laws above fix
# `count_below` completely, and this one then fixes `count_above` to be however
# many elements are left, on every input at once. Neither side reduces on a
# variable list -- both calls are stuck -- so the induction is the proof, and a
# body that counted the above-elements as all of them, or as none, or that
# dropped the head's contribution on exactly one of the two branches, leaves the
# two sides here unconvertible.
law count_below_split:
  for xs: List<&2, Nat>
  for +x: Nat
  {S.count_below(x, xs) + S.count_above(x, xs) == P.len(xs) : Nat}
