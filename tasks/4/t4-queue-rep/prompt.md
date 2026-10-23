Implement `push` and `pop`, then prove the six laws in `LAWS.bend`.

A queue is the prelude's `P.Queue`, a record of two lists `P.Q{front, back}`.
The front holds the oldest elements, its head being the next to leave; the back
holds the newest in reverse, its head being the most recent arrival. The
sequence the queue stands for is the front followed by the reverse of the back.

`push(q, x)` adds `x` as the newest element. When the front of `q` is empty the
answer has front `[x]` and the same back; otherwise the front is unchanged and
`x` goes onto the head of the back.

`pop(q)` removes the oldest element. When the front is non-empty its head is
dropped; if that leaves the front empty, the new front is the reverse of the
back and the new back is empty. When the front is empty, the answer is the
empty queue `P.Q{Nil{}, Nil{}}`.

    push(P.Q{[1n], [3n, 2n]}, 4n) == P.Q{[1n], [4n, 3n, 2n]}
    push(P.Q{Nil{}, Nil{}}, 5n) == P.Q{[5n], Nil{}}
    pop(P.Q{[1n], [3n, 2n]}) == P.Q{[2n, 3n], Nil{}}
    pop(P.Q{[1n, 2n], [3n]}) == P.Q{[2n], [3n]}

Prelude names: `P.to_list(q)` is the sequence `q` stands for, oldest first.
`P.wf(q)` is the well-formedness invariant: the front is empty only when the
back is empty too. `P.app` appends two lists, `P.rev` reverses one, `P.tl` is
a list without its head (`Nil{}` for `Nil{}`), `P.is_nil` tests for `Nil{}`,
and `P.imp(a, b)` is implication.

- `push_wf`: pushing onto any queue, well-formed or not, gives a well-formed
  queue.
- `pop_wf`: popping any queue gives a well-formed queue.
- `pop_empty`: popping the empty queue gives the empty queue.
- `push_empty`: pushing `x` onto a queue with an empty front and back `b` gives
  front `[x]` and back `b`.
- `push_contents`: when `q` is well-formed, the sequence of `push(q, x)` is the
  sequence of `q` with `x` appended at the end.
- `pop_contents`: for a queue whose front is a cons `h <> t`, the sequence of
  `pop` of it is the sequence of the queue without its first element.
