import Base
import ./prelude.bend as P
import ./solution.bend as S

# The laws of `is_suffix`. They are stated in terms of the prelude's `is_nil`,
# `eq_list` and `append`, all of which match on their first argument, so a goal
# about any of them at a variable list is stuck -- each law below is a fact
# about `is_suffix` and not a restatement of its body. A binder is `+` where
# the law itself reads the list twice.

# The empty list is a suffix of every list.
law is_suffix_nil: for ys: List<&2, Nat> {S.is_suffix(Nil{}, ys) == True{} : Bool}

# No list that starts with a cons cell is a suffix of the empty list. This pins
# the case the recursion does not have: `is_suffix` walks `ys`, so `ys == Nil{}`
# is a stopped match, and only this law constrains what it answers there.
law is_suffix_nil_right: for h: Nat for t: List<&2, Nat> {S.is_suffix(h <> t, Nil{}) == False{} : Bool}

# The unfolding of `is_suffix` on a cons cell. It pins the decision to split
# `xs` off the front of `k <> u` and to try the tail otherwise, and it is what
# makes the two disjuncts of the body observable to the other laws.
law is_suffix_cons: for +xs: List<&2, Nat> for k: Nat for +u: List<&2, Nat>
                  {S.is_suffix(xs, k <> u) == Bool.or(P.eq_list(xs, k <> u), S.is_suffix(xs, u)) : Bool}

# Every list is a suffix of itself.
law is_suffix_self: for +xs: List<&2, Nat> {S.is_suffix(xs, xs) == True{} : Bool}

# `xs` is a suffix of anything with `xs` stuck on the end. Together with
# `is_suffix_self` this is what the body's two decisions have to add up to: a
# candidate list is accepted exactly when the walk down `ys` reaches it.
law is_suffix_append: for +xs: List<&2, Nat> for ys: List<&2, Nat>
                    {S.is_suffix(xs, P.append(ys, xs)) == True{} : Bool}
