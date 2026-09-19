import Base
import ./prelude.bend as P
import ./solution.bend as S

# The answer is a `List<&2, List<&2, Nat>>` -- a list of windows, each window a
# list of numbers -- and every law that states an equality of windows spells
# that type out. Two binders are declared `+`: `windows_succ` and
# `windows_go_step` name the window length and the input twice each, once to
# say what is taken and once to say where the recursion continues, and a binder
# that is live twice is not Lone.

# LAW: there are no windows of length zero. The left-hand side is a stopped
# match with a literal scrutinee -- the reference matches on the length, and
# `0n` is that match's empty case -- so this is definitional, and it fixes an
# answer rather than a step: a body that emitted an empty window there, or that
# counted `0n` as one window, satisfies `windows_succ` at every other length.
law windows_zero:
  for xs: List<&2, Nat>
  {S.windows(0n, xs) == Nil{} : List<&2, List<&2, Nat>>}

# LAW: the step of the task's own function, written out. Both sides compute --
# the left by unfolding `windows`, the right by the loop it hands the work to --
# so this is definitional, and it is what says the two functions you write have
# to agree: `windows` at a positive length is the loop started at the pointer
# `lookahead` computes, which is the input as seen from the last window. A body
# that ignored the length, or that started the loop at the wrong place, does not
# have these two sides equal.
law windows_succ:
  for +k: Nat
  for +xs: List<&2, Nat>
  {S.windows(1n + k, xs) == S.windows_go(P.lookahead(xs, 1n + k), 1n + k, xs) : List<&2, List<&2, Nat>>}

# LAW: an empty input has no windows, whatever the length. This is the law that
# is not definitional: with the length a variable, the pointer `lookahead`
# computes is a stopped match, so neither side reduces, and the two sides are
# only equal because the input ran out -- which is what the induction on the
# length, one case per constructor, has to show. It is also the law that stops
# a body answering something -- anything -- for a non-empty input, since that
# body's answer would have to be `Nil{}` here too.
law windows_nil:
  for k: Nat
  {S.windows(k, Nil{}) == Nil{} : List<&2, List<&2, Nat>>}

# LAW: the loop stops when the pointer runs out. The left-hand side is a
# stopped match with a constructor scrutinee, so this is definitional: it fixes
# the answer the loop gives when there is no window left to emit, and a body
# that emitted one more window at the end -- the window that is one element
# short -- would satisfy `windows_go_step` at every other pointer.
law windows_go_nil:
  for k: Nat
  for xs: List<&2, Nat>
  {S.windows_go(Nil{}, k, xs) == Nil{} : List<&2, List<&2, Nat>>}

# LAW: the step of the loop. One window of length `k` comes off the front of the
# input, and the loop continues one element along the input and one window along
# the pointer. Both sides compute, so this is definitional, and it is the law
# that fixes *which* window is emitted: a body that took `k` elements from
# anywhere else, or that advanced one side and not the other, leaves the two
# sides unconvertible. It is also the law that says the two `+` binders are the
# same one: the `k` used to take the window and the `k` the loop continues with
# are the same number.
law windows_go_step:
  for h: Nat
  for t: List<&2, Nat>
  for +k: Nat
  for +xs: List<&2, Nat>
  {S.windows_go(h <> t, k, xs) == P.take(xs, k) <> S.windows_go(t, k, P.tail(xs)) : List<&2, List<&2, Nat>>}
