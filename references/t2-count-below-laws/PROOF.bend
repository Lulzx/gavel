import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# Helper lemmas. `Policy.` is the reserved namespace: the gate ignores it and
# the credit path does not count it, so helpers are free -- but none of them
# may cite a law.

# The one arithmetic fact the split needs that `+` does not give on its own:
# `+` matches on its *first* argument, so `cb + (1n + ca)` is stuck where
# `1n + (cb + ca)` is not. The two are equal, and this is the induction that
# says so. `0n + y` reduces to `y` and `(1n + p) + y` reduces to `1n + (p + y)`,
# so both cases are the hypothesis under the `1n +` the goal already has. It is
# stated with the reducing side on the left: a `%` step replaces the *right*
# side of its equation by the left, and the stuck form is the one a goal has to
# be rid of.
def Policy.add_succ_right(a: Nat, b: Nat) -> {1n + (a + b) == a + (1n + b) : Nat}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.add_succ_right(p, b) : {1n + ((1n + p) + b) == 1n + _ : Nat}
      {==}

# The cons step of the split law, with the decision exposed as an argument and
# the hypothesis for the tail taken as an argument too, because the two answers
# of the comparison want different things from it: on the passing branch the
# head's `1n +` sits on the first count, on the failing branch on the second,
# and only a `match` on an argument can tell them apart.
def Policy.split_step(+t: List<&2, Nat>, x: Nat, cb: Nat, ca: Nat, k: Bool,
                      ih: {cb + ca == P.len(t) : Nat})
    -> {P.cb_put(cb, k) + P.ca_put(ca, k) == 1n + P.len(t) : Nat}:
  match k:
    case True{}:
      # `(1n + cb) + ca` reduces to `1n + (cb + ca)` on its own, so the goal is
      # the hypothesis under the leading `1n +` and one rewrite closes it.
      %Equal.sym(Nat, cb + ca, P.len(t), ih) : {1n + _ == 1n + P.len(t) : Nat}
      {==}
    case False{}:
      # `cb + (1n + ca)` does not reduce, so the goal is turned round into the
      # shape above first and the hypothesis then applies the same way.
      %Policy.add_succ_right(cb, ca) : {_ == 1n + P.len(t) : Nat}
      %Equal.sym(Nat, cb + ca, P.len(t), ih) : {1n + _ == 1n + P.len(t) : Nat}
      {==}

# Definitional: `Nil{}` is a list constructor, so both matches take their empty
# case and the two counts are zero.
def L.count_below_nil(x):
  {==}

# The premise is `{P.le(h, x) == True{}}` and the goal wants `True{}` where the
# comparison sits, so the step is the premise turned round by `Equal.sym`. With
# the decision a literal, `P.cb_put` answers one more than the tail's count.
def L.count_below_keep(h, t, x, e):
  %Equal.sym(Bool, P.le(h, x), True{}, e) : {P.cb_put(S.count_below(x, t), _) == 1n + S.count_below(x, t) : Nat}
  {==}

# The same rewrite with the other literal. The helper hands the tail's count
# back unchanged and the head is not counted.
def L.count_below_drop(h, t, x, e):
  %Equal.sym(Bool, P.le(h, x), False{}, e) : {P.cb_put(S.count_below(x, t), _) == S.count_below(x, t) : Nat}
  {==}

# The induction. The empty case is `0n + 0n` against `P.len(Nil{})`; the cons
# case is the helper above with the hypothesis for the tail and the comparison
# as the decision.
def L.count_below_split(xs, x):
  match xs:
    case Nil{}:
      {==}
    case h <> +t:
      Policy.split_step(t, x, S.count_below(x, t), S.count_above(x, t),
                        P.le(h, x), L.count_below_split(t, x))
