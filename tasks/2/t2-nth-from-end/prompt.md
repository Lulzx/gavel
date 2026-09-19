Implement `nth_from_end`, then prove all seven laws.

`nth_from_end(xs, k, d)` is the element `k` positions from the end of `xs`,
counting the *last* element as `0` positions from the end, or the default `d`
when `xs` has no such element:

    nth_from_end([1n, 2n, 3n], 0n, 9n)  ==  3n
    nth_from_end([1n, 2n, 3n], 1n, 9n)  ==  2n
    nth_from_end([1n, 2n, 3n], 3n, 9n)  ==  9n

The list is the argument that shrinks, and in Bend the shrinking argument has to
come before the arguments that are only read, so the list comes first.

The walk's shape is: a cons cell answers its head when its *tail* holds `k`
elements, and otherwise recurses on the tail; the empty list answers the default.
The test is the prelude's `P.len(t)`, the number of elements in the tail, compared
with `P.eq` against `k`. `P.len(t)` is a computed value, so it is passed to
`P.pick_if` rather than matched on: a match cannot scrutinise a computed value
where it is written, and `P.pick_if` matches on the value it is handed. The
`k` it is compared against is read twice in the step and the default is read on
both paths, so they are declared reusably (`+k`, `+d`).

The prelude also has `P.snoc`, the list with an element appended at the end, and
`P.same`, the list of `n` copies of an element. The laws about an element at a
known distance from the end are stated over those: a variable list cannot be
written to the left of a cons -- `xs <> x` is a cons of a *list* onto a list --
so an element at the end of a list of unknown length has to be put there by
`P.snoc`.

`nth_from_end_nil` pins the empty input. It is the absolute anchor: its
right-hand side mentions no target, and it is the only law that reaches the empty
list.

`nth_from_end_step` is definitional: the head against the tail's length, and the
tail otherwise. It is the law that says what the distance is measured in --
`P.len(t)` counts the elements *after* the head -- and it is stated at variables,
so it holds at every list and every distance.

`nth_from_end_pair_last` and `nth_from_end_pair_first` are the two answers on a
two-element list, at `0n` and at `1n` positions from the end. The elements are two
different variables, so the laws say *which* of them is answered: one fixes that
`0n` reaches the end, the other that `1n` reaches one element further back.

`nth_from_end_third` is the answer on a three-element list at `2n` positions from
the end -- a list whose tail is two elements long, so a body that special-cased
short tails is separated by it.

`nth_from_end_last` is the induction, and it is stated over `P.snoc(P.same(n, x),
y)`: a run of `n` copies of `x` with a `y` at the end, asked for the element `0n`
positions from the end, which is the `y`. The run is a variable, so the law holds
at every length, and it is the law that separates a body that answered an element
from near the front from one that carried the distance to the end.

`nth_from_end_out` is one closed list asked for a distance past its end, and the
answer is its default. The default there is a literal rather than a variable, so
a body that ignored its third argument and answered a constant fails this law
rather than satisfying it by accident.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.nth_from_end_nil(k, d)`, `def L.nth_from_end_step(h, t, k, d)`, `def
L.nth_from_end_pair_last(x, y, d)`, `def L.nth_from_end_pair_first(x, y, d)`,
`def L.nth_from_end_third(x, y, z, d)`, `def L.nth_from_end_last(n, x, y, d)`
and `def L.nth_from_end_out()`. Any lemma you need about the prelude's own
functions goes under the reserved `Policy.*` namespace, as `def
Policy.<name>(...)`, so that it is not taken for a law.

Two things about proof defs that a law with an induction in it runs into. A proof
def's parameters are good for one live use each -- and so are the binders its own
`match` introduces -- so anything cited more than once is rebound reusable first
(`+rp = p`, `+ry = y`) and the steps cite the rebound names. And `%e : { ... _ ...
}` rewrites the hole, which must sit where the right-hand side of the equation
`e` proves occurs; the body under it then sees the equation's left-hand side
there. That is why a step that folds a term *back* to its left-hand side passes
`Equal.sym` of the lemma rather than the lemma.
