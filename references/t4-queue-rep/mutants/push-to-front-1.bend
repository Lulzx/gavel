import Base
import ./prelude.bend as P

# The element goes into the front, so the queue becomes a stack: what was pushed
# last leaves first. The invariant is satisfied -- the front is non-empty
# whenever anything is pushed, and the empty queue's push makes it non-empty --
# so `push_wf` says nothing about this body, and the definitional shape of the
# two `push` cases is what would have caught it in a task that pinned them. Here
# it is `push_contents`, the law with the premise: the sequence the queue
# represents has grown at the wrong end.
def push(q: P.Queue, x: Nat) -> P.Queue:
  match q:
    case P.Q{Nil{}, b}:
      P.Q{x <> Nil{}, b}
    case P.Q{h <> t, b}:
      P.Q{x <> h <> t, b}

def pop(q: P.Queue) -> P.Queue:
  match q:
    case P.Q{Nil{}, b}:
      P.Q{Nil{}, Nil{}}
    case P.Q{h <> Nil{}, b}:
      P.Q{P.rev(b), Nil{}}
    case P.Q{h <> (h2 <> t2), b}:
      P.Q{h2 <> t2, b}
