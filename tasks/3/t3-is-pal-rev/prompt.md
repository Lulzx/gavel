Implement `is_pal` on the prelude's `List<&2, Nat>`, then prove all four laws.

`is_pal(xs)` is `True{}` exactly when `xs` reads the same backwards. The prelude
is immutable and already has the vocabulary the laws are stated in: `P.rev`,
which reverses a list, `P.eq_nat`, which compares two numbers, and `P.eq_list`,
which compares two lists element by element and is what the answer is phrased
with. `List<&2, Nat>` is the list type here, and a law or helper written over
`List<Nat>` will not unify with these.

The two value pins are definitional. `is_pal_nil` and `is_pal_single` fix the
empty and the one-element list. `is_pal_single` is a pin all the same, but it is
not a computation: the goal unfolds to `Bool.and(eq_nat(h, h), True{})` and
`P.eq_nat` matches on both of its arguments, so with a variable `h` on both
sides nothing reduces and the reflexivity of `P.eq_nat` has to be proved.

`is_pal_two_distinct` is the law the pins cannot replace. A body that answers
`True{}` everywhere satisfies both of them, and so does a body that compares the
list with *itself* instead of with its reverse, since `eq_list(xs, xs)` is `True`
for every list. Both are wrong, and the concrete two-element instance is what
says so: `eq_nat(0n, 1n)` is `False{}`, so the answer has to be `False{}` too.

The real work is `is_pal_rev`: whether a list is a palindrome does not change
when the list is reversed. Nothing about it is definitional. `P.rev` of a
variable list is stuck, so after unfolding the goal is about `P.rev(P.rev(xs))`
and nothing in it reduces. Two facts close it, and neither is in the bank as
anything a proof may cite:

    rev_rev : rev(rev(xs)) == xs

is a *law* of another task. A helper may never cite a law -- an isolated law
that depended on another law would lose the credit for both -- so it is reproved
here as a `Policy.` helper, which costs the `snoc`-shaped induction below it.

    eq_list_sym : eq_list(xs, ys) == eq_list(ys, xs)

is not in the bank at all. `P.eq_list` reads its two sides left to right -- the
head of the first against the head of the second -- so the swapped arguments are
a different term and the fact that the answer does not change is an induction on
both lists at once, one case for each way the two lists can start.

`P.rev` is built from `P.snoc`: reversing a cons is `snoc(rev(t), h)`, so a goal
about the reverse of a reversed *cons* does not reduce until the induction moves
that element across, which is the helper `rev_snoc`. Its induction, and the
`snoc`-shaped one under it, are what `rev_rev` is proved from. The list
parameter of both is `+`: the destructured tail is live twice in the step, once
as the recursive call and once in what is left of the goal, and a Lone binder
used twice is rejected with `consumed more than once`, which reads like a bug in
the prelude and is not one.

`is_pal` itself needs `+xs`, for the same reason one level up: the answer is
`eq_list(xs, rev(xs))`, and `xs` is consumed by both calls. The stub's signature
already says so.

The helpers belong under the reserved `Policy.` namespace, which the gate
ignores and the credit path does not count. A helper may call `P.*`, `S.*` and
other `Policy.*`, but never a law.

The direction of every rewrite is the one that matters. A rewrite `%e : P` fills
the hole in the motive `P` at the position of the *right* side of `e`'s equation
and puts the left side there, so `P` is the goal with the hole exactly where the
term you want to replace sits, and a lemma stated the way you need it is used
bare while one stating it the other way needs `Equal.sym` around it.
`Equal.sym(T, a, b, e)` takes `e` at `a == b` and gives `b == a`, so the first
two arguments are the equation the proof already has, in that order -- not the
order the goal wants. A motive with the hole anywhere else is rejected with
`expected`/`observed` about the hole's type, which reads like a bug in the lemma
and is not one.

The law file imports the prelude as `P` and the solution as `S`, and the solution
does not re-export the prelude, so a law that means the prelude's `rev` must say
`P.rev`; naming `S.rev` gets `expected : a defined name / observed : S.rev`,
which also reads like a proof bug and is not one.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.is_pal_nil()`, `def L.is_pal_single(h)`,
`def L.is_pal_two_distinct()` and `def L.is_pal_rev(xs)`, and each may cite the
earlier helpers but never one of the other laws. Write the implementation in
`solution.bend` and the proofs in `PROOF.bend`.
