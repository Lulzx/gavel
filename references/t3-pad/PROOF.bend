import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `P.max` steps on its first argument and then on its second. With a variable on
# the left the result is stuck, but with `0n` on the right the second match is
# the base case, so `P.max(a, 0n)` is one step from `a`.
def Policy.max_zero_right(a: Nat) -> {P.max(a, 0n) == a : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      {==}

# `pad` matches on the count first, so a zero count never reaches the list: both
# sides are `xs`.
def L.pad_nil(x, xs):
  {==}

# A one-element pad onto nothing: the count unfolds to the successor case, and
# `pad`'s own base case leaves the element in front of `Nil{}`.
def L.pad_single(x):
  {==}

# The induction. On a successor count `pad` unfolds to a cons whose tail is
# `pad(k, x, ...)`, so `P.len` exposes a `1n +` on the left, while the right is
# `P.max(1n + k, ...)` and steps to `1n + P.max(k, ...)`. The cons case is then
# the hypothesis; the empty case is the hypothesis plus the `P.max` fact at
# `0n`, which does not compute, so `k` is re-bound reusable before both calls.
def L.pad_len(n, x, xs):
  match n:
    case 0n:
      {==}
    case 1n+k:
      match xs:
        case Nil{}:
          +k = k
          %Equal.sym(Nat, P.len(S.pad(k, x, Nil{})), P.max(k, 0n),
                     L.pad_len(k, x, Nil{})) : {1n + _ == 1n + k : Nat}
          %Equal.sym(Nat, P.max(k, 0n), k, Policy.max_zero_right(k)) : {1n + _ == 1n + k : Nat}
          {==}
        case h <> t:
          %Equal.sym(Nat, P.len(S.pad(k, x, t)), P.max(k, P.len(t)),
                     L.pad_len(k, x, t)) : {1n + _ == 1n + P.max(k, P.len(t)) : Nat}
          {==}

# Definitional: the count steps and the list steps, and the result is the
# right-hand side. The overwriting body leaves `x <> pad(n, x, ys)` against it,
# which needs `x == y` at variables.
def L.pad_step(n, x, y, ys):
  {==}
