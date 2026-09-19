Implement `distinct` and its walk `distinct_go`, then prove all seven laws.

`distinct(xs)` is `xs` with every duplicate removed, keeping the *first*
occurrence of each element and the order of the elements that survive:

    distinct([1n, 2n, 1n])       ==  1n <> 2n <> Nil{}
    distinct([3n, 3n, 3n])       ==  3n <> Nil{}
    distinct([1n, 2n, 3n])       ==  1n <> 2n <> 3n <> Nil{}

This is not `dedup`: an element is dropped when it occurred anywhere *earlier*,
not only when it sits next to its twin. `[1n, 2n, 1n]` answers `[1n, 2n]`, and a
body that compared each element with the one before it would answer the whole
list back.

`distinct` is one step: a cons cell keeps its head -- nothing has been seen
before it -- and hands its tail to `distinct_go` with the head as the one element
already seen. The empty list answers the empty list.

`distinct_go(xs, seen)` walks `xs` carrying `seen`, the set of elements already
kept. The empty list answers the empty list -- there is nothing left to keep. A
cons cell tests its head with `P.mem(seen, h)` and either leaves it out or keeps
it in front of the rest of the walk, and it recurses with the head *added* to
`seen`, which is what lets a later duplicate of it be recognised. The list is the
argument that shrinks, and in Bend the shrinking argument has to come before the
arguments that are only read, so the list comes first. The head is read three
times in the step and `seen` twice, so both are declared reusably (`+h`,
`+seen`).

The test is the prelude's `P.mem` and the decision is taken by `P.skip_if`, which
matches on the value it is handed. A match cannot scrutinise a computed value
where it is written, so the test is passed to `P.skip_if` rather than matched on
in place. The prelude also has `P.eq` (the comparison `P.mem` is built from),
`P.or_if`, and `P.same`, the list of `n` copies of an element, which the last
laws but one are stated over.

`distinct_nil` pins the empty input. Its left-hand side is a closed list and it
fixes the answer there, which the cons law below never reaches.

`distinct_cons` is definitional: a cons cell keeps its head and hands the tail to
the walk with the head as the one element already seen. It is the law that says
the *first* occurrence is the one that survives -- the head is kept before
anything is compared with it -- and that the walk starts with the head in the set
rather than with the set empty.

`distinct_go_nil` is the walk's empty case, and `distinct_go_step` is the law with
the content: the head is tested against the whole seen set and the walk recurses
with the head carried into it. Two bodies are separated here. One tests the head
against the previous element instead of the set (it is the same change: recursing
with `h <> Nil{}` in place of `h <> seen`), and it keeps a duplicate that is not
adjacent. The other never adds the head to the set at all, and it drops an
element that was seen further back.

`distinct_same_seen` is the induction, stated over the walk: a walk over `n`
copies of `k`, from a set that already holds `k`, answers the empty list,
whatever else the set holds -- every one of them is a duplicate of something seen
before. A body that tested the head against the previous element answers the list
back on `n >= 2`; a body that answered a constant at the empty list is separated
by `distinct_go_nil` and here.

`distinct_same` is the answer a user reads on a list of equal elements: a list
headed by `k` with `m` more copies of `k` behind it answers the one element.

`distinct_nonadjacent` is one closed list, `[1n, 2n, 1n]`, answered end to end.
This is the law that separates this function from `dedup`: every other law here
holds of an adjacent-only body, because in a list of equal elements every
occurrence is adjacent to its twin.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.distinct_nil()`, `def L.distinct_cons(h, t)`, `def L.distinct_go_nil(seen)`,
`def L.distinct_go_step(h, t, seen)`, `def L.distinct_same_seen(n, k, seen)`,
`def L.distinct_same(m, k)` and `def L.distinct_nonadjacent()`. Any lemma you
need about the prelude's own functions goes under the reserved `Policy.*`
namespace, as `def Policy.<name>(...)`, so that it is not taken for a law.

Two things about proof defs that a law about the walk runs into. A proof def's
parameters are good for one live use each, so an argument cited several times
over the steps is rebound reusable first (`+r = k`, `+s = seen`) and the steps
cite that. And `%e : { ... _ ... }` rewrites the hole, which must sit where the
right-hand side of the equation `e` proves occurs; the body under it then sees
the equation's left-hand side there. That is why a step that folds a term *back*
to its left-hand side passes `Equal.sym` of the lemma rather than the lemma.
