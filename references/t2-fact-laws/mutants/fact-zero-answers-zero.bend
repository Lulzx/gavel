import Base

# `fact(0n)` answers `0n` instead of `1n`; everything else is the reference.
#
# Hand-written because the generator cannot produce it: every mutation it
# applies to the base case also moves `fact_succ`, and this body leaves
# `fact_succ` true. At `n = 0` the law reads `fact(1n) == Nat.mul(1n, fact(0n))`,
# and this body answers `Nat.mul(1n, 0n)` on the left and `Nat.mul(1n, 0n)` on
# the right, so the two sides still agree. `facts` is the reference, so
# `facts_nil`, `facts_cons` and `facts_len` are untouched -- `facts(Nil{})` is
# still `Nil{}` because `facts` maps over the empty list without calling `fact`.
#
# So this body fails exactly one law, `fact_zero`, which is the whole point: it
# is the mutant that makes `fact_zero` a law something can violate alone. With
# it in the corpus no law in this set has a zero-kill count.
def fact(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n++p:
      Nat.mul(1n+p, fact(p))

def facts(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case +h <> +t:
      fact(h) <> facts(t)
