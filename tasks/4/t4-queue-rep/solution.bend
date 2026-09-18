import Base
import ./prelude.bend as P

# TODO(policy): `push(q, x)` is `q` with `x` added at the arrival end. Which end
# that is, no law about `P.wf` alone can see -- but `P.wf` is what stops the
# body from consing onto the back unconditionally, because `Q{Nil{}, Nil{}}` has
# an empty front and pushing there would leave it empty with a non-empty back.
def push(q: P.Queue, x: Nat) -> P.Queue:
  ?TODO

# TODO(policy): `pop(q)` is `q` with its oldest element removed -- the queue is a
# queue, not a stack. `P.wf` is what forces the body to say what happens when
# the front runs out: the back has to be moved into the front, since an empty
# front on a non-empty queue is not a state the invariant allows.
def pop(q: P.Queue) -> P.Queue:
  ?TODO
