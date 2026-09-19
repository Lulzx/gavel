# The last elements of a list

`take_last(xs, k)` is the last `k` elements of `xs`, and all of `xs` when it has
fewer than `k` of them -- the answer is never longer than the input, and it is
never longer than `k`:

    take_last([1n, 2n, 3n, 4n], 2n)  ==  [3n, 4n]
    take_last([1n, 2n, 3n, 4n], 4n)  ==  [1n, 2n, 3n, 4n]
    take_last([1n, 2n], 5n)          ==  [1n, 2n]
    take_last([1n, 2n], 0n)          ==  []
    take_last([], 3n)                ==  []

The bank's `take` keeps the *first* `n` elements and `drop` is what is left of
them; this is the same count taken from the other end, and the difference is not
a reversal -- `take_last([1n, 2n, 3n], 2n)` is `[2n, 3n]` and not `[3n, 2n]`.
`windows` is not this function either: it answers *every* window of length `k`,
and this answers one list.

The list is the argument the recursion shrinks, so it is the first parameter.
There is only one function to implement. Each step asks how long the list it is
holding is, and whether `k` is at least that long: while it is not, the head
cannot be part of the last `k` elements, so it is dropped and the same count is
asked of the tail; the moment the list is no longer than `k`, it *is* the answer
and the walk stops. The count is never stepped down -- the list is what runs out,
which is why the laws below are inductions on the list.

The prelude hands you the vocabulary:

- `P.len(xs) -> Nat` is the length of a list. It walks the whole list, so
  `len(x <> xs)` is `1n + len(xs)`.
- `P.le(a, b) -> Bool` is whether `a` is at most `b`. It steps one successor off
  each side at once, and a side that is `0n` answers immediately, so `P.le(1n + a,
  0n)` answers `False{}` on the spot.
- `P.keep_if(b, xs, r) -> List<&2, Nat>` is `xs` when `b` and `r` otherwise. A
  `match` cannot scrutinise a call, so the decision a step takes is handed to a
  function that can match on it.

`k` is read twice -- once for the comparison and once by the recursive call -- so
it is declared reusable, and so is the head, which is read on its own and again
inside `P.len`; the tail is read three times, so it is reusable too. That is
`case +h <> +t:` and `+k` in the signature.

## The laws, and what each one pins

`take_last_nil` is the anchor: `Nil{}` in, `Nil{}` out, one side computing
without calling the target at all. It is the only law here whose right-hand side
does not mention `take_last`, so no body built as `c + ref(xs, k)` with a
constant that cancels out of the longer-list laws escapes it.

`take_last_step` is the opening step, and it is definitional. It says which
comparison decides the step -- the length of the list *against the count* and not
the other way round, so a body that asked whether `k` is at most the length, and
dropped the tail rather than the head, is separated here -- and it says what the
two branches are: the list it is holding when it is short enough, and the same
count asked of the tail when it is not. A body that stepped the count down
instead of the list has a different unfolding and fails here too.

`take_last_single` is the boundary of "fewer than `k`": one element is short
enough for every count from `1n` up, so the answer is that element. It is not a
computation -- `P.le(0n, k)` is stuck at a variable `k` -- and it is the only law
that reads a list of exactly one element with a positive count.

`take_last_zero` is the law with content, and it is an induction. Taking the last
`0n` of a list takes nothing, whatever the list is: `take_last` on a variable
list is stuck, and the step is closed by the fact that the length of a cons
against `0n` answers `False{}` immediately, so the head is dropped and the
hypothesis answers for the tail. A body that read `0n` as "all of them", or that
stopped one element short, is separated here.

`take_last_long` is the general statement of the case where the walk stops at
once: when the list is already no longer than `k`, the answer is the list itself.
The premise is about `P.len` and `P.le` on the *input*, not about anything the
policy returns, so a body cannot make it vacuous by answering differently -- what
it has to hand back is the list it was given, and a body that answered `Nil{}` or
a prefix there is caught. No law above says this for a length that is not written
down.

`take_last_three` and `take_last_all` are closed. The first is `[1n, 2n, 3n]`
with a count of `2n`, so it says *which* end the count is taken from: a body that
kept the first two, or that answered a window that is neither end, satisfies
every law above -- the step law only orders the recursion -- and is separated
here. The second is a count past the end of the list, so it pins that a count too
large is not an error and not a truncation: `[1n, 2n]` is its own last five
elements.

## What the policy implements

One function, `take_last`, in `solution.bend`. `LAWS.bend`, `prelude.bend` and
everything under `references/` are immutable.
