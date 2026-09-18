import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The helper is `len_map` itself: mapping does not change the length. It is
# inductive in `xs`, and the cons case pushes the operation one step into the
# tail, where the induction hypothesis applies.
def Policy.len_map(xs: List<Nat>) -> {S.len(S.map(xs)) == S.len(xs) : Nat}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Policy.len_map(t) : {1n+S.len(S.map(t)) == 1n+_ : Nat}
      {==}

# The law is the cons case of the helper: `map(h <> t)` is `(1n+h) <> map(t)`, so
# both sides reduce to `1n + len(map(t))` against `1n + len(t)`, and the helper
# rewrites the first into the second.
def L.len_map_cons(h, t):
  %Policy.len_map(t) : {1n+S.len(S.map(t)) == 1n+_ : Nat}
  {==}

# `map_cons` is what `map` computes at a cons, so it closes without induction.
def L.map_cons(h, t):
  {==}

# Definitional: the list steps to `1n + len(Nil{})`, which is `1n + 0n`.
def L.len_single(h):
  {==}
