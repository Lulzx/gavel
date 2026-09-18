import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `append` matches on its first argument, so `Nil{}` is its right identity only
# by induction: the goal is stuck on a variable list until the hypothesis has
# rewritten the tail.
def Policy.append_nil(xs: List<Nat>) -> {P.append(xs, Nil{}) == xs : List<Nat>}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Policy.append_nil(t) : {h <> P.append(t, Nil{}) == h <> _ : List<Nat>}
      {==}

# `+` is stuck on a variable, so reassociating it needs its own induction. `b`
# and `c` are erased -- they appear in the statement, never in the computation --
# which keeps the induction variable to a single live use.
def Policy.add_assoc(a: Nat, -b: Nat, -c: Nat) -> {a + (b + c) == (a + b) + c : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_assoc(p, b, c) : {1n + (p + (b + c)) == 1n + _ : Nat}
      {==}

# `len` folds over `append`: the head becomes one succ outside, and the tail's
# length is the hypothesis. What is left is the reassociation of `+`. `ys` is
# erased -- it is only ever the fixed second argument of the `append`.
def Policy.len_append(xs: List<Nat>, -ys: List<Nat>) -> {P.len(P.append(xs, ys)) == P.len(xs) + P.len(ys) : Nat}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, P.len(P.append(t, ys)), P.len(t) + P.len(ys), Policy.len_append(t, ys)) : {1n + _ == P.len(h <> t) + P.len(ys) : Nat}
      %Policy.add_assoc(1n, P.len(t), P.len(ys)) : {1n + (P.len(t) + P.len(ys)) == _ : Nat}
      {==}

# The same shape with `sum`, whose cons step puts `h +` outside instead of `1n +`.
def Policy.sum_append(xs: List<Nat>, -ys: List<Nat>) -> {P.sum(P.append(xs, ys)) == P.sum(xs) + P.sum(ys) : Nat}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, P.sum(P.append(t, ys)), P.sum(t) + P.sum(ys), Policy.sum_append(t, ys)) : {h + _ == P.sum(h <> t) + P.sum(ys) : Nat}
      %Policy.add_assoc(h, P.sum(t), P.sum(ys)) : {h + (P.sum(t) + P.sum(ys)) == _ : Nat}
      {==}

# The induction is on `xss`, and the step case folds `len` over the `append`
# whose right side is `concat(t)` -- a list the hypothesis describes but that
# nothing here can match on. `len_append` splits the append, then the hypothesis
# replaces the tail's count with the measure.
def L.concat_len(xss):
  match xss:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, P.len(P.append(h, S.concat(t))), P.len(h) + P.len(S.concat(t)), Policy.len_append(h, S.concat(t))) : {_ == P.len(h) + P.sum_lens(t) : Nat}
      %Equal.sym(Nat, P.len(S.concat(t)), P.sum_lens(t), L.concat_len(t)) : {P.len(h) + _ == P.len(h) + P.sum_lens(t) : Nat}
      {==}

# The same induction with the finer measure: `sum` in place of `len` on both the
# flattened side and the counted side.
def L.concat_sum(xss):
  match xss:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(Nat, P.sum(P.append(h, S.concat(t))), P.sum(h) + P.sum(S.concat(t)), Policy.sum_append(h, S.concat(t))) : {_ == P.sum(h) + P.sum_sums(t) : Nat}
      %Equal.sym(Nat, P.sum(S.concat(t)), P.sum_sums(t), L.concat_sum(t)) : {P.sum(h) + _ == P.sum(h) + P.sum_sums(t) : Nat}
      {==}

# A one-piece list unfolds to `append(xs, Nil{})`, and the right identity of
# `append` is exactly that.
def L.concat_single(xs):
  %Equal.sym(List<Nat>, P.append(xs, Nil{}), xs, Policy.append_nil(xs)) : {_ == xs : List<Nat>}
  {==}
