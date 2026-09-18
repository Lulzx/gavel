import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# `P.eq_nat` matches on both arguments, so with variables on both sides nothing
# reduces. Reflexivity and symmetry are therefore inductions, not computations.
def Policy.eq_nat_refl(a: Nat) -> {P.eq_nat(a, a) == True{} : Bool}:
  match a:
    case 0n:
      {==}
    case 1n+p:
      %Policy.eq_nat_refl(p) : {P.eq_nat(p, p) == _ : Bool}
      {==}

def Policy.eq_nat_sym(a: Nat, b: Nat) -> {P.eq_nat(a, b) == P.eq_nat(b, a) : Bool}:
  match a:
    case 0n:
      match b:
        case 0n:
          {==}
        case 1n+q:
          {==}
    case 1n+p:
      match b:
        case 0n:
          {==}
        case 1n+q:
          %Policy.eq_nat_sym(p, q) : {P.eq_nat(p, q) == _ : Bool}
          {==}

# `P.eq_list` reads its two sides left to right -- the head of the first against
# the head of the second -- so swapping the arguments is not the same term, and
# the fact that the answer does not change is an induction on both lists.
def Policy.eq_list_sym(xs: List<&2, Nat>, ys: List<&2, Nat>)
    -> {P.eq_list(xs, ys) == P.eq_list(ys, xs) : Bool}:
  match xs:
    case Nil{}:
      match ys:
        case Nil{}:
          {==}
        case h <> t:
          {==}
    case h <> t:
      match ys:
        case Nil{}:
          {==}
        case h2 <> t2:
          %Policy.eq_nat_sym(h, h2) :
              {Bool.and(P.eq_nat(h, h2), P.eq_list(t, t2)) == Bool.and(_, P.eq_list(t2, t)) : Bool}
          %Policy.eq_list_sym(t, t2) :
              {Bool.and(P.eq_nat(h, h2), P.eq_list(t, t2)) == Bool.and(P.eq_nat(h, h2), _) : Bool}
          {==}

# `P.rev` is built from `P.snoc`, so reversing a list with one element on the
# end does not reduce until the induction moves that element across.
def Policy.rev_snoc(xs: List<&2, Nat>, y: Nat)
    -> {P.rev(P.snoc(xs, y)) == y <> P.rev(xs) : List<&2, Nat>}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(List<&2, Nat>, P.rev(P.snoc(t, y)), y <> P.rev(t), Policy.rev_snoc(t, y)) :
          {P.snoc(_, h) == y <> P.snoc(P.rev(t), h) : List<&2, Nat>}
      {==}

# This is `rev_rev` as a helper: it is one of the laws of another task, and a
# helper may never cite a law, so it is reproved here.
def Policy.rev_rev(+xs: List<&2, Nat>) -> {P.rev(P.rev(xs)) == xs : List<&2, Nat>}:
  match xs:
    case Nil{}:
      {==}
    case h <> t:
      %Equal.sym(List<&2, Nat>, P.rev(P.snoc(P.rev(t), h)), h <> P.rev(P.rev(t)), Policy.rev_snoc(P.rev(t), h)) :
          {_ == h <> t : List<&2, Nat>}
      %Equal.sym(List<&2, Nat>, P.rev(P.rev(t)), t, Policy.rev_rev(t)) :
          {h <> _ == h <> t : List<&2, Nat>}
      {==}

def L.is_pal_nil():
  {==}

def L.is_pal_single(h):
  %Equal.sym(Bool, P.eq_nat(h, h), True{}, Policy.eq_nat_refl(h)) :
      {Bool.and(_, True{}) == True{} : Bool}
  {==}

def L.is_pal_two_distinct():
  {==}

def L.is_pal_rev(xs):
  %Equal.sym(List<&2, Nat>, P.rev(P.rev(xs)), xs, Policy.rev_rev(xs)) :
      {P.eq_list(P.rev(xs), _) == P.eq_list(xs, P.rev(xs)) : Bool}
  %Equal.sym(Bool, P.eq_list(P.rev(xs), xs), P.eq_list(xs, P.rev(xs)), Policy.eq_list_sym(P.rev(xs), xs)) :
      {_ == P.eq_list(xs, P.rev(xs)) : Bool}
  {==}
