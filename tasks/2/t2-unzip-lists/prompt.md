Implement `unzip`, the inverse of the bank's `zip`, then prove the laws that
pin it.

The input is `List<&2, P.Pair>`, a list of pairs of `Nat`; the output is
`P.ZP`, the record holding two lists of `Nat`. `unzip(ps)` must return the pair
of lists that has the same length as `ps`, with every pair's first component in
the first list and every pair's second component in the second list, both in the
order the pairs came. Recurse on `ps`: `Nil{}` gives the record of two empty
lists, because there is nothing left to send anywhere, and `h <> t` gives the
record whose first list starts with the first component of `h` and continues
with the first list of `unzip(t)`, and whose second list is the same one step
over with the second component of `h`.

The law `unzip_nil` fixes the answer the recursion reaches on the empty list. It
is the weak companion that pins the base case: the two cons laws say what a
non-empty input answers in terms of its tail, so a body that got the empty list
wrong still satisfies them.

The law `unzip_cons_fst` says what the first list of the answer is at a step,
through the prelude's accessor `P.zfst` -- a record is not a constructor a law
can take apart, so the law reaches into the answer rather than matching it. It
is definitional: both sides unfold. It is also the law that fixes which half of
each pair goes into which list, since a body that swapped them answers the
second law but not this one.

The law `unzip_cons_snd` is the same statement for the second list, and it is
separate for exactly that reason.

The law `unzip_len_fst` says the first list has as many elements as the input
had pairs, and `unzip_len_snd` says the same for the second list. Neither
follows from the laws above: those say how each list grows by one at a step, and
a body that stopped before the end of the input, or that dropped a pair, can
satisfy them on the prefix it does produce. Both are stated against the
prelude's `P.plen`, which counts the input, and not against anything you write.
Both are inductive in `ps`, and neither side reduces while `ps` is a variable,
so the proof of each is the induction itself.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.unzip_nil()`, `def L.unzip_cons_fst(a, b, t)`,
`def L.unzip_cons_snd(a, b, t)`, `def L.unzip_len_fst(ps)` and
`def L.unzip_len_snd(ps)`.
