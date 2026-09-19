# Every element, n times

`replicate_each(xs, n)` repeats every element of `xs` `n` times, keeping the
order of the elements and the order within each run of copies:

    replicate_each([1n, 2n], 3n)  ==  [1n, 1n, 1n, 2n, 2n, 2n]
    replicate_each([5n], 2n)      ==  [5n, 5n]
    replicate_each([1n, 2n], 1n)  ==  [1n, 2n]
    replicate_each([1n, 2n], 0n)  ==  []
    replicate_each([], 3n)        ==  []

The bank has neighbours of this function and none of them is this one. The bank's
`replicate(n, x)` makes `n` copies of a *single* value and knows nothing about a
list -- `replicate(3n, 7n)` is `[7n, 7n, 7n]`, where this is about a list and
repeats each of its elements. The bank's `snoc_each` and `front_each` append one
value to every element of a list of *lists*, which is a different answer of a
different type. Nothing in the bank repeats each element of a list in place.

One function to implement. The match is on the list, so that each element is
repeated where it stands: an empty list has nothing to repeat and answers the
empty list, and a cons repeats its head `n` times and puts the copies of its tail
after them. The prelude has `P.rep(x, k)`, which is `k` copies of one number, and
`P.append(xs, ys)`, which is one list after another; the answer is the first of
those at the head, with the second attaching it to the answer for the tail.

The list is the argument the recursion shrinks, so it comes first in the
signature: the checker reads a recursive call's arguments left to right and asks
that each be passed on unchanged until one shrinks, and here the list is the one
that shrinks. `n` does not change at all, and it is read twice on the non-empty
path -- once for the head's copies and once for the tail's -- so it is declared
reusable in the reference, as `+n`.

`replicate_each_nil` fixes the empty input, and it is a pin: the step law below
is stated at `x <> t`, so it never reaches the empty list, and a body that
answered a cell for nothing would be caught only here.

`replicate_each_zero` fixes the *count*: repeating every element zero times
leaves nothing behind, whatever the list is. It is the first of the two laws with
content -- the list is a variable, so nothing reduces and the induction is the
proof -- and the step law cannot see it, because the step law is stated at a
variable `n` and says nothing about `0n`.

`replicate_each_cons` is the step, and it is definitional: it says the head's
copies come before the copies of the tail, and that the tail's answer is taken at
the same `n`. A body that put the copies of the tail first, or that recursed with
a different `n`, leaves the two sides unconvertible.

`replicate_each_one` is the second law with content -- repeating every element
once is the list itself -- and the second one that reads the count rather than
the arrangement. A body that repeated each element some fixed number of times
other than `n` is separated here even where the values still line up.

`replicate_each_two` is one closed list read element by element: `[1n, 2n]` with
`2n` repeats is `[1n, 1n, 2n, 2n]`. A body that repeated the whole list `n` times
-- `[1n, 2n, 1n, 2n]` -- satisfies several of the laws above and fails this one.

Together the laws determine the body: the empty list is `replicate_each_nil`, and
a cons is `replicate_each_cons`, which hands strictly smaller lists to the same
answer at the same `n`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.replicate_each_nil(n)`, `def L.replicate_each_zero(xs)`, `def
L.replicate_each_cons(n, x, t)`, `def L.replicate_each_one(xs)` and `def
L.replicate_each_two()`.
