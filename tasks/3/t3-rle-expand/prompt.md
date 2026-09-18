Implement `expand` on the prelude's run list, then prove all three laws.

A run is a value and how many times it is repeated, and the prelude owns the
record (`P.Mk{v, k}`), `P.repeat`, which is `n` copies of one value, `P.append`,
`P.len`, and `P.sum_k`, the total count in a run list. `expand(rs)` decodes the
runs into the flat list they stand for. `List<&2, P.Run>` is the run-list type
here: the `&2` is the element's usage annotation and not decoration, and a
signature written `List<P.Run>` infers `&1`, which the proof then cannot use
twice -- the error is `consumed more than once`, and it reads like a problem
with the pattern and is not one.

The encoding direction is not writable in this language and that is worth knowing
before starting: taking a flat list and finding its maximal runs means deciding
whether two adjacent elements are equal, and while a decision *procedure* is easy
to write, using its result is not. `match P.is_eq(h, h2):` is refused with "a
parameter or field scrutinee (a match cannot scrutinize a computed value: give it
its own def)", and there is no second def that helps, because the decision is
still an application of one. So the task is the decoding direction, where the
runs are given and every branch is a constructor.

The two pins are definitional. `expand_nil` fixes what an empty run list decodes
to, and `expand_cons` fixes one step: a run decodes to its value repeated its
count times, before the decoding of the rest. Both sides of each compute, so
`{==}` closes them, and the reason they are worth stating is that they are what
says the count is *used*: a body that decoded `P.Mk{v, k} <> t` as
`v <> S.expand(t)` agrees with the value law below on runs of length one and
leaves the two sides of `expand_cons` unconvertible.

The real work is `expand_len`: the decoded list has as many values as the runs
say. Its step needs two facts the prelude does not have, and neither is
definitional: the length of an `append` is the sum of the lengths, and the length
of `P.repeat(x, k)` is `k`. Both `P.append` and `P.repeat` match on a variable,
so each of those goals is stuck until something inducts on that argument too.
Three inductions, one law.

A variable is Lone by default -- usable live once per branch -- and in this task
the pattern is what needs marking: `case P.Mk{+v, +k} <> +t:` says the run's two
fields and the tail may each be used more than once. `v` and `k` each appear both
in the goal and in the lemma that rewrites it, and `t` appears both in the goal
and in the recursive call. The marker is also writable in a signature, and a
rebinding line at the top of a branch (`+u = t`) is the third way to say it.

The helpers belong under the reserved `Policy.` namespace, which the gate ignores
and the credit path does not count. A helper may call `P.*`, `S.*` and other
`Policy.*`, but never a law, since a helper that cited one would make an isolated
law depend on a law that has not been credited yet and the credit for both would
be lost. Their parameters are mostly erased (`-b`, `-c`) because each step uses
them only in the goal; the ones that are live twice carry `+` instead.

The direction of every rewrite is the one that matters. A rewrite `%e : P` fills
the hole in the motive `P` at the position of the *right* side of `e`'s equation
and puts the left side there, so `P` is the goal with the hole exactly where the
term you want to replace sits. A lemma stated the other way round has to be
flipped first: `Equal.sym(T, X, Y, e)` takes `e : {X == Y}` and gives `{Y == X}`,
so a lemma whose left side is the term already in the goal is exactly the case
that needs the flip. Write each motive out in the reduced form the goal has
reached -- a motive that spells the constructor application instead of the fields
it reduces to is rejected with `expected : Data / observed : Type`, which reads
like a kind error in the record and is not one.

The law file imports the prelude as `P` and the solution as `S`, and the solution
does not re-export the prelude, so the implementation must say `P.append`,
`P.repeat` and `P.Mk{...}`; naming them bare, or the type `Run`, gets
`expected : a defined name / observed : ...`, which also reads like a proof bug
and is not one.

The law-defs are written with no signature and bare binder names, in the fixed
order `def L.expand_nil()`, `def L.expand_cons(v, k, t)` and
`def L.expand_len(rs)`, and each may cite the earlier helpers but never one of
the other laws. A law with no binders still needs its empty parameter list.
Write the implementation in `solution.bend` and the proofs in `PROOF.bend`.
