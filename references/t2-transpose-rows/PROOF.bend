import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def L.transpose_nil():
  {==}

def L.transpose_cons(r, rs):
  {==}

def L.transpose_single_row(r):
  match r:
    case Nil{}:
      {==}
    case h <> t:
      %L.transpose_single_row(t) :
          {(h <> Nil{}) <> S.insert_row(t, Nil{}) == (h <> Nil{}) <> _ : List<&2, List<&2, Nat>>}
      {==}

def L.insert_row_nil(cols):
  {==}

def L.insert_row_empty_cols(h, t):
  {==}

def L.insert_row_cons_cols(h, t, c, cs):
  {==}

def L.transpose_two_by_two():
  {==}
