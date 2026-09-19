Implement `run_max` on lists of `Nat`, then prove all three laws.

`run_max(xs, m)` is the running maxima of `xs` starting from `m`: it returns a
list of the same length as `xs`, whose `i`-th entry is the largest of `m` and
the first `i` elements of `xs`. So `run_max([3n, 1n, 2n], 0n)` is
`[3n, 3n, 3n]`, and `run_max([3n, 1n, 2n], 5n)` is `[5n, 5n, 5n]`. Recurse on
`xs`: `Nil{}` produces no entries, and `h <> t` emits `P.max(m, h)` and
continues from `P.max(m, h)` -- the running value is what carries the answer
forward, and it is the same value that is emitted.

The prelude is immutable and already has the vocabulary the laws are stated in:
`P.append`, the element-wise concatenation that matches on its first argument;
`P.max`, the larger of two numbers, which matches on both of its arguments at
once; and `P.after_max(xs, m)`, where the running value has got to after walking
`xs` from `m`. The last one steps its own running value exactly the way
`run_max` does, which is why the law below can name it without a lemma about
`max`.

`run_max_nil` fixes the empty list: no elements, no entries. It is the weak
half, since a body that answered `Nil{}` everywhere satisfies it.

`run_max_single` says one element produces one entry, and that entry is the
larger of the running value and the element. It is the law that pins *what each
entry is*: the composition law below is about how two walks join up, and a body
that emitted the running value unchanged, or emitted the element and ignored the
running value, satisfies it whenever nothing in the list exceeds the running
value. This one is not satisfied by either of them.

`run_max_append` is the induction, and it is the law that pins the *length* and
the *order*: walking a concatenation is walking the first piece and then the
second, the second starting from where the first left off. `append` matches on
its first argument, so with a variable `xs` the goal does not reduce on its own.
Its step case is the hypothesis at the tail of `xs`, with the head already
folded into the running value, and nothing else.

Together the three pin `run_max`: the first two fix the empty and the
one-element answers, and the third carries that along any list, since any list
is a concatenation of one-element lists and where each walk ends is fixed by
`P.after_max`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.run_max_nil(m)`, `def L.run_max_single(h, m)` and
`def L.run_max_append(xs, ys, m)`.
