import Base
import ./prelude.bend as P
import ./solution.bend as S

law step_op:
  for xs: List<&2, P.Sym>
  {S.step(xs, P.Op{}) == P.snoc(xs, P.Op{}) : List<&2, P.Sym>}

law step_cl:
  for xs: List<&2, P.Sym>
  {S.step(xs, P.Cl{}) == P.snoc(xs, P.Cl{}) : List<&2, P.Sym>}

law step_len:
  for xs: List<&2, P.Sym>
  for s: P.Sym
  {P.len(S.step(xs, s)) == 1n + P.len(xs) : Nat}

law step_wf:
  for +xs: List<&2, P.Sym>
  for s: P.Sym
  for e: {P.wf(xs) == True{} : Bool}
  for g: {P.closable(xs) == True{} : Bool}
  {P.wf(S.step(xs, s)) == True{} : Bool}
