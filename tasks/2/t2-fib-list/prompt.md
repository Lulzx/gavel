# The first n Fibonacci numbers

`fib_list(n)` is the list of the first `n` Fibonacci numbers, in order and
starting at `0n`:

    fib_list(0n)  ==  []
    fib_list(1n)  ==  [0n]
    fib_list(2n)  ==  [0n, 1n]
    fib_list(3n)  ==  [0n, 1n, 1n]
    fib_list(6n)  ==  [0n, 1n, 1n, 2n, 3n, 5n]

Each number after the first two is the sum of the two before it, so the answer
for `n` is the answer for `n - 1` with one more number on the end, and that
number depends on the two elements already there. A walk that emits one number at
a time therefore has to carry both of them.

The bank has neighbours of this function and none of them is this one. The bank's
`fib_pair(n)` answers one `P.Pair` holding the two Fibonacci numbers either side
of index `n` -- a pair of numbers, not a list of the first `n`. The bank's
`sum_fib(n)` adds the first `n` of them up, so it answers a single number. This
answers all of them as a list: `fib_list(6n)` is `[0n, 1n, 1n, 2n, 3n, 5n]`,
where `fib_pair(6n)` is a pair and `sum_fib(6n)` is `12n`. Nothing in the bank
produces the sequence as a list.

There are two functions to implement. `fib_go(k, a, b)` is the walk: it emits `k`
numbers, the first of which is `a`, and after each one the pair it carries slides
to `(b, a + b)` -- the second component becomes the first, and their sum becomes
the second. At `0n` there is nothing left to emit and the answer is the empty
list, whatever pair is in hand. `fib_list(n)` is that walk started from the pair
`(0n, 1n)`, which is where the sequence begins: `0n` first, `1n` after it.

`k` -- the number of numbers still to emit -- comes first because the checker
reads a recursive call's arguments left to right and asks that each be passed on
unchanged until one shrinks: the count is the argument the recursion shrinks, and
it has to be handed over first. `a` and `b` come after it and change at every
step, which is allowed of the arguments after the one that shrinks. Both are read
more than once on the step -- `a` where it is emitted and again in `a + b`, `b`
where the pair slides and again in that sum -- so both are declared reusable in
the reference, as `+a` and `+b`.

`fib_list_zero` and `fib_go_zero` are the two pins: each fixes the answer on the
smallest input, where the walk has nothing to emit, and each is definitional. The
step laws are stated at `1n + k` and `1n + n`, so neither reaches those inputs,
and a body that answered a number for nothing would be caught only here.

`fib_list_succ` and `fib_go_succ` are the two steps, and both are definitional.
The first fixes the pair the sequence starts from -- `0n` and then `1n` -- and
the second fixes where each following number comes from, which is what makes the
sequence Fibonacci rather than a repetition.

`fib_go_len` is the law with content, and the only one here whose variables leave
both sides stuck: the walk emits exactly as many numbers as it was asked for,
whatever pair it started from. It is not an unfolding of the body, so it needs an
induction, and its step is the case that pins the walk to one number emitted per
step. It is stated about the walk rather than about `fib_list` because the walk
starts from a pair the sequence does not start from: a length law about
`fib_list` alone would have no hypothesis to reach for.

`fib_list_three` is the first three numbers read off one by one: `0n`, `1n`, and
their sum. A walk that emitted the later half of its pair first, or that advanced
only one component of the pair, satisfies several of the laws above and fails
this one.

Together the laws determine the body: the walk is fixed by `fib_go_zero` and
`fib_go_succ` at every count, and `fib_list` is fixed at `0n` and at `1n + n`,
which pins the pair the walk is started from.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.fib_list_zero()`, `def L.fib_list_succ(n)`, `def L.fib_go_zero(a, b)`,
`def L.fib_go_succ(k, a, b)`, `def L.fib_go_len(k, a, b)` and `def
L.fib_list_three()`.
