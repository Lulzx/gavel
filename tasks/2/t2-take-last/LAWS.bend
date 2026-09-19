import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: a list with no elements has no last elements, so the answer is `Nil{}`
# whatever `k` is. Both sides compute, so this is definitional, and it is an
# absolute anchor: the right-hand side calls no target. It is also the only law
# here that reaches `Nil{}` through `take_last` itself, so a body that answered
# anything else there -- or that was built as `c + ref(xs, k)` with a constant
# that cancels out of every law about a longer list -- is caught here.
law take_last_nil:
  for k: Nat
  {S.take_last(Nil{}, k) == Nil{} : List<&2, Nat>}

# LAW: the opening step. A list that is longer than `k` cannot keep its head, so
# the head is dropped and the same `k` is asked of the tail; a list that is no
# longer than `k` is already the answer. Both sides compute, so this is
# definitional, and it pins *which* way the comparison runs: a body that asked
# whether `k` is at most the length -- and so dropped the tail rather than the
# head -- is separated here, as is a body that stepped the count down instead of
# the list. The whole pair is handed to `P.keep_if` because a `match` cannot
# scrutinise the call that takes the length.
law take_last_step:
  for h: Nat
  for t: List<&2, Nat>
  for k: Nat
  {S.take_last(h <> t, k) == P.keep_if(P.le(P.len(h <> t), k), h <> t, S.take_last(t, k)) : List<&2, Nat>}

# LAW: one element has at least one element to take, so the last `k` of it are
# the element itself -- for every `k` from `1n` up, and this is the whole of what
# "fewer than `k` elements" means at its boundary. It is a case split and not a
# computation: `P.le(0n, k)` is stuck at a variable `k`, so the fact that a
# one-element list is short enough has to be shown by stepping the count, which
# is what `Policy.le_zero_left` does in the proof. A body that treated only `0n`
# as short enough, and so truncated a singleton for `k = 1n`, is separated only
# here -- every law above reads a list with `0n` or at least two elements.
law take_last_single:
  for x: Nat
  for k: Nat
  {S.take_last(x <> Nil{}, 1n + k) == x <> Nil{} : List<&2, Nat>}

# LAW: taking the last `0n` elements of a list takes nothing, however long the
# list is. This is the induction: `take_last` on a variable list is stuck, and
# what closes the step is that the length of a cons against `0n` answers on the
# spot -- the head is dropped and the hypothesis answers for the tail. It is what
# separates a body that stopped one element too early, or that read `0n` as "all
# of them", from the one here; every other law about a non-empty list takes a
# positive count.
law take_last_zero:
  for xs: List<&2, Nat>
  {S.take_last(xs, 0n) == Nil{} : List<&2, Nat>}

# LAW: a list that is already no longer than `k` is its own last `k` elements --
# the general statement of the case where the walk stops at once, over every list
# and every count, rather than the two closed lengths below. The premise is about
# the prelude's `len` and `le` on the input, not about anything `take_last`
# returns, so a body cannot make it vacuous by answering differently: what it says
# is that the body must hand back the *list it was given*, and a body that
# answered `Nil{}` or a prefix there is caught. The proof is a case split, since
# the premise carries the comparison the step is decided by.
law take_last_long:
  for xs: List<&2, Nat>
  for k: Nat
  for e: {P.le(P.len(xs), k) == True{} : Bool}
  {S.take_last(xs, k) == xs : List<&2, Nat>}

# LAW: one closed list, read end to end. The last two of `[1n, 2n, 3n]` are
# `[2n, 3n]`, so this says *which* end the count is taken from: a body that kept
# the first two, or that answered a window that is neither end, satisfies every
# law above -- the step law only orders the recursion -- and is separated here.
law take_last_three:
  {S.take_last(1n <> (2n <> (3n <> Nil{})), 2n) == 2n <> (3n <> Nil{}) : List<&2, Nat>}

# LAW: a count past the end of the list is not an error and not a truncation of
# the answer: `[1n, 2n]` is its own last five elements. The general case is the
# law above, and this one is closed, so it pins the same thing at a length no
# law's recursion reaches -- a body that stopped at the end of the count, or that
# answered `Nil{}` when the count ran out first, is separated here.
law take_last_all:
  {S.take_last(1n <> (2n <> Nil{}), 5n) == 1n <> (2n <> Nil{}) : List<&2, Nat>}
