Implement `sum_to` on Nat, then prove all three laws.

`sum_to(n)` is the sum `0n + 1n + ... + n`. The empty sum is `0n`, and each step
adds the new top on: `sum_to(p) + (1n + p)`, so the term the laws talk about is
the same one the recursion builds. The prelude is immutable and deliberately has
no definitions: every law below is stated in Base's own arithmetic, `+` and `*`
on Nat, and `sum_to` is the only function under test.

The two pins are definitional. `sum_to_zero` fixes the empty sum and
`sum_to_succ` fixes one step of the descent, `sum_to(p) + (1n + p)`. Both sides
of each compute, so `{==}` closes them, and the pair is what says the answer
actually walks down the argument: a body that ignored its argument,
`sum_to(n) = 0n`, satisfies the zero law and leaves the two sides of
`sum_to_succ` unconvertible.

The real work is `sum_to_double`, and it is not an unfolding. `*` on Nat steps on
its *left* argument, so with a variable on the left neither side of the law
computes, and after the step case unfolds `sum_to(1n + p)` the hypothesis is
about `sum_to(p) + sum_to(p)` while the goal has the two halves of the sum apart.
The step needs the doubling re-expressed as `x + x`, the two occurrences of
`sum_to(p)` gathered together, and both sides rearranged into one shape -- which
is what `Policy.two_mul` and a helper carrying the hypothesis in the `+` form are
for. Neither is asked for; both have to be found.

The arithmetic the proof needs is not in Base under the names the goals want:
`a + 0n`, `a + (b + c) == (a + b) + c`, `a + (1n + b) == 1n + (a + b)`,
`a + b == b + a`, `x * 0n == 0n`, `x * (1n + y) == x + x * y`, `a * b == b * a`
and `2n * x == x + x` are each stuck on a variable or on nothing at all, so each
is an induction of its own. They belong in `Policy.` helpers, which the gate
ignores and the credit path does not count. A helper may call `S.*` and other
`Policy.*` (and `P.*`, though this prelude has none), but never a law, since a
helper that cited one would make an isolated law depend on a law that has not
been credited yet and the credit for both would be lost.

A variable is Lone by default -- usable live once per branch -- and a pattern
variable that the goal mentions more than once has to be rebound in the body
(`+p = p`) before it can be used a second time, or the checker reports
`consumed more than once`. That rebind is needed inside `sum_to` itself, which
mentions `p` both as the argument of the recursion and in the added term.

The direction of every rewrite is the one that matters. A rewrite `%e : P` fills
the hole in the motive `P` at the position of the *right* side of `e`'s equation
and puts the left side there, so `P` is the goal with the hole exactly where the
term you want to replace sits, and `Equal.sym` is how a lemma that points the
other way is turned around. A motive with the hole anywhere else is rejected
with `expected`/`observed` about the hole's type, which reads like a bug in the
lemma and is not one.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.sum_to_zero()`, `def L.sum_to_succ(p)` and
`def L.sum_to_double(n)`, and each may cite the earlier helpers but never one of
the other laws. Write the implementation in `solution.bend` and the proofs in
`PROOF.bend`.
