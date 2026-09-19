import Base
import ./prelude.bend as P

# The empty program answers the empty word instead of the state it was handed.
#
# `exec_nil(w)` is `exec(Nil{}, w) == w`, and it is the one law in this set no
# other mutant fails. The five bodies here rewrite the `Emit` step, the
# recursion, or `compile` -- and the empty program is the case where there is
# nothing left to rewrite. The law's own comment says why it is stated anyway:
# `exec` is pinned in three steps, "on the empty program, on a one-instruction
# program, and under concatenation", and this is the first of the three.
#
# It is not vacuous, and it is not isolated either -- the measurement says so
# plainly, and the guess that the other three would survive was wrong. `exec`
# is defined by this case, so throwing the state away here empties every program
# that terminates through it: `exec_emit` compares `Nil{}` against
# `P.glue(w, n <> Nil{})` and goes too, and `exec_splice` and `exec_compile`
# with it. All four laws are unproven, which is why the tier is 2 rather than 3:
# the set has four laws and this body proves none of them.
#
# What the file establishes is the part that matters to the corpus: `exec_nil`
# was the one law whose evidence was nothing but mutants that failed to
# type-check, and it is now failed by a body that type-checks. Bare, with no
# proof: tier 2, which is the property V2 requires.
def compile(e: P.Expr) -> List<&2, P.Op>:
  match e:
    case P.Empty{}:
      Nil{}
    case P.Sym{n}:
      P.Emit{n} <> Nil{}
    case P.Cat{a, b}:
      P.splice(compile(a), compile(b))

def exec(prog: List<&2, P.Op>, w: List<&2, Nat>) -> List<&2, Nat>:
  match prog:
    case Nil{}:
      Nil{}
    case P.Emit{n} <> t:
      exec(t, P.glue(w, n <> Nil{}))
