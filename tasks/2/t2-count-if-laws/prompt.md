Implement `count_if`, which counts the records that pass a test, then prove the
laws that pin it.

The input is a list of the prelude's records, `P.Pair`, each built with
`P.MkPair{a, b}` from two numbers. `count_if(ps)` must return how many records
have equal halves, so `count_if(P.MkPair{1n, 1n} <> (P.MkPair{1n, 2n} <> Nil{}))`
is `1n`. The test is the prelude's `P.same(a, b)`, which answers `1n` when its
two arguments are equal and `0n` when they are not -- it is a number rather than
a truth value so that the step law below is an arithmetic statement rather than
a premise about a decision. Recurse on the list: the empty list counts nothing,
and a record contributes `P.same` of its two halves plus whatever the tail
contributes.

The law `count_if_nil` fixes the answer on the empty list: there is nothing to
count, so the count is `0n`. It is the pin on the empty case, which the step law
below does not reach, and it fixes the only answer the other laws can start
from.

The law `count_if_cons` is the step. It says a record contributes `P.same` of
its two halves and nothing else. It is the law that pins that both halves are
read: a body that counted every record, or that tested a half against itself,
leaves the two sides unconvertible for a variable record.

The law `count_if_snoc` says that appending one record on the right adds that
record's contribution and changes nothing else. It is inductive in the list, and
it is the law that pins the count over a list the recursion never reaches in one
step: a body that counted the first record twice, or that dropped the last one,
satisfies the step law and fails this one.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.count_if_nil()`, `def L.count_if_cons(a, b, t)` and
`def L.count_if_snoc(ps, a, b)`.
