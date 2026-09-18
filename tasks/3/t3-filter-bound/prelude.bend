import Base

# Immutable, and owned by the task rather than the policy. Everything here is
# needed to *state* the laws; the lemmas that use it are the policy's to write.

# `le(a, b)` is `True{}` when `a` is at most `b`. Note that the step case of a
# proof about it consumes one successor from *each* side at once, which is why
# `le(a, a)` and `le(1n + a, a)` are the two facts the laws below need.
def le(a: Nat, b: Nat) -> Bool:
  match a:
    case 0n:
      True{}
    case 1n+p:
      match b:
        case 0n:
          False{}
        case 1n+q:
          le(p, q)

# `below_put(c, k)` is `c`, or one more than `c` when `k` is `True{}`.
def below_put(c: Nat, k: Bool) -> Nat:
  match k:
    case False{}:
      c
    case True{}:
      1n + c

# `below_count(xs, n)` counts the elements of `xs` that are at most `n`. It is
# the number of elements `filter(xs, n)` is allowed to keep -- exactly, not as
# a bound, so the law it appears in rejects a filter that drops one.
def below_count(xs: List<Nat>, +n: Nat) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      below_put(below_count(t, n), le(h, n))

# `filter_put(h, r, k)` is `h <> r` when `k` is `True{}`, and `r` otherwise. It
# is the cons step of `filter`, factored out so that the decision is an
# argument: a `match` cannot scrutinise a computed value in Bend.
def filter_put(h: Nat, r: List<Nat>, k: Bool) -> List<Nat>:
  match k:
    case False{}:
      r
    case True{}:
      h <> r
