import Base

# The empty list answers the count it was asked about instead of `0n`.
#
# `at_nil(n)` is `at(Nil{}, n) == 0n`, and the comment above the reference's
# `Nil{}` arm already says why the law is there: the match on the list answers
# `0n` *without looking at the count*, so every `n` gives the same answer. No
# generated rule reaches it, because `tools/mutate.py` rewrites steps and this
# is an answer -- and the fourteen bodies in this corpus all leave the count
# matched on and the list stepped.
#
# The law is not vacuous: the body above makes it false for every `n` above
# zero, and it type-checks, so the failure is about what the law says rather
# than about coverage. Bare, with no proof: tier 2.
#
# Measured 2026-09-19 against the three-law set: tier 3, with `at_nil` the one
# law left unproven -- `at_succ` and `at_len_append` never ask `at` about the
# empty list, so this body leaves them proven. Bare, with no proof: tier 2.
def at(xs: List<Nat>, n: Nat) -> Nat:
  match xs:
    case Nil{}:
      n
    case h <> t:
      match n:
        case 0n:
          h
        case 1n+k:
          at(t, k)
