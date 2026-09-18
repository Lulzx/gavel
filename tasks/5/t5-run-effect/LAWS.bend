import Base
import ./prelude.bend as P
import ./solution.bend as S

# -- The pinning laws --------------------------------------------------------
#
# Six definitional pins, one per function per instruction. There are only two
# instructions, so a body that answers these answers every instruction, and
# they are what stops the two readings of a program from drifting together:
# without them `run(prog, s) = s` and `effect(prog) = 0n` satisfy every other
# law here, because each one leaves the other function free to absorb the
# damage. That pair was measured at tier 4 before these six existed.

law step_inc:
  for s: Nat
  {S.step(s, P.Inc{}) == 1n + s : Nat}

law step_add:
  for s: Nat
  for n: Nat
  {S.step(s, P.Add{n}) == n + s : Nat}

# The accumulator a one-instruction program produces. `run` is the only thing
# that can answer these, since `effect` never sees the state.
law run_inc:
  for s: Nat
  {S.run(P.Inc{} <> Nil{}, s) == 1n + s : Nat}

law run_add:
  for s: Nat
  for n: Nat
  {S.run(P.Add{n} <> Nil{}, s) == n + s : Nat}

# And the same for the summary, which never sees the state and so is pinned
# without it.
law effect_inc:
  {S.effect(P.Inc{} <> Nil{}) == 1n : Nat}

law effect_add:
  for n: Nat
  {S.effect(P.Add{n} <> Nil{}) == n : Nat}

# -- The program-level laws --------------------------------------------------
#
# The first: running a concatenation is running the two halves in turn. `P.cat`
# is the prelude's append, so the law is about `run` and not about list surgery,
# and no `run` that ignores its program can satisfy it.
law run_compose:
  for p1: List<&2, P.Instr>
  for p2: List<&2, P.Instr>
  for s: Nat
  {S.run(P.cat(p1, p2), s) == S.run(p2, S.run(p1, s)) : Nat}

# The summary is additive over program text: what the concatenation does to the
# accumulator is what the two halves do, added.
law effect_hom:
  for p1: List<&2, P.Instr>
  for p2: List<&2, P.Instr>
  {S.effect(P.cat(p1, p2)) == S.effect(p1) + S.effect(p2) : Nat}

# The law the task is named for, and the only one that relates the two readings
# of the program. `effect` is computed from the text alone and `run` from the
# text and a state, and this says they agree for every program and every
# starting accumulator. Both sides mention one of the functions, which on its
# own pins neither; the state is what makes it a theorem rather than a
# definition, because `effect` cannot see `s` and so cannot imitate a `run` that
# changed it.
law run_effect:
  for prog: List<&2, P.Instr>
  for s: Nat
  {S.run(prog, s) == s + S.effect(prog) : Nat}
