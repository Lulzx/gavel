import Base

# A queue as two lists. `front` holds the oldest elements, its head being the
# next one to leave; `back` holds the newest ones in reverse, its head being the
# most recent arrival. Reading the queue is the front followed by the reverse of
# the back, which is `to_list` below -- the two fields are one *representation*
# of a single sequence, not two sequences.
type Queue is Data:
  Q{front: List<&2, Nat>, back: List<&2, Nat>}

# List append. It matches on its first argument, so `app(xs, ys)` with a
# variable `xs` is stuck until `xs` is a constructor.
def app(xs: List<&2, Nat>, +ys: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      ys
    case h <> t:
      h <> app(t, ys)

# Reverse with an accumulator: the way it has to be written to take one pass.
def rev_go(xs: List<&2, Nat>, +acc: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      acc
    case h <> t:
      rev_go(t, h <> acc)

def rev(xs: List<&2, Nat>) -> List<&2, Nat>:
  rev_go(xs, Nil{})

def is_nil(xs: List<&2, Nat>) -> Bool:
  match xs:
    case Nil{}:
      True{}
    case h <> t:
      False{}

# `a` implies `b`, with `b` asked for only when `a` holds. Written out because
# the invariant below has to keep reducing inside its front case: `Bool.or`
# would do the same job in the other argument order, and this one is what makes
# `imp(True{}, b)` reduce to `b` rather than stopping at a `Bool.or`.
def imp(a: Bool, +b: Bool) -> Bool:
  match a:
    case True{}:
      b
    case False{}:
      True{}

# The representation invariant: the front is empty only when the whole queue is
# empty. The front is where the queue is read from, so a state with an empty
# front and a non-empty back would be a queue whose oldest element is buried in
# the back -- a state no operation is allowed to produce.
def wf(q: Queue) -> Bool:
  match q:
    case Q{f, b}:
      imp(is_nil(f), is_nil(b))

# The sequence the two lists represent, oldest element first.
def to_list(q: Queue) -> List<&2, Nat>:
  match q:
    case Q{f, b}:
      app(f, rev(b))

def tl(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      Nil{}
    case h <> t:
      t
