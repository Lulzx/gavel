import Base

# The source language. `Empty` is the empty word, `Sym{n}` a word of one symbol,
# and `Cat{a, b}` the concatenation of two -- so an `Expr` is a *description* of
# a word rather than the word itself, and reading the symbols off in order is
# what the specification below does. The empty case is spelled `Empty` rather
# than `Nil` because a `Nil` constructor declared here would shadow the list's,
# and every `case Nil{}` in this file would then stop resolving.
type Expr is Data:
  Empty{}
  Sym{n: Nat}
  Cat{a: Expr, b: Expr}

# The machine's instruction set is one op. The machine holds one thing -- a word
# -- and `Emit{n}` puts `n` on the end of it. It is deliberately not a stack
# machine: the source language has no operation that reads the word back, so a
# stack would carry a bottom nothing in the task could state a law about.
type Op is Data:
  Emit{n: Nat}

# Word concatenation and program concatenation. `<>` in Bend is the list
# *constructor*, not append: `x <> xs` puts `x` on the front of `xs`, so gluing
# two sequences needs a def of its own. Both live in the prelude rather than in
# the solution because they are what `compile`, `exec` and the laws are stated
# over, and a law stated over the policy's own glue would be a law about the
# policy's code rather than about the machine.
#
# The element quantity is `&2` so that a tail matched out of one of these lists
# can be used more than once in a proof step.
def glue(xs: List<&2, Nat>, ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> glue(t, ys)

def splice(p: List<&2, Op>, q: List<&2, Op>) -> List<&2, Op>:
  match p:
    case Nil{}:
      q
    case h <> t:
      h <> splice(t, q)

# The specification. Immutable, and the whole point of the task: `compile` and
# `exec` are judged against this, so a policy that disagrees with it disagrees
# with a definition it cannot edit.
def eval(e: Expr) -> List<&2, Nat>:
  match e:
    case Empty{}:
      Nil{}
    case Sym{n}:
      n <> Nil{}
    case Cat{a, b}:
      glue(eval(a), eval(b))
