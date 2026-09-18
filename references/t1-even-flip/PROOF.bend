import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def Policy.not_not(b: Bool) -> {b == Bool.not(Bool.not(b)) : Bool}:
  match b:
    case False{}:
      {==}
    case True{}:
      {==}

def L.even_flip(x):
  +e = S.even(x)
  %Policy.not_not(e) : {e == _ : Bool}
  {==}

# `even` of `0n` is `True{}` by unfolding alone; the binder is there because
# every law in this bank is instantiated through one.
def L.even_zero(x):
  {==}
