import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The two transports: an equation that says `False{} == True{}` proves any goal,
# because everything is equal to itself once the two booleans are identified.
def Policy.list_ite(c: Bool, x: List<&2, Nat>, y: List<&2, Nat>) -> List<&2, Nat>:
  match c:
    case True{}:
      x
    case False{}:
      y

def Policy.absurd_list(L: List<&2, Nat>, R: List<&2, Nat>, e: {False{} == True{} : Bool})
    -> {L == R : List<&2, Nat>}:
  Equal.cong(Bool, List<&2, Nat>, c => Policy.list_ite(c, R, L), False{}, True{}, e)

def Policy.imp_true(x: Bool) -> {P.imp(x, True{}) == True{} : Bool}:
  match x:
    case True{}:
      {==}
    case False{}:
      {==}

def Policy.app_nil_r(+xs: List<&2, Nat>) -> {P.app(xs, Nil{}) == xs : List<&2, Nat>}:
  match xs:
    case Nil{}:
      {==}
    case +h <> t:
      %Equal.sym(List<&2, Nat>, P.app(t, Nil{}), t, Policy.app_nil_r(t)) : {h <> _ == h <> t : List<&2, Nat>}
      {==}

# `+` is stuck on a variable head, so the reassociation of an append is not
# definitional: it is an induction, and the goal after one step is exactly the
# hypothesis under the head.
def Policy.app_assoc(+xs: List<&2, Nat>, +ys: List<&2, Nat>, +zs: List<&2, Nat>)
    -> {P.app(P.app(xs, ys), zs) == P.app(xs, P.app(ys, zs)) : List<&2, Nat>}:
  match xs:
    case Nil{}:
      {==}
    case +h <> t:
      Equal.cong(List<&2, Nat>, List<&2, Nat>, l => h <> l, P.app(P.app(t, ys), zs), P.app(t, P.app(ys, zs)), Policy.app_assoc(t, ys, zs))

# The accumulator lemma for the reverse: `rev_go(xs, acc)` is the reverse of `xs`
# in front of `acc`. Generalizing over `acc` is what makes the step go through,
# since the recursive call runs with a different accumulator than the goal's.
def Policy.rev_go_acc(+xs: List<&2, Nat>, +acc: List<&2, Nat>)
    -> {P.rev_go(xs, acc) == P.app(P.rev_go(xs, Nil{}), acc) : List<&2, Nat>}:
  match xs:
    case Nil{}:
      {==}
    case +h <> t:
      %Equal.sym(List<&2, Nat>, P.rev_go(t, h <> Nil{}), P.app(P.rev_go(t, Nil{}), h <> Nil{}), Policy.rev_go_acc(t, h <> Nil{})) : {P.rev_go(t, h <> acc) == P.app(_, acc) : List<&2, Nat>}
      %Equal.sym(List<&2, Nat>, P.app(P.app(P.rev_go(t, Nil{}), h <> Nil{}), acc), P.app(P.rev_go(t, Nil{}), P.app(h <> Nil{}, acc)), Policy.app_assoc(P.rev_go(t, Nil{}), h <> Nil{}, acc)) : {P.rev_go(t, h <> acc) == _ : List<&2, Nat>}
      Policy.rev_go_acc(t, h <> acc)

# A consequence, in the shape the contents law needs: reversing a list that was
# consed onto is appending one element after the reverse.
def Policy.rev_cons(+xs: List<&2, Nat>, +x: Nat)
    -> {P.rev(x <> xs) == P.app(P.rev(xs), x <> Nil{}) : List<&2, Nat>}:
  Policy.rev_go_acc(xs, x <> Nil{})

# The same fact with a list in front of it, which is the shape the goal of the
# contents law takes once `to_list` has consumed the front of the queue.
def Policy.rev_cons_app(+xs: List<&2, Nat>, +b: List<&2, Nat>, +x: Nat)
    -> {P.app(xs, P.rev(x <> b)) == P.app(P.app(xs, P.rev(b)), x <> Nil{}) : List<&2, Nat>}:
  match xs:
    case Nil{}:
      Policy.rev_cons(b, x)
    case +h <> t:
      Equal.cong(List<&2, Nat>, List<&2, Nat>, l => h <> l, P.app(t, P.rev(x <> b)), P.app(P.app(t, P.rev(b)), x <> Nil{}), Policy.rev_cons_app(t, b, x))

def L.push_wf(q, x):
  match q:
    case P.Q{Nil{}, b}:
      {==}
    case P.Q{h <> t, b}:
      {==}

def L.pop_wf(q):
  match q:
    case P.Q{Nil{}, b}:
      {==}
    case P.Q{h <> Nil{}, b}:
      Policy.imp_true(P.is_nil(P.rev(b)))
    case P.Q{h <> (h2 <> t2), b}:
      {==}

def L.pop_empty():
  {==}

def L.push_contents(q, x, e):
  match q:
    case P.Q{Nil{}, b}:
      match b:
        case Nil{}:
          {==}
        case h <> t:
          Policy.absurd_list(P.to_list(S.push(P.Q{Nil{}, h <> t}, x)), P.app(P.to_list(P.Q{Nil{}, h <> t}), x <> Nil{}), e)
    case P.Q{h <> t, b}:
      Equal.cong(List<&2, Nat>, List<&2, Nat>, l => h <> l, P.app(t, P.rev(x <> b)), P.app(P.app(t, P.rev(b)), x <> Nil{}), Policy.rev_cons_app(t, b, x))

def L.pop_contents(h, t, b):
  match t:
    case Nil{}:
      Policy.app_nil_r(P.rev(b))
    case +h2 <> t2:
      {==}
