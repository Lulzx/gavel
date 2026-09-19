import Base
import ./prelude.bend as P
import ./solution.bend as S

# The laws are stated over `List<&2, Nat>`: the step of `rev_len` needs the
# destructured tail live twice, which is only expressible when the list is of a
# kind a `+` binder is allowed on. Naming the prelude's `len` as `S.len` is not
# an option -- the solution module re-exports nothing -- so anything that is not
# the function the policy writes is `P.`.

# LAW: reversing a list does not change its length. The identity body
# (`rev(xs) = xs`) satisfies this one by itself, since both sides are then
# `len(xs)`, so what it adds is the length side of the function the other two
# laws pin: with `rev_rev` it forces the answer to be a rearrangement of the
# argument rather than a list of the right size. The constant body `Nil{}` fails
# it here: the left-hand side computes to `0n` and the right-hand side is
# `P.len(xs)`, which is stuck on a variable.
law rev_len:
  for +xs: List<&2, Nat>
  {P.len(S.rev(xs)) == P.len(xs) : Nat}

# LAW: reversal turns an append around and reverses the pieces. This is the law
# that rules the argument-ignoring bodies out. The identity body gives
# `P.append(xs, ys) == P.append(ys, xs)`, which is stuck on two variables, so
# `{==}` proves neither; a body that keeps only the head and drops the tail
# differs from `P.append(S.rev(ys), S.rev(xs))` as well. The constant body
# `Nil{}` does satisfy this one -- `P.append` on two `Nil{}`s is `Nil{}` on both
# sides -- which is exactly why `rev_len` is not optional.
law rev_append:
  for +xs: List<&2, Nat>
  for +ys: List<&2, Nat>
  {S.rev(P.append(xs, ys)) == P.append(S.rev(ys), S.rev(xs)) : List<&2, Nat>}

# LAW: reversing twice is the identity. `rev_append` allows a body that reverses
# the list and then pads it, or that reverses once and puts the answers back in
# the wrong order on the way out; this law is the one that says the answer is
# the argument rather than only a rearrangement of it. It is satisfied by the
# identity body, so it pins nothing on its own, and it is not implied by the
# other two: none of the three is optional.
law rev_rev:
  for +xs: List<&2, Nat>
  {S.rev(S.rev(xs)) == xs : List<&2, Nat>}

# LAW: a one-element list reverses to itself. The three laws above pin the
# *order* of the answer and its length and nothing else. `rev_append` says `rev`
# turns an append around and `rev_rev` says it is its own inverse, so `rev` is
# an anti-automorphism of `append` that squares to the identity -- and on the
# free monoid that determines it only up to a fixed involution of the elements:
# "reverse, and map every element by the same involution" satisfies all three.
# A one-element list has nowhere for a permutation to act, so this is the law
# that observes what happens to the element itself, which the other three
# cannot see.
law rev_singleton:
  for x: Nat
  {S.rev(x <> Nil{}) == x <> Nil{} : List<&2, Nat>}
