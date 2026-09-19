Implement `pairs` on a list of `Nat`, then prove all four laws.

`pairs(xs)` packs each element with the one after it: `pairs([1n, 2n, 3n])` is
`[P.MkPair{1n, 2n}, P.MkPair{2n, 3n}]`. A lone last element has no neighbour
and is dropped, so `pairs([1n])` is `Nil{}` and `pairs(Nil{})` is `Nil{}`. Both
matches are needed: the outer one splits off the first element, and the inner
one on the tail tells you whether there is a second. The result is built with
`P.MkPair{a, b}`, the record the prelude declares.

The prelude is immutable and already has the vocabulary the laws are stated in:
`P.MkPair{a, b}`, `P.len`, the length of a list of `Nat`, and `P.plen`, the
length of a list of pairs -- `len` does not take the pair type, and `plen` does
not look inside a pair.

`pairs_nil` fixes the answer on an empty input and `pairs_single` on a
one-element one; the step law below only names lists of two or more elements, so
neither covers the other's case, and `pairs_single` is what catches a body that
packed the last element with nothing.

`pairs_cons` is the step: the first two elements are packed together, and the
answer continues with the pairs of the tail *from the second element on*. It is
the law that says which number goes in which component, and it is the only law
here that looks inside a pair at all -- a body that built `P.MkPair{h, x}`
instead has the right shape everywhere else, and a body that recursed on `t`
instead of on `b <> t` answers a list that is short by a pair.

`pairs_len` is the count law, and it is the one law here that is not
definitional: with `x` on the front, `pairs` is stuck, so the two sides do not
compute and the induction is the proof. It pins how many pairs there are -- the
answer is one shorter than the input -- while `pairs_cons` pins which pairs they
are.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.pairs_nil()`, `def L.pairs_single(x)`, `def L.pairs_cons(a, b, t)` and
`def L.pairs_len(xs, x)`.
