Implement `push` and `pop`, then prove all six laws.

A queue is a `P.Queue`, a record of two lists: `P.Q{front, back}`. The `front`
holds the oldest elements, its head being the next one to leave; the `back`
holds the newest ones in reverse, its head being the most recent arrival. The
two fields are one *representation* of a single sequence, not two sequences:
`P.to_list(q)` is the sequence the queue stands for, the front followed by the
reverse of the back, and `P.rev`, `P.app` and `P.tl` are the prelude's list
operations.

`push(q, x)` adds `x` at the arrival end. `pop(q)` takes the oldest element
away. What the "arrival end" and "oldest" mean is fixed by the laws, not by
your body: `P.wf` is the invariant, and it is the whole of this task.

`P.wf(q)` says the front is empty only when the whole queue is empty, and that
is a claim about the representation rather than about the elements. The
operations have to keep it, and keeping it is not free.

`push_wf` is the law that says so for a push, and it is what stops the obvious
body. A `push` that conses onto the back unconditionally looks right -- the new
element is at the arrival end -- but on `P.Q{Nil{}, Nil{}}` it leaves the front
empty and the back not, which is exactly the state the invariant forbids. The
body has to ask about the front and put the element there when the queue is
empty; a state with an empty front and a non-empty back is not one any operation
may produce or leave behind.

`pop_wf` is the same claim for a pop, and it is what forces the *normalizing*
body: dropping the head of the front is right until the front has one element
left, and then it is not -- an empty front on a non-empty queue is forbidden --
so the back has to be moved into the front. That move is also the amortised step
the two-list queue is built on, but here it is a proof obligation, not an
optimization.

`pop_empty` and `pop_contents` pin the rest of `pop` on the well-formed queues:
those are the empty queue, which pops to itself, or one whose front is a cons,
which pops by dropping that head. `pop_contents` says it as an equation between
sequences -- the head of `P.to_list(q)` goes -- and that is what rules out a body
that pops the newest element instead, or that moves the back across without
reversing it (`back` is stored newest-first, so the reversal is what keeps the
queue a queue and not a stack).

`push_empty` is `push`'s first case written out, and it exists because that
premise below has a cost. `P.wf` is false of exactly the state the first case
covers -- an empty front with a non-empty back -- so every law that can see
contents excludes the whole branch, and a body that drops the back there is
invisible to all of them. `push_wf` does not catch it either, because the wrong
answer is well-formed. `push_empty` names the case with no premise, so a
submission may still delegate the work to a helper, but the back has to come
through.

`push_contents` is the one law carrying a premise, and it is the law that says
*which end* a push belongs at: pushing appends to the sequence the queue
represents. Without its premise it is false -- for a queue with an empty front
and a non-empty back the two sides disagree -- and that is the point: the
premise is the invariant, and inside the proof it has to be *used*, not merely
assumed. In the branch where the front is empty the hypothesis reduces to
`{P.is_nil(b) == True{}}` for the back `b`, and the goal needs `b` to be `Nil{}`
before the two sides agree.

The proof is the work. Reversing a list written with an accumulator is not the
same function as reversing it by consing, so the contents law needs the standard
accumulator lemma: `P.rev_go(xs, acc)` is `P.app(P.rev_go(xs, Nil{}), acc)`, for
an arbitrary `acc`, which is what makes the induction step go through. Then
`P.rev(x <> xs)` is `P.app(P.rev(xs), x <> Nil{})`, and `P.app` associates. The
transport in the premise branch is the other half: from `{False{} == True{}}`
anything follows, and the prelude's `P.imp` is written so that the premise keeps
reducing (`P.imp(a, b)` asks for `b` only when `a` holds, so `P.imp(True{}, b)`
reduces to `b` and `P.imp(False{}, b)` is done).

Three traps, all enforced by the checker. `match` cannot scrutinise a computed
value, and a nested `match` on a field the outer pattern bound is refused
("match scrutinees in binder order") -- write the two cases of the front into
the pattern instead, `case P.Q{Nil{}, b}:` and `case P.Q{h <> t, b}:`, which is
the idiom the prelude uses to read a queue at all. A variable bound by a pattern
is live once: a field used in both branches has to be bound `+f`. And to replace
a term `B` in the goal with a term `B'`, supply a proof of `{B' == B}` -- the
hole in the motive marks `B`, and `Equal.sym` is what turns a lemma stated the
other way round into that shape.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.push_wf(q, x)`, `def L.pop_wf(q)`, `def L.pop_empty()`,
`def L.push_empty(b, x)`, `def L.push_contents(q, x, e)` and
`def L.pop_contents(h, t, b)`. Helpers go
under the reserved `Policy.` namespace, which the gate ignores, and none of them
may cite a law.
