import Base
import ./prelude.bend as P
import ./solution.bend as S

# -- The laws that say what `exec` is -----------------------------------------
#
# One equation per instruction, plus the empty program. Each is stated over an
# arbitrary tail rather than over a one-instruction program, and that is the
# whole difference: a one-instruction version of all four is satisfied by an
# `exec` that applies the first instruction and stops, and nothing else here
# would notice, because the optimiser's laws are about `opt` and the two
# programs they compare are truncated in the same way. With the tail arbitrary
# there is no such body -- the four clauses determine `exec` by induction on
# the program, and the accumulator, which appears in every one of them and
# nowhere in any program text, is what stops `opt` from absorbing the damage.
#
# They are definitional in the sense of this bank: the reference solution
# proves each with `{==}`, because each is its own body read back.

law exec_nil:
  for s: Nat
  {S.exec(Nil{}, s) == s : Nat}

law exec_zero:
  for t: List<&2, P.Op>
  for s: Nat
  {S.exec(P.Zero{} <> t, s) == S.exec(t, 0n) : Nat}

law exec_inc:
  for t: List<&2, P.Op>
  for s: Nat
  {S.exec(P.Inc{} <> t, s) == S.exec(t, 1n + s) : Nat}

law exec_twice:
  for t: List<&2, P.Op>
  for s: Nat
  {S.exec(P.Twice{} <> t, s) == S.exec(t, s + s) : Nat}

# -- The laws that judge the optimiser -----------------------------------------
#
# Three obligations, and they are not three ways of saying one thing.
#
# `clean_opt` is the specification: under the flag it was handed, what `opt`
# returns has nothing left to remove. It is the law that catches an optimiser
# that keeps a redundant instruction.
#
# The other two are the price of removing anything, and there are two of them
# because the flag is a *claim* about the accumulator and a claim has to be
# cashed where it is made. `opt_sound` is the caller that does not know what
# the accumulator holds, `opt_sound_zero` the caller that knows it holds zero,
# and neither implies the other: an optimiser that drops a redundant `Twice`
# whether or not the caller claimed a zero -- that is, one that reads `opt`'s
# own flag and not its argument's -- is the reference one on `True` and wrong
# on `False`, so it proves the second law and fails the first. The flag is
# threaded through `opt` for exactly this reason: the drop the task is about is
# unsound in general and sound only where the accumulator is known to be zero,
# and dropping it without that knowledge is a bug that a single law stated over
# the unknown state would catch only by accident.

law clean_opt:
  for p: List<&2, P.Op>
  for z: Bool
  {P.clean(S.opt(p, z), z) == True{} : Bool}

law opt_sound:
  for p: List<&2, P.Op>
  for s: Nat
  {S.exec(S.opt(p, False{}), s) == S.exec(p, s) : Nat}

law opt_sound_zero:
  for p: List<&2, P.Op>
  {S.exec(S.opt(p, True{}), 0n) == S.exec(p, 0n) : Nat}

# The drop itself, named. This is the one branch of `opt` the three laws above
# leave free, and it has to be pinned because it is the only branch that is
# allowed to remove an instruction.
#
# `clean` forbids a `Twice` where the accumulator is known to be zero, and
# `clean_opt` says `opt` returns nothing it forbids -- but neither says the
# instruction has to *go*. A `Zero` is always permitted there, and at a
# known-zero accumulator a `Zero` is a no-op, so an optimiser that answers
# `P.Zero{} <> opt(t, True{})` is clean and sound and still not the optimiser
# this task is about. **Measured 2026-09-19: tier 4, complete, reward 1.000
# against the reference proof**, all seven laws. This law is the definition of
# the drop, so the branch cannot answer something else and still be clean.
law opt_twice_zero:
  for t: List<&2, P.Op>
  {S.opt(P.Twice{} <> t, True{}) == S.opt(t, True{}) : List<&2, P.Op>}
