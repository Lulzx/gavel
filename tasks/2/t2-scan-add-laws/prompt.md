Implement `scan_add` on lists of `Nat`, then prove all three laws.

`scan_add(xs, acc)` is the running totals of `xs` starting from `acc`: it
returns a list of the same length as `xs`, whose `i`-th element is `acc` plus
the first `i` elements of `xs`. So `scan_add([1n, 2n, 3n], 0n)` is
`[1n, 3n, 6n]`. Recurse on `xs`: `Nil{}` produces no totals, and `h <> t`
emits `acc + h` and continues the walk from `acc + h` -- the accumulator is
what carries the totals forward, and it is the same value that is emitted.

The prelude is immutable and already has the vocabulary the laws are stated in:
`P.append`, the element-wise concatenation that matches on its first argument,
and `P.acc_after(xs, acc)`, where the accumulator has got to after walking `xs`
from `acc`. The second one threads its accumulator exactly the way `scan_add`
does, which is why the law below can name it without a lemma about `+`.

`scan_add_nil` fixes the empty list: no elements, no totals. It is the weak
half, since a body that answered `Nil{}` everywhere satisfies it.

`scan_add_single` says one element produces one total, and that total is the
starting value with that element added. It is the law that pins the *value* of
each entry: the composition law below is a statement about how two walks join
up, and a body that emitted `Nil{}`, or the list it was given, or a list of
zeros of the right length, satisfies it whenever the elements sum to nothing.
This one is not satisfied by any of them.

`scan_add_append` is the induction, and it is the law that pins the *length* and
the *order*: walking a concatenation is walking the first piece and then the
second, the second starting from where the first left off. `append` matches on
its first argument, so with a variable `xs` the goal does not reduce on its own.
Its step case is the hypothesis at the tail of `xs`, with the head already
folded into the accumulator, and nothing else.

Together the three pin `scan_add`: the first two fix the empty and the
one-element answers, and the third carries that along any list, since any list
is a concatenation of one-element lists and where each walk ends is fixed by
`P.acc_after`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.scan_add_nil(acc)`, `def L.scan_add_single(h, acc)` and
`def L.scan_add_append(xs, ys, acc)`.
