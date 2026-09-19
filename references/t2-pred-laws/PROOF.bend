import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `pred_succ` is definitional: `pred` is the deconstructor of `Nat`, so
# `pred(1n+x)` already computes to `x`.
def L.pred_succ(x):
  {==}

# `add_one` is inductive in `x`. The successor case needs the fact that
# `add(p, 1n)` is `1n+p`, which is the induction hypothesis itself, so the step
# is just the hypothesis rewritten at `p`.
def L.add_one(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %L.add_one(p) : {1n+S.add(p, 1n) == 1n+_ : Nat}
      {==}

# `pred` matches on its argument, so `pred(0n)` is `0n` by unfolding. The binder
# is unused on purpose: every law in this bank is instantiated through one.
def L.pred_zero(x):
  {==}

# Adding zero on the right changes nothing. Base's `+` does not reduce on a
# variable, so `x + 0n` is stuck and `S.add`'s first-argument recursion is what
# removes it; the induction in `x` is what does that. Inductive, hypothesis is
# the goal.
def Policy.add_zero(x: Nat) -> {S.add(x, 0n) == x : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero(p) : {1n + S.add(p, 0n) == 1n + _ : Nat}
      {==}

def L.add_zero(x):
  Policy.add_zero(x)

# Adding a successor on the right is adding one on the left of the sum. `add`
# recurses on its *first* argument, so this is not definitional -- the induction
# is in `a`, and `b` is the second argument the goal's `1n+` wraps.
def Policy.add_succ(a: Nat, b: Nat) -> {S.add(a, 1n+b) == 1n + S.add(a, b) : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_succ(p, b) : {1n + S.add(p, 1n+b) == 1n + _ : Nat}
      {==}

def L.add_succ(a, b):
  Policy.add_succ(a, b)
