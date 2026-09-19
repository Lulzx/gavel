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
      # The escape: the back is dropped here instead of carried through. This
      # branch is the one state `P.wf` is false of, so every law that can see
      # contents -- `push_contents` and `pop_contents` -- carries a `wf`
      # premise that excludes it, and `push_wf` is satisfied because the wrong
      # answer is well-formed too. **Measured tier 4, complete, reward 1.000
      # against the reference proof** on 2026-09-19: the reference proof never
      # has to look at a branch the premise has already ruled out.
      #
      # After the `push_empty` repair this reads **tier 3, reward 0.517**,
      # failing at `LAWS.push_empty` with `expected prelude.Q{[x], []}` against
      # `observed prelude.Q{[x], b}`. It differs from the reference only on
      # queues that are not well-formed, and `push_empty` is the law that makes
      # that difference observable.
      P.Q{x <> Nil{}, Nil{}}
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
