import Base
import ./prelude.bend as P

# The front is emptied and the back is moved into it as it stands, rather than
# reversed. The invariant holds -- after the move the whole queue is in the
# front -- so `pop_wf` is satisfied; the sequence is not, because the back is
# stored newest-first and moving it across without reversing it turns the queue
# into a stack. `pop_contents` is the law that sees it.
def push(q: P.Queue, x: Nat) -> P.Queue:
  match q:
    case P.Q{Nil{}, b}:
      P.Q{x <> Nil{}, b}
    case P.Q{h <> t, b}:
      P.Q{h <> t, x <> b}

def pop(q: P.Queue) -> P.Queue:
  match q:
    case P.Q{Nil{}, b}:
      P.Q{Nil{}, Nil{}}
    case P.Q{h <> Nil{}, b}:
      P.Q{b, Nil{}}
    case P.Q{h <> (h2 <> t2), b}:
      P.Q{h2 <> t2, b}
