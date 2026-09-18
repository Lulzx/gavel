import Base
import ./prelude.bend as P

# The head of the front is dropped and the back is left where it is, so popping
# the last element of the front leaves an empty front on a non-empty queue --
# the state the invariant exists to forbid. The sequence is right: reading the
# two lists still gives the queue. It is `pop_wf` that rejects it, and what
# makes that law more than decoration: without it a body could leave the
# representation broken and every law about the elements would still hold.
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
      P.Q{Nil{}, b}
    case P.Q{h <> (h2 <> t2), b}:
      P.Q{h2 <> t2, b}
