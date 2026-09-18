import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def Policy.glue_nil_right(xs: List<&2, Nat>) -> {P.glue(xs, Nil{}) == xs : List<&2, Nat>}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(List<&2, Nat>, P.glue(t, Nil{}), t, Policy.glue_nil_right(t)) : {h <> _ == h <> t : List<&2, Nat>}
      {==}

def Policy.glue_assoc(xs: List<&2, Nat>, ys: List<&2, Nat>, zs: List<&2, Nat>) -> {P.glue(P.glue(xs, ys), zs) == P.glue(xs, P.glue(ys, zs)) : List<&2, Nat>}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(List<&2, Nat>, P.glue(P.glue(t, ys), zs), P.glue(t, P.glue(ys, zs)), Policy.glue_assoc(t, ys, zs)) : {h <> _ == h <> P.glue(t, P.glue(ys, zs)) : List<&2, Nat>}
      {==}

def L.exec_nil(w):
  {==}

def L.exec_emit(n, w):
  {==}

def L.exec_splice(p, q, w):
  match p:
    case Nil{}:
      {==}
    case h <> t:
      match h:
        case P.Emit{n}:
          %Equal.sym(List<&2, Nat>, S.exec(P.splice(t, q), P.glue(w, n <> Nil{})), S.exec(q, S.exec(t, P.glue(w, n <> Nil{}))), L.exec_splice(t, q, P.glue(w, n <> Nil{}))) : {_ == S.exec(q, S.exec(t, P.glue(w, n <> Nil{}))) : List<&2, Nat>}
          {==}

def Policy.exec_compile(e: P.Expr, +w: List<&2, Nat>) -> {S.exec(S.compile(e), w) == P.glue(w, P.eval(e)) : List<&2, Nat>}:
  match e:
    case P.Empty{}:
      %Policy.glue_nil_right(w) : {_ == P.glue(w, Nil{}) : List<&2, Nat>}
      {==}
    case P.Sym{n}:
      {==}
    case P.Cat{+a, +b}:
      %Equal.sym(List<&2, Nat>, S.exec(P.splice(S.compile(a), S.compile(b)), w), S.exec(S.compile(b), S.exec(S.compile(a), w)), L.exec_splice(S.compile(a), S.compile(b), w)) : {_ == P.glue(w, P.glue(P.eval(a), P.eval(b))) : List<&2, Nat>}
      %Equal.sym(List<&2, Nat>, S.exec(S.compile(a), w), P.glue(w, P.eval(a)), Policy.exec_compile(a, w)) : {S.exec(S.compile(b), _) == P.glue(w, P.glue(P.eval(a), P.eval(b))) : List<&2, Nat>}
      %Equal.sym(List<&2, Nat>, S.exec(S.compile(b), P.glue(w, P.eval(a))), P.glue(P.glue(w, P.eval(a)), P.eval(b)), Policy.exec_compile(b, P.glue(w, P.eval(a)))) : {_ == P.glue(w, P.glue(P.eval(a), P.eval(b))) : List<&2, Nat>}
      %Policy.glue_assoc(w, P.eval(a), P.eval(b)) : {P.glue(P.glue(w, P.eval(a)), P.eval(b)) == _ : List<&2, Nat>}
      {==}

def L.exec_compile(e, w):
  Policy.exec_compile(e, w)
