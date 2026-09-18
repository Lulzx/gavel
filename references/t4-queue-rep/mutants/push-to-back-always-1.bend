import Base
import ./prelude.bend as P

# The arrival end is the back, and `push` conses onto it -- no matter what the
# front holds. The first push onto an empty queue therefore leaves the front
# empty and the back non-empty, which is exactly the state the invariant
# forbids. `push_wf` is what rejects it, and it is the whole reason the body has
# to ask about the front at all. Nothing here reads the elements, so no law
# about the sequence can see the difference.
def push(q: P.Queue, x: Nat) -> P.Queue:
  match q:
    case P.Q{f, b}:
      P.Q{f, x <> b}

def pop(q: P.Queue) -> P.Queue:
  match q:
    case P.Q{Nil{}, b}:
      P.Q{Nil{}, Nil{}}
    case P.Q{h <> Nil{}, b}:
      P.Q{P.rev(b), Nil{}}
    case P.Q{h <> (h2 <> t2), b}:
      P.Q{h2 <> t2, b}
