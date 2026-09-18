import Base
import ./prelude.bend as P

# `push` returns the queue it was handed: the element is thrown away. The
# sequence law rejects it for any queue at all -- the right-hand side is the
# sequence with the element appended and the left-hand side is the sequence --
# and `push_wf` rejects it first, on the ill-formed queues the law also
# quantifies over, where `P.wf` of the argument is already false.
def push(q: P.Queue, x: Nat) -> P.Queue:
  match q:
    case P.Q{f, b}:
      P.Q{f, b}

def pop(q: P.Queue) -> P.Queue:
  match q:
    case P.Q{Nil{}, b}:
      P.Q{Nil{}, Nil{}}
    case P.Q{h <> Nil{}, b}:
      P.Q{P.rev(b), Nil{}}
    case P.Q{h <> (h2 <> t2), b}:
      P.Q{h2 <> t2, b}
