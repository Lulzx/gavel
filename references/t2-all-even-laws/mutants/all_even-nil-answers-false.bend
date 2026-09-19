import Base
import ./prelude.bend as P

# The empty case answers `False{}`.
#
# `all_even_nil()` is `all_even(Nil{}) == True{}`, and it is the one law in this
# set no other mutant fails. Every generated rule in `tools/mutate.py` rewrites
# the *step* -- the head's test, the recursion's argument, the connective -- and
# the empty case is an answer rather than a step, so the corpus had nine bodies
# that all left the only law about `Nil{}` alone.
#
# A body that makes it false is what shows the law is load-bearing rather than
# definitional noise: `all_even` of nothing is the base of every induction in
# this set, and the reference's `True{}` is the fact the other five laws are
# pinned against. Bare, with no proof: tier 2.
#
# Measured 2026-09-19 against the law set: **tier 2**, `all_even_nil` and
# `all_even_snoc` unproven. The set is two laws, not five -- `Policy.and_true`
# and `Policy.and_assoc` are proof helpers and not laws -- so failing both is
# zero proven, which is tier 2 and not tier 3. `all_even_nil` is the base case
# `all_even_snoc`'s induction stands on, which is why one wrong answer takes the
# pair down. Bare, with no proof, it is tier 2 as well: that is the property V2
# requires, and the reason this file is evidence about a law rather than about a
# coverage error.
def all_even(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      Bool.and(P.is_even_b(h), all_even(t))
