import Base
import ./prelude.bend as P

# The empty case answers `False{}`.
#
# `all_one_nil()` is `all_one(Nil{}) == True{}`, and no other mutant in this
# corpus fails it: the generated rules rewrite the step -- the head's test, the
# recursion's argument, the connective -- and the empty case is an answer rather
# than a step. The law was therefore carrying no evidence at all, which is
# invisible to V2, whose only questions are whether the corpus is non-empty,
# whether some mutant type-checks, and whether any escapes.
#
# `all_one` of nothing is the base of this set's inductions, so a body that
# makes it false is a body the other four laws cannot rule out on their own.
# Bare, with no proof: tier 2.
#
# Measured 2026-09-19 against the law set: **tier 2**, `all_one_nil` and
# `all_one_snoc` unproven. The set is two laws, not five -- `Policy.and_true`
# and `Policy.and_assoc` are proof helpers and not laws -- so failing both is
# zero proven, which is tier 2 and not tier 3. `all_one_nil` is the base case
# `all_one_snoc`'s induction stands on, which is why one wrong answer takes the
# pair down. Bare, with no proof, it is tier 2 as well.
def all_one(xs: List<Nat>) -> Bool:
  match xs:
    case Nil{}:
      False{}
    case h <> t:
      Bool.and(P.is_one_b(h), all_one(t))
