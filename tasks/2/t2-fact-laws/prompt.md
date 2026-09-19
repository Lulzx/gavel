Implement `fact` and `facts`, then prove the five laws.

`fact(n)` must return the product of the numbers `1` through `n`, with
`fact(0n)` being `1n`. `n` is the argument that gets consumed: `0n` is the base
case and the step is `Nat.mul(1n + p, fact(p))`, where `p` is what the match
bound for the predecessor of the successor it was given. That step names `p`
twice, and a binder is consumed on every use whichever way it was bound -- a
match pattern is no different from a parameter here, against the intuition that
the value was just matched and is therefore free to look at again. Write the
pattern `1n++p` to bind it reusable.

`facts(xs)` is the list of the factorials of the elements of `xs`, in order. It
is a plain map: `Nil{}` answers `Nil{}`, and a cons cell answers
`S.fact(h) <> facts(t)`.

The laws are:

    S.fact(0n) == 1n
    S.fact(1n + n) == Nat.mul(1n + n, S.fact(n))
    S.facts(Nil{}) == Nil{}
    S.facts(x <> xs) == S.fact(x) <> S.facts(xs)
    P.len(S.facts(xs)) == P.len(xs)

The first four hold by definition and the checker reduces both sides of each
without you splitting a case. The fifth is the one that carries the weight, and
it is the reason the task is not a restatement of the definitions it ships.
`xs` is a variable, so neither `P.len(S.facts(xs))` nor `P.len(xs)` reduces to
anything, and the two sides are equal by an induction on `xs` rather than by
computation -- the empty case is the two base cases, and the step case reaches
`P.len(S.fact(x) <> S.facts(xs))`, which is `1n + P.len(S.facts(xs))` against a
right-hand side of `1n + P.len(xs)`, so the induction hypothesis is exactly what
is missing. Do that induction. A proof of this law that does not split on `xs`
does not exist, and a proof that writes the law off as obvious is the failure
this task is here to catch.

Write the implementations in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.fact_zero()`, `def L.fact_succ(n)`, `def L.facts_nil()`,
`def L.facts_cons(x, xs)` and `def L.facts_len(xs)`.
