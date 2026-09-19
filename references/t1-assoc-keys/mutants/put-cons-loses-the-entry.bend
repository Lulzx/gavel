import Base
import ./prelude.bend as P

# `assoc_put` returns its list, so a put adds nothing.
#
# This file exists for `put_cons`, which no other mutant in the corpus fails.
# It is not an empty case: `put_cons`'s left-hand side is `assoc_put(kvs, k, v)`
# with three variables, so it is the *step* law whose step is a constructor the
# function never looks at -- the generated rule that rewrites recursion
# arguments has nothing to rewrite in a body that is one constructor
# application. `keys_put` catches it too, which is why this mutant is not the
# only one the corpus gains here.
#
# Measured 2026-09-19 against this task's law set: tier 3,
# failing `keys_put`, `put_cons`.
def assoc_put(kvs: List<&2, P.Entry>, k: Nat, v: Nat) -> List<&2, P.Entry>:
  kvs

def keys(kvs: List<&2, P.Entry>) -> List<&2, Nat>:
  match kvs:
    case Nil{}:
      Nil{}
    case P.Mk{hk, hv} <> t:
      hk <> keys(t)
