import Base

# The inner empty case answers the first list instead of the empty one.
#
# This file is for `zip_sum_nil_right(xs)`, which is `zip_sum(xs, Nil{}) ==
# Nil{}` and which no other mutant in the corpus fails. The other fourteen
# bodies rewrite the cons arm -- the sum, the recursion, the whole answer -- and
# the two nil cases are answers reached by a match that has already stopped, so
# nothing generated lands on them. Two of those files even say so in their own
# headers, that "both nil laws hold definitionally", which is a true statement
# about those bodies and the reason the law was carrying no evidence at all.
#
# The law is not vacuous and this file is the demonstration: `zip_sum(xs, Nil)`
# now returns the first list whole, so it is false for every non-empty `xs`.
# `zip_sum_nil_left` is untouched -- the outer empty case still answers `Nil{}`
# -- and that separation is the point, since it makes this file evidence about
# one law rather than about both. Bare, with no proof: tier 2.
#
# Measured 2026-09-19 against the five-law set: tier 3, two laws unproven --
# `zip_sum_nil_right`, which this file is for, and `zip_sum_len`, whose base
# case stands on the same inner match.
def zip_sum(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h1 <> t1:
      match ys:
        case Nil{}:
          h1 <> t1
        case h2 <> t2:
          (h1 + h2) <> zip_sum(t1, t2)
