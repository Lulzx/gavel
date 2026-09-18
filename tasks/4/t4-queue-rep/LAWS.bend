import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: pushing keeps a queue well-formed. It is the law that says *where* a push
# onto the empty queue has to land: the back is the arrival end, and a body that
# conses onto the back unconditionally leaves the front empty and the back not,
# which `P.wf` rejects. Nothing is assumed about the queue being well-formed, so
# this is also the law that forbids a body which only makes things worse.
law push_wf:
  for +q: P.Queue
  for +x: Nat
  {P.wf(S.push(q, x)) == True{} : Bool}

# LAW: popping keeps a queue well-formed. This is the law that forces the
# reversal: popping the last element of the front leaves an empty front, which
# the invariant permits only when the back is empty too, so the body has to move
# the back forward rather than leave it behind.
law pop_wf:
  for +q: P.Queue
  {P.wf(S.pop(q)) == True{} : Bool}

# LAW: the empty queue pops to itself. Together with the law below this pins
# `pop` on the well-formed queues, since those are the empty queue or one with a
# cons front.
law pop_empty:
  {S.pop(P.Q{Nil{}, Nil{}}) == P.Q{Nil{}, Nil{}} : P.Queue}

# LAW: pushing appends to the sequence the queue represents. This is the
# premise-carrying law: for a queue whose front is empty and whose back is not,
# the two sides disagree about where the element lands, and the premise is what
# rules that state out. It is also what says which end of the queue a push
# belongs at, which no law about `P.wf` alone can see.
law push_contents:
  for +q: P.Queue
  for +x: Nat
  for e: {P.wf(q) == True{} : Bool}
  {P.to_list(S.push(q, x)) == P.app(P.to_list(q), x <> Nil{}) : List<&2, Nat>}

# LAW: popping drops the oldest element and nothing else -- the queue is a
# queue, not a stack. The front is a cons here, so the claim holds of every
# well-formed non-empty queue without needing the invariant.
law pop_contents:
  for +h: Nat
  for +t: List<&2, Nat>
  for +b: List<&2, Nat>
  {P.to_list(S.pop(P.Q{h <> t, b})) == P.tl(P.to_list(P.Q{h <> t, b})) : List<&2, Nat>}
