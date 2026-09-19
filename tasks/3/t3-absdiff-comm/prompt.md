Implement `absdiff` on Nat, then prove all five laws.

`absdiff(a, b)` is the difference between `a` and `b`, as a Nat. Nat has no
negative numbers, so a difference is the sum of the two truncated subtractions:
`P.sub(a, b) + P.sub(b, a)`, and `P.sub` is the prelude's -- it is the whole of
the vocabulary the laws are stated in, and the only thing under test is
`absdiff`. `P.sub` steps on both arguments at once, so with either side a
variable neither side reduces, and that is why the two zero laws below are a
case analysis rather than an unfolding.

The four laws below split into a pin pair and two theorems. `absdiff_zero_left` and
`absdiff_zero_right` are the pins: the first says a difference from zero is the
other number, the second says a difference *to* zero is the number itself. A body
that ignored its arguments -- `absdiff(a, b) = 0n`, or `= a` -- fails one of
them, and it is the pair that rules out both projections, since `absdiff(a, b) =
a` satisfies the left law and fails the right one and `= b` does the reverse.

`absdiff_self` says a number's difference from itself is zero, and it is where
the subtraction has to be unfolded on a *variable* pair: after the case analysis
the goal is about `P.sub(p, p)`, which no zero case reaches, so it needs its own
induction under the reserved `Policy.` namespace. `absdiff_comm` says the
difference does not care which way round it is taken; nothing above mentions the
order of the two subtractions, so this is the law that pins it, and its two sides
are the same two additions in the other order -- an addition that commutes, not
an unfolding.

`absdiff_succ_succ` is the interior step, and it is the law that says the
function is not free where the pins do not reach. The four above fix `absdiff`
on the two axes (`b == 0n`, `a == 0n`) and on the diagonal (`a == b`), and those
three lines leave everything between them open: nothing related `absdiff(a, b)`
to `absdiff(a-1, b-1)`, so a body could agree with the reference on all three
lines and disagree elsewhere. One does: the reference value plus its own product
with the smaller argument, `E + E * min(a, b)` where `E` is the sum of the two
subtractions. It is symmetric, it vanishes on the diagonal because `E` does, and
it answers `b` and `a` on the axes because `min` is `0n` there -- so it satisfies
all four laws above and answers `2n` where the reference answers `1n`.
`absdiff_succ_succ` says the two arguments move together, which is the step the
induction on the smaller argument needs, and `P.sub` steps on both arguments at
once so it closes by reduction rather than by an induction.

The arithmetic the proof needs is not in Base under the names the goals want:
`a + 0n` and `a + b == b + a` are both stuck on a variable, because `Nat.add`
steps on its left argument, so each is an induction of its own. They belong in
`Policy.` helpers, which the gate ignores and the credit path does not count. A
helper may call `P.*`, `S.*` and other `Policy.*`, but never a law, since a
helper that cited one would make an isolated law depend on a law that has not
been credited yet and the credit for both would be lost.

A variable is Lone by default -- usable live once per branch -- and a pattern
variable that the goal mentions more than once has to be rebound in the body
(`+p = p`) before it can be used a second time, or the checker reports
`consumed more than once`.

The direction of every rewrite is the one that matters. A rewrite `%e : P` fills
the hole in the motive `P` at the position of the *right* side of `e`'s equation
and puts the left side there, so `P` is the goal with the hole exactly where the
term you want to replace sits, and `Equal.sym` is how a lemma that points the
other way is turned around. A motive with the hole anywhere else is rejected
with `expected`/`observed` about the hole's type, which reads like a bug in the
lemma and is not one.

The law file imports the prelude as `P` and the solution as `S`, and the solution
does not re-export the prelude, so a law that means the prelude's `sub` must say
`P.sub`; naming `S.sub` gets `expected : a defined name / observed : S.sub`,
which also reads like a proof bug and is not one.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.absdiff_zero_left(b)`, `def L.absdiff_zero_right(a)`,
`def L.absdiff_self(a)`, `def L.absdiff_comm(a, b)` and
`def L.absdiff_succ_succ(x, y)`, and each may cite the
earlier helpers but never one of the other laws. Write the implementation in
`solution.bend` and the proofs in `PROOF.bend`.
