import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `S.max_all` walks the whole suffix, so its length is not a computation at a
# variable list: it is an induction, and the step keeps one cell and hands the
# rest to the hypothesis.
def Policy.max_all_len(ys: List<&2, Nat>, m: Nat) -> {P.len(S.max_all(ys, m)) == P.len(ys) : Nat}:
  match ys:
    case Nil{}:
      {==}
    case +h <> +t:
      %Policy.max_all_len(t, m) : {1n + P.len(S.max_all(t, m)) == 1n + _ : Nat}
      {==}

def L.max_all_nil(m):
  {==}

def L.max_all_cons(h, t, m):
  {==}

def L.cum_max_nil():
  {==}

def L.cum_max_single(x):
  {==}

def L.cum_max_cons(h, t):
  {==}

# The suffix is walked before the head is folded in, so the two sides are not the
# same unfolding at a variable list. The step reduces the head off the answer and
# leaves `len(max_all(cum_max(t), h))` against `len(t)`: the hypothesis rewrites
# the inner `len(t)`, and the lemma about the raise rewrites what is left.
def L.cum_max_len(xs):
  match xs:
    case Nil{}:
      {==}
    case +h <> +t:
      %L.cum_max_len(t) : {1n + P.len(S.max_all(S.cum_max(t), h)) == 1n + _ : Nat}
      %Policy.max_all_len(S.cum_max(t), h) : {1n + P.len(S.max_all(S.cum_max(t), h)) == 1n + _ : Nat}
      {==}

def L.cum_max_three():
  {==}
