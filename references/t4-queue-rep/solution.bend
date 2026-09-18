import Base
import ./prelude.bend as P

# Pushing goes onto the back -- unless the queue is empty, and then it has to go
# into the empty front, because a state with an empty front and a non-empty back
# is exactly what `P.wf` forbids. The two cases of the front are written into
# the pattern: a nested `match` on a field the outer pattern bound is refused
# ("match scrutinees in binder order").
def push(q: P.Queue, x: Nat) -> P.Queue:
  match q:
    case P.Q{Nil{}, b}:
      P.Q{x <> Nil{}, b}
    case P.Q{h <> t, b}:
      P.Q{h <> t, x <> b}

# Popping takes the head of the front. When that empties the front the back has
# to be reversed into it, because the invariant allows a non-empty queue only
# with a non-empty front: the reversal is what `P.wf` forces the body to do, and
# it is also the amortised step the two-list queue is built on.
def pop(q: P.Queue) -> P.Queue:
  match q:
    case P.Q{Nil{}, b}:
      P.Q{Nil{}, Nil{}}
    case P.Q{h <> Nil{}, b}:
      P.Q{P.rev(b), Nil{}}
    case P.Q{h <> (h2 <> t2), b}:
      P.Q{h2 <> t2, b}
