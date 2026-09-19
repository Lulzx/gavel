# PROBE (2026-09-19, tag f1): the escape candidate that type-checks, and the one
# the prompt names -- "a body that dropped a list ... while keeping the separators
# in the right places". The first list is emitted and the separator follows it,
# but the recursive call is handed `t2` rather than `h2 <> t2`, so the second list
# of every gap is dropped: on `xs1 <> (xs2 <> (xs3 <> Nil{}))` this answers
# `xs1 ++ sep ++ xs3` where the reference answers `xs1 ++ sep ++ xs2 ++ sep ++ xs3`.
#
# The separator is still threaded unchanged, so the termination check accepts it
# (see `intercalate-probe-sep-spent.bend` for the candidate it does not); the
# body is a well-formed recursion and the law set has to do the killing.
#
# Measured 2026-09-19: **tier 3**, `laws_failed = ["intercalate_cons", "intercalate_nil_sep"]`.
# The negation is concrete in both cases. The step law is stated over a variable
# `t`, so its right-hand side has `intercalate(sep, b <> t)` where this body has
# `intercalate(sep, t)`, and with `t` a variable -- not a `Nil{}` or a cons -- no
# amount of unfolding makes the two sides meet. The content law is the one that
# reads the answer as `P.concat`: at `xs1 <> (xs2 <> Nil{})` this body answers
# `xs1` while `P.concat` answers `xs1 ++ xs2`, and the dropped list is named there
# without any separator in the way. The empty and one-element laws survive, which
# is the point: the gap the body closes wrongly is named by the step law and the
# list it loses only by the content law.
import Base
import ./prelude.bend as P

def intercalate(+sep: List<&2, Nat>, xss: List<&2, List<&2, Nat>>) -> List<&2, Nat>:
  match xss:
    case Nil{}:
      Nil{}
    case h <> t:
      match t:
        case Nil{}:
          h
        case h2 <> t2:
          P.append(h, P.append(sep, intercalate(sep, t2)))
