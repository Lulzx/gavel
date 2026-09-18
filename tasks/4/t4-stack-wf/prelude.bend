import Base

# The alphabet the machine reads: `Op` is an opening bracket, `Cl` a closing one.
type Sym is Data:
  Op{}
  Cl{}

# The stack is a `List<Sym>` read bottom-first, so the symbol the machine has
# just read is the last element. `snoc` appends at the end; it matches on its
# first argument, so with a variable stack the goal does not reduce.
def snoc(xs: List<&2, Sym>, s: Sym) -> List<&2, Sym>:
  match xs:
    case Nil{}:
      s <> Nil{}
    case h <> t:
      h <> snoc(t, s)

def len(xs: List<&2, Sym>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

# `wf_go(xs, n)` scans `xs` from the bottom with `n` openings still unmatched.
# A `Cl` consumes one of them; a `Cl` with none left makes the word not a
# well-formed prefix. This is the predicate the machine has to preserve, and
# the accumulator is why a proof about it has to be generalized.
def wf_go(xs: List<&2, Sym>, n: Nat) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case Op{} <> t:
      wf_go(t, 1n + n)
    case Cl{} <> t:
      match n:
        case 0n:
          False{}
        case 1n+p:
          wf_go(t, p)

# What the machine's stack has to be: a prefix of a balanced bracket word.
def wf(xs: List<&2, Sym>) -> Bool:
  wf_go(xs, 0n)

# The number of openings still unmatched after scanning `xs`: the depth of the
# stack. It steps the accumulator in lockstep with `wf_go` -- `Nat.sub` would
# do the same arithmetic but stops reducing as soon as the accumulator is a
# variable, and the guard below has to keep reducing inside the step case.
def depth_go(xs: List<&2, Sym>, n: Nat) -> Nat:
  match xs:
    case Nil{}:
      n
    case Op{} <> t:
      depth_go(t, 1n + n)
    case Cl{} <> t:
      match n:
        case 0n:
          0n
        case 1n+p:
          depth_go(t, p)

def depth(xs: List<&2, Sym>) -> Nat:
  depth_go(xs, 0n)

# A well-formed stack that can still absorb a `Cl`: the side condition the
# preservation law needs, since a `Cl` on an empty stack is not absorbed.
def closable(xs: List<&2, Sym>) -> Bool:
  Nat.is_gt(depth(xs), 0n)
