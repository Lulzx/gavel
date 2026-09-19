# The floor of the base-two logarithm

`nat_log2(n)` is the largest `k` with `2n` to the `k` at most `n` -- how many
times `n` can be halved before it stops being at least `2n`:

    nat_log2(0n)  ==  0n
    nat_log2(1n)  ==  0n
    nat_log2(2n)  ==  1n
    nat_log2(7n)  ==  2n
    nat_log2(8n)  ==  3n

The `0n` line is a decision rather than a discovery: every power of two is at
least `1n`, so there is no exponent to report for zero, and this task answers
`0n`. The `1n` line is the base of the logarithm, and it is the one that trips a
body written to count halvings: `1n` is reached when the halving stops, not when
it starts, so the answer is `0n` and not `1n`.

There are two functions to implement. `nat_log2` is the answer. `log2_go(w, n)`
is the walk. It reads `w` as the width -- how many halvings are left to spend --
and `n` as the number still to be halved. Zero and one are below every power of
two above `1n`, so they stop the walk at `0n`. Anything above one is halved and
contributes one, and the walk continues on the halved number with one unit of
width spent.

The recursion consumes the width, and the width is a subterm at every step, so
the walk needs no other budget: the argument that shrinks is the one the match
takes apart, and the number is carried along unchanged. The two arguments come
in that order because a recursive call is only accepted when every argument
*before* the one that shrinks is passed unchanged -- the number is the one that
is not, so it comes second. This is also why the width exists at all: the
natural recursion would be on the halved number, which is a computed value, and
a `match` cannot scrutinise one.

The width is not part of the answer. `nat_log2` starts the walk with `n` itself
as the width -- always enough, since halving reaches `1n` within `n` steps for
every `n` -- so the answer is a function of `n` alone, and the width only bounds
the walk.

`P.half(n)` is the prelude's halving, rounding down. It takes the number apart
two at a time, so with a variable it is stuck, which is what keeps the step law
below definitional: both sides carry the same stuck halved term rather than one
of them computing.

## The laws, and what each one pins

`log2_go_no_fuel` is the pin on the walk's stopped answer: an exhausted width
answers `0n`. It is definitional and its left-hand side is ground in the width.
It is the only law that reaches width zero, and it is what stops a body from
answering a sentinel there -- the width bounds the walk, it is not the answer.

`log2_go_zero` and `log2_go_one` are the two small stops, and they are stated
separately because the walk reaches them by different arms. `log2_go_zero` is
inductive in the width (with a variable width the outer match is stuck);
`log2_go_one` is definitional, written at `1n + w` so the outer match steps. The
pair is what fixes the `0n` decision and what separates a body that spends a
halving on `1n`.

`log2_go_step` is the step, and it is definitional: it is the definition written
out at a number above one. It says that a halving costs one, that the walk
continues on `P.half(n)`, and that the width is spent one at a time. A body
that added nothing, or added a different amount, or recursed on the number
itself, has a different unfolding here.

`nat_log2_handoff` says what the walk is started on: `n` itself, which is a
width the answer does not mention. It is definitional, and it is what makes
`nat_log2` a function of `n` rather than of a width -- a body that returned the
width it was given, or that started the walk at a fixed width, is separated
here.

`nat_log2_zero`, `nat_log2_one`, `nat_log2_two`, `nat_log2_seven` and
`nat_log2_eight` are the closed values, and none of their right-hand sides calls
a target, so all five are absolute anchors. `0n` and `1n` are the decision and
the base. `2n` is the first number the step applies to. `7n` and `8n` are the
boundary either side of a power of two: a floor reports `2n` and `3n` for them,
so the pair catches a body that rounds up, or that counts the halvings of an
even number rather than the halvings that happened -- and no law stated only at
powers of two can see that.

## What the policy implements

Two functions, `log2_go` and `nat_log2`, in `solution.bend`. `LAWS.bend`,
`prelude.bend` and everything under `references/` are immutable.
