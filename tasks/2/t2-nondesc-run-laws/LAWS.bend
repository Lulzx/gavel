import Base
import ./prelude.bend as P
import ./solution.bend as S

law nondesc_run_nil:
  {S.nondesc_run(Nil{}) == 0n : Nat}

law nondesc_run_single:
  for x: Nat
  {S.nondesc_run(x <> Nil{}) == 1n : Nat}

law nondesc_run_up:
  for x: Nat
  for y: Nat
  for +t: List<&2, Nat>
  for e: {P.le(x, y) == True{} : Bool}
  {S.nondesc_run(x <> y <> t) == 1n + S.nondesc_run(y <> t) : Nat}

law nondesc_run_down:
  for x: Nat
  for y: Nat
  for +t: List<&2, Nat>
  for e: {P.le(x, y) == False{} : Bool}
  {S.nondesc_run(x <> y <> t) == 1n : Nat}

law nondesc_run_le_len:
  for x: Nat
  for +t: List<&2, Nat>
  {P.le(S.nondesc_run(x <> t), P.len(x <> t)) == True{} : Bool}
