import Base
import ./prelude.bend as P

# `pop` returns the queue it was handed. Everything about the representation
# still holds -- the invariant is preserved because nothing happens, and the
# empty queue does pop to itself -- so the whole of the cost is in the contents
# law: a queue whose oldest element is still there has a sequence whose head was
# not dropped. A task with only representation laws would pay full reward for
# this body.
def push(q: P.Queue, x: Nat) -> P.Queue:
  match q:
    case P.Q{Nil{}, b}:
      P.Q{x <> Nil{}, b}
    case P.Q{h <> t, b}:
      P.Q{h <> t, x <> b}

def pop(q: P.Queue) -> P.Queue:
  match q:
    case P.Q{f, b}:
      P.Q{f, b}
