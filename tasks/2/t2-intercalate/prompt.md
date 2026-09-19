Implement `intercalate` on lists of lists of `Nat`, then prove the four laws
about it.

`prelude.bend` declares two defs: `P.append(xs, ys)` is the concatenation of two
lists, and `P.concat(xss)` is the concatenation of a whole list of lists. Both
are ordinary Bend, and neither mentions the target.

`intercalate(sep, xss)` is `xss` joined by putting `sep` in every gap. So on
`xs <> (ys <> (zs <> Nil{}))` it answers `xs` then `sep` then `ys` then `sep`
then `zs`: the separator goes *between* the lists, never before the first one and
never after the last. The separator is itself a list, so the answer is one list
however many pieces it is made of.

Recurse on `xss`. The empty collection has no gaps to fill and answers the empty
list. A one-element collection has no gap either, so it answers that list
unchanged. From two lists on, the answer is the first list, then the separator,
then the joining of the rest -- and that answer is written with `P.append`,
whose first argument is the first list.

`intercalate_nil` and `intercalate_single` are the absolute anchors: both sides
compute in each, neither right-hand side calls `intercalate`, and together they
fix the empty and the one-element answer. A body that wrapped the separator
around every list satisfies the step law below, which never reaches a
one-element collection, and is separated by the second of these.

`intercalate_cons` is the step: two or more lists are the first, the separator,
and the joining of the rest, concatenated. Both sides compute. It is the law
that says where the separators go and which list they follow.

`intercalate_nil_sep` is the law with content, and the only one that is not
definitional: with an empty separator the answer is `P.concat(xss)`, and it is
stated over a variable collection, so nothing reduces and it takes an induction
on `xss`. Because the separator is a list, this is a law about joining that
`intersperse` cannot state: `P.concat` is an operation the body never calls, so
the answer is read here as a concatenation of the lists rather than as a
rearrangement of the recursion, and the one-element branch of the induction is
where the identity `P.append(xs, Nil{}) == xs` is needed. You may prove it as
`def Policy.append_nil(xs: List<&2, Nat>)`.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.intercalate_nil(sep)`, `def L.intercalate_single(sep, xs)`,
`def L.intercalate_cons(sep, a, b, t)` and `def L.intercalate_nil_sep(xss)`.
