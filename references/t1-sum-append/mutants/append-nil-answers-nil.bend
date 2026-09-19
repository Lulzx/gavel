import Base

# The empty left argument answers `Nil{}` instead of the second argument.
#
# `append_nil_left(ys)` is `append(Nil{}, ys) == ys`, and it is the one law in
# this set that no other mutant in the corpus fails: `append`'s base case is
# the only place the law's own subject can be got wrong, and every generated
# rule in `tools/mutate.py` rewrites a step, a count or a recursion argument
# rather than an answer that carries no computation at all.
#
# The law is not vacuous and this file is the demonstration: the reference
# unfolds `append(Nil{}, ys)` to `ys`, so the body above makes it false for
# every `ys`. `append_cons` is about the cons arm and is untouched. Bare, with
# no proof: tier 2.
#
# Measured 2026-09-19 against the four-law set: tier 3, two laws unproven --
# `append_nil_left`, which this file is for, and `sum_append`, whose own base
# case is `sum(append(Nil{}, ys)) == sum(Nil{}) + sum(ys)` and which the
# reference proof closes by that same unfolding.
def sum(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      h + sum(t)

def append(xs: List<Nat>, ys: List<Nat>) -> List<Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      h <> append(t, ys)
