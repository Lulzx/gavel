import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: merging with an empty left list is the right list. Both sides compute, so
# this one is definitional, and it is the weak half: it fixes what `merge`
# answers when there is nothing on the left to compare against.
law merge_nil_l:
  for ys: List<&2, Nat>
  {S.merge(Nil{}, ys) == ys : List<&2, Nat>}

# LAW: merging with an empty right list is the left list. The left list is a
# variable, so the match in `merge` is stuck and this one is an induction rather
# than an unfolding -- which is what makes it worth stating: a body that read
# only one of its arguments satisfies `merge_nil_l` and leaves the two sides
# here unconvertible.
law merge_nil_r:
  for +xs: List<&2, Nat>
  {S.merge(xs, Nil{}) == xs : List<&2, Nat>}

# LAW: when the decision says the left head is not the greater one, the left head
# goes first. Together with the law below it this pins what `k` *means*: a
# `merge_go` branch whose two heads have nothing left to be compared against owes
# its answer to the comparison alone, and these two say which answer each value
# of the comparison calls for. A body that gave the same pair on both branches,
# or gave the pair the wrong way round, keeps every length and satisfies all
# three laws above, and leaves this one unconvertible.
law merge_go_true:
  for a: Nat
  for b: Nat
  {S.merge_go(Nil{}, a, Nil{}, b, True{}) == a <> b <> Nil{} : List<&2, Nat>}

# LAW: when the decision says the left head is the greater one, the right head
# goes first. The pair is the same two heads in the other order, so together with
# `merge_go_true` this fixes the answer to the comparison completely.
law merge_go_false:
  for a: Nat
  for b: Nat
  {S.merge_go(Nil{}, a, Nil{}, b, False{}) == b <> a <> Nil{} : List<&2, Nat>}

# LAW: `merge` keeps every element of both lists, so its result has as many
# elements as the two of them together. This is the work, and it is the law that
# says the head is chosen by the comparison rather than by which list it came
# from: a body that kept the two heads and dropped the tails -- `hx <> hy`,
# say -- satisfies all the pins above and leaves the two sides here
# unconvertible.
law merge_len:
  for +xs: List<&2, Nat>
  for +ys: List<&2, Nat>
  {P.len(S.merge(xs, ys)) == P.len(xs) + P.len(ys) : Nat}

# LAW: the step, with the comparison as a premise instead of as a scrutinee.
#
# The two decision pins above are stated at `merge_go(Nil{}, a, Nil{}, b, k)`
# and so constrain exactly one of `merge_go`'s eight leaves. Every other branch
# is reached through the recursion, and `merge_len` cannot see order, so a body
# that swaps the order anywhere else in `merge_go` escaped all five original
# laws. **Measured 2026-09-19, before this law existed:** the body in
# `mutants/merge_go-swap-args-27.bend` -- the `(cons, cons, True)` branch
# recurring with `P.le(hy, hx2)` -- read **tier 4, complete, reward 1.000
# against the reference proof**. So did a non-recursive reorder of the
# `(Nil, cons, True)` leaf, `hx <> hy2 <> hy <> ty2`, with the reference proof
# untouched.
#
# This law states the step as an equation rather than transcribing a branch:
# under the premise the list with the smaller head is advanced and the other
# keeps its head. Its `False{}` mirror below carries the other value of the
# comparison, and the tails are arbitrary in both, so the pair reaches every
# branch `merge` can produce.
#
# The premise has to be *spent*, not merely assumed: `k` is `merge_go`'s last
# parameter and the match under it cannot fire while the goal still shows a
# stuck `P.le(hx, hy)`. The proof rewrites the decision argument with
# `Equal.cong`, whose motive is `k => S.merge_go(tx, hx, ty, hy, k)`, and only
# then does the branch compute.
law merge_le_head:
  for hx: Nat
  for +tx: List<&2, Nat>
  for hy: Nat
  for +ty: List<&2, Nat>
  for e: {P.le(hx, hy) == True{} : Bool}
  {S.merge(hx <> tx, hy <> ty) == hx <> S.merge(tx, hy <> ty) : List<&2, Nat>}

# LAW: the mirror of the step at the other value of the comparison. The `False{}`
# branches of `merge_go` are the ones the `True{}` premise above never reaches,
# and among them the `(cons, Nil, False)` leaf -- `hy <> hx <> hx2 <> tx2` -- is
# the one an order-only-wrong body can most easily miss, so it needs a premise of
# its own rather than a mirror by symmetry.
law merge_gt_head:
  for hx: Nat
  for +tx: List<&2, Nat>
  for hy: Nat
  for +ty: List<&2, Nat>
  for e: {P.le(hx, hy) == False{} : Bool}
  {S.merge(hx <> tx, hy <> ty) == hy <> S.merge(hx <> tx, ty) : List<&2, Nat>}
