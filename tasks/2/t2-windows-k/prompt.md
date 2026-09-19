Implement `windows` and `windows_go`, the sliding window over a list, then prove
the laws that pin them.

`windows(k, xs)` must return every consecutive sublist of `xs` of length `k`, in
the order they appear. A list of three elements has two windows of length two
and one of length three, and no window of length four, and there is no window of
length zero at all.

The obvious way to write that down is to walk a pointer along the input, where
the pointer has one element per window still to come. That is `windows_go(ys, k,
xs)`: while `ys` is non-empty, the window starting at the front of `xs` is still
available, so it comes off the front of the answer, and the loop continues one
element along `xs` and one element along `ys`. `windows` itself is the case
split on `k`: `0n` has no window, and `1n + k` hands the loop the pointer the
prelude's `lookahead` computes.

Both functions take the length and the input as `+` binders: each names the
length once for what is taken and once for where the recursion goes, and names
the input once for the read and once for the step.

The law `windows_zero` fixes the answer at length zero. It is the weak companion
that pins that case: `windows_succ` says what a positive length answers in terms
of the loop, so a body that counted `0n` as one window still satisfies it.

The law `windows_succ` is the case split, written out. It is definitional --
both sides unfold -- and it is the law that says the two functions you write
have to agree about where the loop starts.

The law `windows_nil` says that an empty input has no windows whatever the
length. It is the one law here whose two sides do not reduce while the length is
a variable: the pointer is a stopped match, and nothing about it says the input
had no elements. The proof is an induction on the length, and each case closes
by computation because `lookahead` matches on the length first.

The law `windows_go_nil` fixes what the loop answers when the pointer runs out,
which is the only way it stops: it emits no window that is one element short.
The law `windows_go_step` fixes the step, and it is the one that says which
window is emitted -- `k` elements off the front of the input, with the same `k`
carried to the next turn.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.windows_zero(xs)`, `def L.windows_succ(k, xs)`, `def L.windows_nil(k)`,
`def L.windows_go_nil(k, xs)` and `def L.windows_go_step(h, t, k, xs)`.
