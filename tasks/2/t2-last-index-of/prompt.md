Implement `last_index_of` on a list of `Nat`, then prove all five laws.

`last_index_of(xs, k)` is the position of the last element of `xs` that is `k`,
counting from `0n`, or the length of `xs` when `k` does not occur:

    last_index_of([5n, 7n, 6n], 6n)  ==  2n
    last_index_of([5n, 6n, 6n], 6n)  ==  2n
    last_index_of([5n, 7n, 6n], 9n)  ==  3n

The third of those is the sentinel at work: the answer is one past the last
position, which is exactly `P.len(xs)`, so the search never has to say "not
found" any other way. The second is what makes this `last_index_of` and not its
mirror: an element equal to the target earlier in the list does not decide the
answer once the target occurs again later.

Recurse on the list, but answer from the tail's side: it is the *last*
occurrence that is wanted, so the tail decides whether the head's own
occurrence is the one being asked for. `P.has_k(t, k)` is the walk that says
whether the target still occurs in the tail at all. When it does, the head does
not matter, and the answer is the tail's answer stepped on by one; when it does
not, the head is the last chance: `0n` when the head is the target, and
otherwise the tail's answer stepped on by one, which is the sentinel. `Nil{}`
answers `0n` -- its own length. The list is the argument that shrinks, and in
Bend the shrinking argument has to come before an argument that is only read, so
the list comes first and the target second.

The comparisons are the prelude's `P.eq` and each decision is taken by
`P.at_if`, which matches on the value it is handed. A match cannot scrutinise a
computed value where it is written, so the comparison is passed to `P.at_if`
rather than matched on in place; that is the only reason the two definitions
exist. `P.has_k` is the same idea one level up -- whether the target occurs
anywhere in a list -- and it is a def rather than a `match` for the same
reason. The tail is read twice in the step, once into `P.has_k` and once into
the recursive call, so it is declared reusably (`+t`); the target is read three
times, so it is declared reusably as well (`+k`).

The prelude is immutable and already has the vocabulary the laws are stated in:
`P.eq`, the comparison; `P.at_if`, the decision; `P.has_k`, whether the target
occurs at all; `P.len`, the length of a list; and `P.inc_all`, which steps every
element up by one, so that a list it is applied to has no `0n` in it at all.

`last_index_of_nil` pins the empty input. It is the only law whose left-hand
side is a closed list, and it fixes the answer there, which the step law below
never reaches.

`last_index_of_step` is the step, and it is definitional: the answer is taken
from the tail's side, on whether the target still occurs in the tail and on
whether the head is the target. It is the law that says the recursion reads the
tail before it decides, that the head is compared, and that the answer counts
positions.

`last_index_of_miss` is the not-found case, and it is what the sentinel is for.
Searching a list in which nothing is `0n` finds nothing, so the answer is the
length. This is the induction, and it fixes the sentinel's value: the step law
leaves the empty list's answer free, and a body that answered any constant there
satisfies the two laws above and fails this one.

`last_index_of_hit` is the found-at-head-and-nowhere-else case: `0n` when the
head is the target and the shifted tail behind it holds nothing. The step law is
stated for a variable `k`, so it never unfolds a comparison on its own --
`P.eq(k, k)` is stuck where the two arguments are the same variable -- and this
is the law that says the head's own occurrence is recorded at the position the
count starts from.

`last_index_of_last_wins` is the law that says *last* and not first: when the
head is the target and the target occurs again in the tail, the answer is the
tail's answer stepped on by one, so the head's own occurrence is not the one
recorded. A body that answered `0n` as soon as the head matched satisfies every
law above and fails this one.

Together the laws determine the body: the empty list is fixed, the step says
what a cons cell becomes, the hit says the head counts from zero when it is the
last one, the miss says the sentinel is the length, and the last-occurrence law
says a later match overrides an earlier one.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.last_index_of_nil(k)`, `def L.last_index_of_step(h, k, t)`, `def
L.last_index_of_miss(xs)`, `def L.last_index_of_hit(xs)` and `def
L.last_index_of_last_wins(k, t)`.
