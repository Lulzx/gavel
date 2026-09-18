import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def Policy.bool_ite(b: Bool, x: Bool) -> Bool:
  match b:
    case True{}:
      True{}
    case False{}:
      x

# From `False == True` nothing survives: transport along the absurd equation.
def Policy.absurd_true(x: Bool, e: {False{} == True{} : Bool}) -> {x == True{} : Bool}:
  Equal.cong(Bool, Bool, b => Policy.bool_ite(b, x), False{}, True{}, e)

def Policy.len_snoc(+xs: List<&2, P.Sym>, +s: P.Sym)
    -> {P.len(P.snoc(xs, s)) == 1n + P.len(xs) : Nat}:
  match xs:
    case Nil{}:
      {==}
    case +h <> t:
      %Equal.sym(Nat, P.len(P.snoc(t, s)), 1n + P.len(t), Policy.len_snoc(t, s)) : {1n + _ == 1n + (1n + P.len(t)) : Nat}
      {==}

# Appending one symbol keeps a well-formed stack well-formed, provided the
# stack still has an opening to spend -- that is the `closable` hypothesis, and
# it is what the `Cl` case would otherwise fail on (`Nil` is well-formed and
# closing it is not). The statement is generalized over the accumulator `n`
# because both `wf_go` and the induction walk the stack in the same direction
# but stop at different points: the append has to be replayed under whatever
# `n` the scan has reached, not just under `0n`.
def Policy.wf_snoc(+xs: List<&2, P.Sym>, +n: Nat, +s: P.Sym,
                   +e: {P.wf_go(xs, n) == True{} : Bool},
                   +g: {Nat.is_gt(P.depth_go(xs, n), 0n) == True{} : Bool})
    -> {P.wf_go(P.snoc(xs, s), n) == True{} : Bool}:
  match xs:
    case Nil{}:
      match n:
        case 0n:
          Policy.absurd_true(P.wf_go(P.snoc(Nil{}, s), 0n), g)
        case 1n+p:
          match s:
            case P.Op{}:
              {==}
            case P.Cl{}:
              {==}
    case P.Op{} <> t:
      Policy.wf_snoc(t, 1n + n, s, e, g)
    case P.Cl{} <> t:
      match n:
        case 0n:
          Policy.absurd_true(P.wf_go(P.snoc(P.Cl{} <> t, s), 0n), e)
        case 1n+p:
          Policy.wf_snoc(t, p, s, e, g)

def L.step_op(xs):
  {==}

def L.step_cl(xs):
  {==}

def L.step_len(xs, s):
  match s:
    case P.Op{}:
      Policy.len_snoc(xs, P.Op{})
    case P.Cl{}:
      Policy.len_snoc(xs, P.Cl{})

def L.step_wf(xs, s, e, g):
  match s:
    case P.Op{}:
      Policy.wf_snoc(xs, 0n, P.Op{}, e, g)
    case P.Cl{}:
      Policy.wf_snoc(xs, 0n, P.Cl{}, e, g)
