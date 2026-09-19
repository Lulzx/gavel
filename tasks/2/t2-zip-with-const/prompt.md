Implement `zip_with_const` on a list of `Nat`, then prove the four laws about
it.

`zip_with_const(xs, k)` packs every element of `xs` with the same constant `k`,
in the order the elements came:

    zip_with_const([1n, 2n], 9n)  ==  [P.MkPair{1n, 9n}, P.MkPair{2n, 9n}]

The bank's `zip` packs two lists with each other; this one has only one list and
a number, so every pair in the answer shares its second component.

Recurse on the list: `Nil{}` answers the empty list, because there is nothing
left to pack, and a cons cell answers `P.MkPair{h, k}` -- its own element
packed with the constant -- in front of the pairs of the tail. The list is the
argument that shrinks, and in Bend the shrinking argument has to come before an
argument that is only read, so the list comes first and the constant second. The
constant is read twice in the step, once into the pair and once into the
recursive call, so it is declared reusably (`+k`).

`prelude.bend` declares `P.Pair`, the record the pairs are built with, and the
observations the laws are stated in: `P.fsts` and `P.snds`, which read a list of
pairs back as its first and second components in order, `P.len`, the length of a
list of `Nat`, and `P.repeat(n, x)`, the list of `n` copies of `x`.

`zip_with_const_nil` pins the empty input. Both sides compute, so it is
definitional, and it is a pin: the step law below names a cons cell and never
reaches the empty list.

`zip_with_const_step` is the step, and it is definitional: the answer at a cons
cell is that cell's pair in front of the tail's answer. It is the law that says
which number goes in which component and which list is recursed on -- a body
that built `P.MkPair{k, h}`, or that recursed on the whole list, leaves the two
sides unconvertible.

`zip_with_const_fsts` is the law with content, and it is the one that pins the
first components. It says the first components of the answer are the input,
element for element: a body that packed each element with the one before it, or
that dropped an element, satisfies the two laws above on the prefix it does
produce and leaves the two sides here unconvertible. Its right-hand side is the
binder `xs` and calls no target, and its tree is a variable, so the two sides do
not compute and the induction on the list is the proof.

`zip_with_const_snds` is the other half, and it pins the second components: the
answer's second components are `k` repeated once per element. It is stated
against `P.repeat` and `P.len` rather than against anything you write, it is
inductive in the list too, and a body that answered a constant in the first
component and the element in the second is separated by this law and by the step
law both.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.zip_with_const_nil(k)`, `def L.zip_with_const_step(h, k, t)`,
`def L.zip_with_const_fsts(xs, k)` and `def L.zip_with_const_snds(xs, k)`.
