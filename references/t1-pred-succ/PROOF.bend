import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Adding one on the right is adding one on the left. Inductive in `x`; the
# step's hypothesis is `add(p, 1n) == 1n+p`, which is the whole goal.
def Policy.add_one_comm(x: Nat) -> {S.add(x, 1n) == 1n + x : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_one_comm(p) : {1n + S.add(p, 1n) == 1n + _ : Nat}
      {==}

# `pred` steps on its argument, so `pred` of `1n+x` is `x` by reduction alone.
def L.pred_succ(x):
  {==}

# The base case closes by reduction: `add(0n, 1n)` is `1n` and `pred` of it is
# `0n`. The step reduces to `{S.add(p, 1n) == 1n+p}`, which is the lemma.
def L.pred_add_one(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_one_comm(p) : {S.add(p, 1n) == _ : Nat}
      {==}

# `pred` matches on its argument, so `pred(0n)` is `0n` by unfolding. The binder
# is there because every law in this bank is instantiated through one.
def L.pred_zero(x):
  {==}

# Adding zero on the right changes nothing. Base's `+` does not reduce on a
# variable, so `x + 0n` is stuck and `S.add`'s first-argument recursion is what
# removes it; the induction in `x` is what does that. Inductive, and its
# hypothesis is its goal.
def Policy.add_zero(x: Nat) -> {S.add(x, 0n) == x : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero(p) : {1n + S.add(p, 0n) == 1n + _ : Nat}
      {==}

# The goal is exactly what `Policy.add_zero` proves, so the lemma is the proof.
def L.add_zero(x):
  Policy.add_zero(x)

# Adding a successor on the right is adding one on the left of the sum. `add`
# recurses on its *first* argument, so this is not definitional -- the induction
# is in `a`, and `b` is the second argument the goal's `1n+` wraps. The step's
# hypothesis is the goal one `p` down, at the same `b`.
def Policy.add_succ(a: Nat, b: Nat) -> {S.add(a, 1n+b) == 1n + S.add(a, b) : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_succ(p, b) : {1n + S.add(p, 1n+b) == 1n + _ : Nat}
      {==}

def L.add_succ(a, b):
  Policy.add_succ(a, b)
