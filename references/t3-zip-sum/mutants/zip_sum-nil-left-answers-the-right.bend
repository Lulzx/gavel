import Base

# The outer empty case answers the second list instead of the empty one.
#
# This file is for `zip_sum_nil_left(ys)`, which is `zip_sum(Nil{}, ys) ==
# Nil{}` and which no other mutant in the corpus fails. The comment above that
# law already gives the reason it is cheap to state -- `zip_sum` steps on its
# first list, so with `Nil{}` there the first branch is taken no matter what the
# second list is -- and the mirror of that is why it is easy to leave untested:
# the match that answers it has already stopped, and every rule in
# `tools/mutate.py` rewrites a step.
#
# `zip_sum(Nil{}, ys)` now returns `ys`, so the law is false for every non-empty
# `ys`. It reaches further than that one law, and the reach is worth recording
# rather than trimming: `zip_sum_len`'s own base case is `len(zip_sum(Nil{}, ys))
# == min(len(Nil{}), len(ys))`, which the reference closes by this same
# unfolding, so it goes with it. `zip_sum_nil_right` survives, because the inner
# match on `ys` is where that law is answered and this body does not touch it.
# Bare, with no proof: tier 2.
def zip_sum(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      ys
    case h1 <> t1:
      match ys:
        case Nil{}:
          Nil{}
        case h2 <> t2:
          (h1 + h2) <> zip_sum(t1, t2)
