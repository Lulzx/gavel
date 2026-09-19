Implement `best_gain` on lists of `Nat`, then prove the four laws about it.

`best_gain(xs)` is the largest rise from an earlier element to a later one: the
maximum of `xs[j] - xs[i]` over the pairs of positions `i < j`, or `0n` when no
later element exceeds an earlier one. It is a `Nat`, not a list and not a pair.
`best_gain([1n, 5n, 3n, 6n])` is `5n`, from the `1n` to the `6n`;
`best_gain([4n, 2n, 0n])` is `0n`, because the list only falls.

Recurse on `xs`: `Nil{}` answers `0n`, and a cons cell answers the better of two
things -- the best rise from the head into the tail, and the best gain among the
tail's own pairs. Every pair either has the head as its earlier element or it
does not. The tail is read twice, by both of those, so the cons pattern marks it
reusable and the list type is `List<&2, Nat>`.

The prelude is immutable and already has the vocabulary the laws are stated in:
`P.max_sub(h, ys)` is the largest rise from `h` to an element of `ys`, floored
at zero, computed in one pass over `ys`. The floor matters: the subtraction is
truncated, so a fall contributes `0n` rather than a negative number, which is
what lets the answer for a falling pair be `0n` with no separate case. `Nat.max`
and `Nat.sub` are the Base ones.

The law `best_gain_nil` fixes the empty answer at `0n`. Both sides compute, so
it is definitional, and it is the anchor: the step law names its argument as a
cons cell, so nothing else here reaches the empty input.

The law `best_gain_single` fixes the one-element answer at `0n`, the other half
of the anchor: with one element there is no later element at all, so no pair to
measure.

The law `best_gain_cons` is the step, and it says what is being maximised: the
head's best rise into the tail alongside the tail's own best gain. It is the law
a body that measured a drop instead of a rise, or that stopped at the head and
never looked inside the tail, fails. Both sides compute.

The law `best_gain_pair` writes the answer out on the smallest input that has a
pair in it: two elements, and the answer is the second minus the first, with the
truncated subtraction supplying the `0n` for a fall. It is the law that pins the
shape of the answer rather than one step of the recursion -- a body that agreed
with the step law and with both anchors is already a single function, and this is
where that function's value on a pair is stated with no `max` in the way.

Together the four determine `best_gain` on every input, by induction on the
length: the first two fix the empty and one-element answers, and the step law
fixes every longer list from its tail.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.best_gain_nil()`, `def L.best_gain_single(x)`, `def L.best_gain_cons(h,
t)` and `def L.best_gain_pair(a, b)`. Helpers go under the reserved `Policy.`
namespace, which the gate ignores, and none of them may cite a law.
