import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: nothing below zero. Both sides compute, so this one is definitional, and
# it is a pin: it fixes the answer on the empty input, which no other law here
# reaches -- every other law about `count_up` is stated at `1n + k`.
law count_up_zero:
  {S.count_up(0n) == Nil{} : List<&2, Nat>}

# LAW: the step. One more element is the count below it with that element
# appended at the end. Both sides compute, so this is definitional as well, and
# it is what says the answer *grows at the back*: a body that put `k` on the
# front instead -- which is `count_down`'s step, not this one -- has the right
# length and the wrong order, and `count_up_rev_count_down` below is the only
# other law that can see the difference.
law count_up_succ:
  for +k: Nat
  {S.count_up(1n + k) == P.snoc(S.count_up(k), k) : List<&2, Nat>}

# LAW: nothing below zero, counting down. Definitional, and the pin on
# `count_down`'s empty case.
law count_down_zero:
  {S.count_down(0n) == Nil{} : List<&2, Nat>}

# LAW: the step. One more element is that element on the front of the count
# below it. Definitional, and it is the half of the pair that says the answer
# *grows at the front*, which is what `count_up_rev_count_down` needs to line up
# against `rev`'s own step.
law count_down_succ:
  for +k: Nat
  {S.count_down(1n + k) == k <> S.count_down(k) : List<&2, Nat>}

# LAW: the two functions are reverses of each other. This is the work, and the
# reason they are one task: neither side computes on a variable `n`, and the
# step needs a fact the prelude does not have -- that `rev` of a `snoc` is the
# element on the front of the `rev` -- which is an induction of its own. It is
# the law that pins the order of both answers at once, so a body that counted up
# where it should count down agrees with both step laws above and fails here.
law count_up_rev_count_down:
  for +n: Nat
  {P.rev(S.count_up(n)) == S.count_down(n) : List<&2, Nat>}

# LAW: how many elements counting up produces. Not definitional: with `n` a
# variable the two sides do not compute, and the step needs a fact about `len`
# of a `snoc`. It pins the count, which the reverse law pins only indirectly --
# two bodies that agreed on the order could still disagree on how many elements
# they produce, and this law is what separates them.
law len_count_up:
  for +n: Nat
  {P.len(S.count_up(n)) == n : Nat}

# LAW: how many elements counting down produces. The same count from the other
# end; `count_down` is stuck on a variable `n` too, so this is an induction.
law len_count_down:
  for +n: Nat
  {P.len(S.count_down(n)) == n : Nat}
