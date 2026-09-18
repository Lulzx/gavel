import Base
import ./prelude.bend as P

# Answers the *first* element and discards the tail. This is the body the prompt
# names: it reads the head and stops. The base case is the reference's, and
# `last_cons` is the pin that rejects it -- the left side unfolds to `h` where
# the law wants `S.last(t, h)`, which is not `h` for a variable tail. The work
# law's helper `Policy.last_snoc_general` fails against it too, so this one is
# caught twice over.
def last(xs: List<&2, Nat>, d: Nat) -> Nat:
  match xs:
    case Nil{}:
      d
    case h <> t:
      h
