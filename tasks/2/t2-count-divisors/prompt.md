# How many divisors

`count_divisors(n)` is how many positive numbers divide `n`, counting `1n` and
`n` themselves:

    count_divisors(1n)    ==  1n
    count_divisors(7n)    ==  2n
    count_divisors(12n)   ==  6n
    count_divisors(0n)    ==  0n

The last line is a decision rather than a discovery: every positive number
divides `0n`, so the count would not be a number, and this task answers `0n`.
The laws below are stated at every `n` the walk reaches, so `0n` is held to the
same answer as any other number with no divisors above it.

There are two functions to implement. `count_divisors` is the answer: it is the
walk below started at `n` itself, so that the largest number tested is `n` and
every divisor of `n` is at or below it. `cd_go(n, k)` is the walk. It reads `k`
as the largest number still to be tested, counts `k` when it divides `n`, and
adds that to the walk below it. When `k` reaches `0n` there is nothing left to
test and the answer is `0n`.

The recursion consumes `k`, and `k` is a subterm at every step, so the walk needs
no budget: the argument that shrinks is the one the match takes apart, and `n`
is carried along unchanged. The two arguments come in that order because a
recursive call is only accepted when every argument *before* the one that shrinks
is passed unchanged -- `n` is the one that is, so it comes first.

The test is a `Bool` term rather than a branch. `P.divides(a, b)` is the
prelude's exact divisibility test -- the remainder of `a` by `b` compared with
zero -- and it is there for a reason about the checker rather than for
convenience: a `match` cannot scrutinise a computed value, so the remainder
cannot be the scrutinee of a branch. `P.divides` matches on neither of its
arguments directly; it compares a term, so with variables the test is stuck,
which is what keeps the step law below definitional.

## The laws, and what each one pins

`cd_go_zero` is the pin on the walk's stopped answer: it fixes what the walk
answers when there is nothing left to test, and every `n` reaches it, `0n`
included. Its left-hand side is ground in the argument the walk matches on, so
it is definitional, and no other law here reaches that arm.

`cd_go_step` is the step, and it is definitional: it is the definition written
out. It says which numbers are counted, that each contributes exactly one, and
that the walk runs downward -- a body that counted `k` whether or not it divided
`n`, or that walked the other way, does not have its two sides equal.

`count_divisors_handoff` says where the walk starts: at `n`, not at some bound
below it. It is definitional, since `count_divisors` has no match of its own. A
body that started the walk at `1n` and climbed, or that stopped at half of `n`
and doubled the count, is separated here.

`count_divisors_one`, `count_divisors_seven` and `count_divisors_twelve` are the
closed values, and none of their right-hand sides calls a target, so all three
are absolute anchors. The first is the last step of the walk and the other two
fix what the recurrence is a recurrence *of*: `7n` is prime, so a body that
tested nothing answers `0n` or `1n` there, and `12n` has six divisors, so a body
that answered the sum of the divisors, or their largest, or the count of the
even ones, is separated there and nowhere above.

## What the policy implements

Two functions, `count_divisors` and `cd_go`, in `solution.bend`. `LAWS.bend`,
`prelude.bend` and everything under `references/` are immutable.
