import Base
import ./prelude.bend as P

# HAND MUTANT (base-case rule). The reference with `insert_row`'s empty-row case
# answering a matrix with an extra one-element column instead of `cols`. The law
# `insert_row_nil` has a ground left-hand side -- `insert_row(Nil{}, cols)` --
# so it is an answer a stopped match gives rather than a step, and every
# generated mutant rewrites a step. Measured 2026-09-19: tier 3, laws_failed
# [insert_row_nil, transpose_single_row, transpose_two_by_two].

def insert_row(r: List<&2, Nat>, cols: List<&2, List<&2, Nat>>) -> List<&2, List<&2, Nat>>:
  match r:
    case Nil{}:
      (0n <> Nil{}) <> cols
    case h <> t:
      match cols:
        case Nil{}:
          (h <> Nil{}) <> insert_row(t, Nil{})
        case c <> cs:
          (h <> c) <> insert_row(t, cs)

def transpose(rows: List<&2, List<&2, Nat>>) -> List<&2, List<&2, Nat>>:
  match rows:
    case Nil{}:
      Nil{}
    case r <> rs:
      insert_row(r, transpose(rs))
