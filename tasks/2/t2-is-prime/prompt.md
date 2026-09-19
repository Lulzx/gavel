# Is it prime

`is_prime(n)` answers whether `n` has no positive divisor other than `1n` and
itself:

    is_prime(0n)  ==  False{}
    is_prime(1n)  ==  False{}
    is_prime(2n)  ==  True{}
    is_prime(4n)  ==  False{}
    is_prime(7n)  ==  True{}
    is_prime(9n)  ==  False{}

`0n` and `1n` are the decision rather than a discovery: neither has a divisor
other than `1n` and itself, since `1n` has no other integer at all and `0n` has
none above itself. The task answers `False{}` for both, and the two laws below
hold it to that at the gate, before any walk runs.

There are two functions to implement. `is_prime` is the answer: it rejects
`0n` and `1n` outright, and for anything else it asks the walk. `no_divisor(n, k)`
is the walk. It reads `k` as the largest number still to be tested, and it
answers `True{}` when none of `2n, ..., k` divides `n`. When `k` reaches `1n`
there is nothing left that counts as evidence and the answer is `True{}` --
`1n` divides everything, so testing it would make every number composite.

The recursion consumes `k`, and `k` is a subterm at every step, so the walk
needs no budget: the argument that shrinks is the one the match takes apart, and
`n` is carried along unchanged. The two arguments come in that order because a
recursive call is only accepted when every argument *before* the one that
shrinks is passed unchanged -- `n` is the one that is, so it comes first.

`is_prime` starts the walk at `n - 1n` rather than at `n`: a number always
divides itself, so testing `n` would make every number above `1n` composite.

The test is a `Bool` term rather than a branch. `P.divides(a, b)` is the
prelude's exact divisibility test -- the remainder of `a` by `b` compared with
zero -- and it is there for a reason about the checker rather than for
convenience: a `match` cannot scrutinise a computed value, so the remainder
cannot be the scrutinee of a branch. `P.divides` matches on neither of its
arguments directly; it compares a term, so with variables the test is stuck,
which is what keeps the step law below definitional.

## The laws, and what each one pins

`no_divisor_zero` and `no_divisor_one` are the two stops. They are stated at
`0n` and `1n` separately because the walk reaches them by different arms, and no
other law here looks at the `1n` arm: a body that treated `1n` as a candidate
would call every number composite and would be separated by `no_divisor_one`
alone. Both are definitional and both are pins on what "nothing left to test"
means.

`no_divisor_step` is the step, and it is definitional: it is the definition
written out at `2n + j`, the smallest `k` the walk is obliged to test. It says
which numbers are tested and against which number, and -- because the right side
carries `1n + j`, `k`'s predecessor -- that the walk descends one at a time
rather than skipping.

`is_prime_handoff` says where the walk starts: at `n - 1n`, not at `n` and not
at a fixed bound. It is stated at `2n + n` so that the left side reaches the
non-trivial arm of the gate; at a bare `n` the left side is stuck on the match
and the law would say nothing. It is definitional, and a body that started the
walk at `n`, or at `1n` and climbed, or that gated on a bound other than `2n`,
is separated here.

`is_prime_zero` and `is_prime_one` are the closed values of the gate, and they
are what pins the `n < 2n` decision: a body with no gate at all answers
`True{}` at both. Their right-hand sides call no target, so they are absolute
anchors.

`is_prime_two`, `is_prime_four`, `is_prime_seven` and `is_prime_nine` are the
closed values of the walk, and they are absolute anchors too. They are chosen so
that the parity gap is closed: `2n` is prime and smaller than any candidate,
`4n` is composite with `2n` as its only proper divisor, `7n` is prime and takes
the walk all the way down, and `9n` is composite with `3n` as its divisor.
`4n` catches a body that stops testing at `3n`; `9n` catches a body that tests
only even candidates; `7n` catches a body that answers `False{}` whenever a
candidate exists rather than whether one divides; `2n` catches a body whose walk
is started below `1n` or whose gate opens above `2n`. Neither `4n` nor `9n`
substitutes for the other.

## What the policy implements

Two functions, `no_divisor` and `is_prime`, in `solution.bend`. `LAWS.bend`,
`prelude.bend` and everything under `references/` are immutable.
