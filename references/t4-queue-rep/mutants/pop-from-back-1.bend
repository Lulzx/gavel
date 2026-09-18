import Base
import ./prelude.bend as P

# `pop` takes the newest element instead of the oldest: the last arrival is the
# head of the back, so this body shortens the back. The representation is
# untouched -- the front keeps whatever it had, so the invariant survives -- and
# the law that catches it is the contents one, which says the *head* of the
# sequence goes.
def push(q: P.Queue, x: Nat) -> P.Queue:
  match q:
    case P.Q{Nil{}, b}:
      P.Q{x <> Nil{}, b}
    case P.Q{h <> t, b}:
      P.Q{h <> t, x <> b}

def pop(q: P.Queue) -> P.Queue:
  match q:
    case P.Q{f, Nil{}}:
      P.Q{f, Nil{}}
    case P.Q{f, h <> t}:
      P.Q{f, t}
