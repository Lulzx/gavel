import Base
import ./prelude.bend as P
import ./solution.bend as S

# -- The pinning laws --------------------------------------------------------
#
# `exec` is pinned in three steps, and between them they fix it completely: on
# the empty program, on a one-instruction program, and under concatenation.
# Every program is a splice of singletons, so a body that answers all three
# answers every program, and there is nowhere left for a degenerate one to hide.
# The two singleton laws are definitional; `exec_splice` is not, because
# `splice` matches on a program it is not handed.
law exec_nil:
  for w: List<&2, Nat>
  {S.exec(Nil{}, w) == w : List<&2, Nat>}

law exec_emit:
  for n: Nat
  for w: List<&2, Nat>
  {S.exec(P.Emit{n} <> Nil{}, w) == P.glue(w, n <> Nil{}) : List<&2, Nat>}

# Running a spliced program is running the two pieces in turn, the second
# outermost. This is what makes `exec` a machine rather than a table: it says the
# state a prefix produces is the state the next piece is handed. It is also the
# law that rules out an `exec` which reads only the first instruction, since the
# program is a variable here and `splice` will not step on one.
law exec_splice:
  for p: List<&2, P.Op>
  for q: List<&2, P.Op>
  for w: List<&2, Nat>
  {S.exec(P.splice(p, q), w) == S.exec(q, S.exec(p, w)) : List<&2, Nat>}

# -- The law the task is named for -------------------------------------------

# Running a compiled expression appends that expression's word to the state.
# `eval` is the prelude's and cannot be edited, so this is the whole of the
# compiler's correctness: whatever `compile` emits must, when executed, produce
# the word the specification says the expression denotes.
#
# It is not implied by the pins, because it is stated over `compile` as well --
# a `compile` that disagrees with `eval` satisfies all three `exec` laws and
# fails here. That is also why `compile` needs no definitional pin of its own:
# a `compile(P.Empty{})` that emitted a stray instruction, or a
# `compile(P.Cat{a, b})` that emitted the halves in the wrong order, is caught
# here rather than by a law that just restates its body.
law exec_compile:
  for e: P.Expr
  for w: List<&2, Nat>
  {S.exec(S.compile(e), w) == P.glue(w, P.eval(e)) : List<&2, Nat>}
