# The least common multiple

`lcm(n, m)` is the smallest positive number that is a multiple of both `n` and
`m`:

    lcm(1n, 1n)  ==  1n
    lcm(4n, 6n)  ==  12n
    lcm(6n, 4n)  ==  12n
    lcm(7n, 3n)  ==  21n
    lcm(5n, 7n)  ==  35n
    lcm(0n, m)   ==  0n

The `0n` line is a decision rather than a discovery: zero is a multiple of every
number, so nothing is a *least* common multiple of a pair involving zero in the
positive sense, and this task answers `0n` for either argument.

There are two functions to implement, and neither calls `gcd`. `lcm` is the
answer. `lcm_go(fuel, c, step, m)` is the walk.

`lcm_go` walks the multiples of `step` from `c` upward, with `fuel` candidates
left to try. `c` is a multiple of `step` by construction, so it is a common
multiple exactly when it is also a multiple of `m`, and it is the *least* common
multiple because the candidates are taken in order. When `c` is one the walk
stops on it; otherwise it continues on the next multiple, `c + step`, with one
unit of budget spent. When the budget runs out the walk answers the candidate it
reached, which is a multiple of `step` but possibly not of `m`.

That last arm is a give-up arm, and the budget is chosen so that the real answer
is never reached through it: the multiplier that gets from `n` to the answer is
`m` divided by the greatest common divisor of `n` and `m`, which is at most `m`,
so `m` candidates are always enough. `lcm` starts the walk on `n` itself -- the
first multiple of `n` -- with `m` candidates.

The recursion consumes the budget, and the budget is a subterm at every step, so
the walk needs no other structural descent: the argument that shrinks is the one
the match takes apart, and the candidate, the step and the target are carried
along unchanged. This is why the budget exists at all: the natural recursion
would advance the candidate to `c + step`, which is a computed value, and a
`match` cannot scrutinise one.

The test is a `Bool` term rather than a branch. `P.divides(a, b)` is the
prelude's exact divisibility test -- the remainder of `a` by `b` compared with
zero -- and it is there for a reason about the checker rather than for
convenience: a `match` cannot scrutinise a computed value, so the remainder
cannot be the scrutinee of a branch. `P.divides` matches on neither of its
arguments directly; it compares a term, so with variables the test is stuck,
which is what keeps the step law below definitional.

## The laws, and what each one pins

`lcm_zero_left` and `lcm_zero_right` are the two zero answers, and they are the
only laws that reach the arms where one argument is `0n`. `lcm_zero_left` is
definitional and ground in the first argument; `lcm_zero_right` is inductive in
`n`, because with a variable the outer match is stuck. Both have a right-hand
side that calls no target, so both are absolute anchors. The pair is what
separates a body that checked only its first argument: `lcm(n, 0n)` run through
the walk answers a non-zero number.

`lcm_handoff` says what the walk is started on and with how much budget: the
first multiple of `n`, with `m` candidates. It is definitional, and it is stated
at two successors so that both matches step. A body whose budget was `n` rather
than `m`, or whose walk started on `n + n`, is separated here.

`lcm_go_no_fuel` is the pin on the walk's stopped answer -- the candidate it was
carrying -- and it is definitional, with a left-hand side ground in the budget.
No other law reaches that arm.

`lcm_go_step` is the step, and it is definitional: it is the definition written
out at one candidate. It says that the candidate is tested against `m`, that it
is the answer when the test holds, and that otherwise the walk advances by
`step` -- not by one and not by `m` -- with one unit of budget spent. It is also
the law that says the candidates are taken in order, which is what makes the
first one that works the *least* one.

`lcm_one_one`, `lcm_four_six`, `lcm_six_four`, `lcm_seven_three` and
`lcm_five_seven` are the closed values, and none of their right-hand sides calls
a target, so all five are absolute anchors. `lcm_four_six` and `lcm_six_four`
are the same number with the arguments the other way round, which is what says
the answer is common to the two and not a function of which came first.
`lcm_seven_three` is a coprime pair, so the answer is not the product as a rule.
`lcm_five_seven` is the pair whose multiplier spends the budget exactly, and it
is the one law that separates a budget of `m` from a budget of `n`: the other
closed values have a multiplier smaller than both arguments and do not see the
difference.

## What the policy implements

Two functions, `lcm_go` and `lcm`, in `solution.bend`. `LAWS.bend`,
`prelude.bend` and everything under `references/` are immutable.
