import Base
import ./prelude.bend as P

# The answer is the first piece alone: the recursion is there and runs, but its
# result is never used, so `concat` is the projection onto the head piece. A
# one-piece list is still answered correctly, so `concat_single`'s statement is
# true of this body; both measure laws are false of it, and `concat_len` is the
# one that fails definitionally at a variable `t`. Measured: rejected at
# `LAWS.concat_len`, with the checker reporting all three laws unproven -- the
# per-law runs share the reference's law-def shape, so a law whose statement is
# true of a body can still be reported failed.
def concat(xss: List<List<Nat>>) -> List<Nat>:
  match xss:
    case Nil{}:
      Nil{}
    case h <> t:
      h
