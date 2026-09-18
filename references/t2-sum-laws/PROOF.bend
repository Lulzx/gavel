import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `sum_single` unfolds to `add_zero` at `h`: `sum(h <> Nil{})` is `add(h, 0n)`.
def Policy.add_zero(x: Nat) -> {S.add(x, 0n) == x : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_zero(p) : {1n+S.add(p, 0n) == 1n+_ : Nat}
      {==}

# `sum_append` needs associativity of `add`, so it is proved through helpers.
# The helper writes its list parameters `+xs`/`+ys` so that the tail of `xs` and
# `ys` itself may each be named twice in the step case.
def Policy.add_assoc(x: Nat, y: Nat, z: Nat) ->
    {S.add(S.add(x, y), z) == S.add(x, S.add(y, z)) : Nat}:
  match x:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_assoc(p, y, z) : {1n+S.add(S.add(p, y), z) == 1n+_ : Nat}
      {==}

def Policy.sum_append(+xs: List<&2, Nat>, +ys: List<&2, Nat>) ->
    {S.sum(S.append(xs, ys)) == S.add(S.sum(xs), S.sum(ys)) : Nat}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      # Fold the tail first: `sum(h <> append(t, ys))` is `add(h, ...)`.
      %Equal.sym(Nat, S.sum(S.append(t, ys)), S.add(S.sum(t), S.sum(ys)), Policy.sum_append(t, ys)) : {S.add(h, _) == S.add(S.add(h, S.sum(t)), S.sum(ys)) : Nat}
      # Then reassociate so that `h` is added on the outside.
      %Policy.add_assoc(h, S.sum(t), S.sum(ys)) : {_ == S.add(S.add(h, S.sum(t)), S.sum(ys)) : Nat}
      {==}

def L.sum_append(xs, ys):
  Policy.sum_append(xs, ys)

def L.sum_single(h):
  %Policy.add_zero(h) : {S.add(h, 0n) == _ : Nat}
  {==}
