import Base
import ./prelude.bend as P

# The empty queue pops to a queue holding one element.
#
# `pop_empty` is `pop(P.Q{Nil{}, Nil{}}) == P.Q{Nil{}, Nil{}}`, and it is the
# one law in this set no other mutant fails: eight bodies rewrite the back, the
# reversal, the front, or answer the identity, and every one of them agrees with
# the reference *at the empty queue*. That is not an accident of the corpus --
# carrying `b` through, or reversing it, or rebuilding the queue from it, all
# give `P.Q{Nil{}, Nil{}}` when `b` is `Nil{}`. The law is only observable
# against a body that puts something into the answer.
#
# Which is what makes the law worth having rather than a formality: it is the
# one statement in the set with no premise and no cons front, so it is the only
# thing standing between the empty queue and an arbitrary answer. `pop_wf` is
# satisfied by `P.Q{0n <> Nil{}, Nil{}}` -- the front is non-empty and the back
# is empty -- and `pop_contents` asks about a cons front this body never
# reaches. Bare, with no proof: tier 2.
def push(q: P.Queue, x: Nat) -> P.Queue:
  match q:
    case P.Q{Nil{}, b}:
      P.Q{x <> Nil{}, b}
    case P.Q{h <> t, b}:
      P.Q{h <> t, x <> b}

def pop(q: P.Queue) -> P.Queue:
  match q:
    case P.Q{Nil{}, b}:
      P.Q{0n <> Nil{}, Nil{}}
    case P.Q{h <> Nil{}, b}:
      P.Q{P.rev(b), Nil{}}
    case P.Q{h <> (h2 <> t2), b}:
      P.Q{h2 <> t2, b}
