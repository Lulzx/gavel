import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The later number of the advanced pair is the two of them added. Definitional:
# the pair is destructured and `advance` answers, so both sides compute.
def Policy.advance_snd(p: P.Pair) -> {P.snd(P.advance(p)) == P.fst(p) + P.snd(p) : Nat}:
  match p:
    case P.MkPair{a, b}:
      {==}

# Addition regroups. Inductive in `a`, which is the only argument that shrinks:
# at the step the goal is `1n + (p + (b + c))` against `(1n + p) + (b + c)`,
# which is the hypothesis's two sides under one more `1n`.
def Policy.add_assoc(a: Nat, -b: Nat, -c: Nat) -> {a + (b + c) == (a + b) + c : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_assoc(p, b, c) : {1n + (p + (b + c)) == 1n + _ : Nat}
      {==}

# Both sides are the empty match case, so the pair and the total are
# definitional at `0n` and at `1n + k`.
def L.fib_pair_zero():
  {==}

def L.fib_pair_succ(k):
  {==}

def L.sum_fib_zero():
  {==}

def L.sum_fib_succ(k):
  {==}

# The induction is the proof: with `n` a variable neither side computes. The
# step has `sum_fib` at `1n + k` on the left, which is the earlier half of the
# pair at `k` plus the total at `k`, against `snd` of the pair at `1n + k`. The
# pair on the right is `advance` of the pair at `k`, so the first rewrite is
# `advance_snd` read backwards -- it states `snd(advance(p))` as
# `fst(p) + snd(p)`, and the goal needs that sum turned back into an `advance`.
# The hypothesis then names the total at `k` against `snd` of the pair at `k`,
# and `add_assoc` regroups `(fst + sum_fib) + 1n` into `fst + (sum_fib + 1n)`
# so the hypothesis lands under the `fst` that is already there.
def L.sum_fib_pair(n):
  match n:
    case 0n:
      {==}
    case 1n++k:
      %Equal.sym(Nat, P.snd(P.advance(S.fib_pair(k))), P.fst(S.fib_pair(k)) + P.snd(S.fib_pair(k)), Policy.advance_snd(S.fib_pair(k))) :
          {(P.fst(S.fib_pair(k)) + S.sum_fib(k)) + 1n == _ : Nat}
      %L.sum_fib_pair(k) : {(P.fst(S.fib_pair(k)) + S.sum_fib(k)) + 1n == P.fst(S.fib_pair(k)) + _ : Nat}
      %Policy.add_assoc(P.fst(S.fib_pair(k)), S.sum_fib(k), 1n) : {_ == P.fst(S.fib_pair(k)) + (S.sum_fib(k) + 1n) : Nat}
      {==}
