import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the length of a filter is not a bound, it is an exact count -- the
# elements `filter(xs, n)` keeps are precisely the elements of `xs` that are at
# most `n`, and `P.below_count` counts those. Both sides depend on the
# argument, so no argument-ignoring body satisfies it: a `filter` that returned
# `xs` gives `S.len(xs) == P.below_count(xs, n)`, and a `filter` that returned
# `Nil{}` gives `0n == P.below_count(xs, n)`. `{==}` proves neither, because
# `P.below_count` is stuck on a variable list. This is the law that needs the
# inductive step.
law filter_len:
  for xs: List<Nat>
  for n: Nat
  {S.len(S.filter(xs, n)) == P.below_count(xs, n) : Nat}

# LAW: with the threshold equal to the head, the head is kept. The exact count
# above does not say this on its own -- a filter that returned a wrong list of
# the right length would satisfy it -- so this pins the cons case's answer
# rather than only its length. It cannot be proved by `{==}`: `P.le(h, h)` is
# stuck on a variable.
law filter_keep:
  for h: Nat
  for t: List<Nat>
  {S.filter(h <> t, h) == h <> S.filter(t, h) : List<Nat>}

# LAW: when the head is above the threshold the head is dropped. `filter_keep`
# alone is not enough: the projection `filter(xs, n) = xs` satisfies it with
# `{==}`, since it maps `h <> t` to itself on both sides. Putting the dropped
# case on the left is what rules that out. The threshold is a parameter rather
# than `1n + h` so that the hypothesis is available to the policy as a binder
# rather than as a fact it would have to derive first.
law filter_drop:
  for h: Nat
  for y: Nat
  for t: List<Nat>
  for e: {P.le(y, h) == False{} : Bool}
  {S.filter(y <> t, h) == S.filter(t, h) : List<Nat>}
