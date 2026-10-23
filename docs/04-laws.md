# What makes a law worth training on

A task is only as good as its laws, and the obvious way to write a law is
wrong. This page is the reasoning that the bank is built on.

## The failure mode

Consider `law add_zero: for x: Nat {S.add(x, 0n) == x : Nat}`. This
submission earns full reward:

```
def add(a: Nat, b: Nat) -> Nat:
  a

def L.add_zero(x):
  {==}
```

The projection `add(a, b) = a` satisfies the law definitionally, so `{==}`
proves it. The checker agrees. The same holds for a base-case law
(`f(0n) == 0n` is satisfied by `f = 0n`) and for any right-identity law. The
task that was written that way has been retired.

Requiring both sides to depend on the arguments is neither necessary nor
sufficient:

```
law add_succ: for x: Nat  for y: Nat  {S.add(x, 1n+y) == 1n+S.add(x, y) : Nat}
```

Both sides depend on both arguments, and `add(a, b) = b` satisfies it, because
the goal becomes `1n+y == 1n+y`. That submission was measured at reward 1.000
for a function nobody had implemented.

The reason generalises. A single equation cannot pin a two-argument function
whose arguments share a type, because whenever both applications receive the
same term in one position, projecting onto that position collapses both sides
to something the equation already relates.

## What does pin a function

Put a term that never mentions the function on the right:

```
law add_plus: for x: Nat  for y: Nat  {S.add(x, y) == x + y : Nat}
```

Under `add(a, b) = b` the goal is `y == x + y`, which is false. Under
`add(a, b) = a` it is `x == x + y`, also false.

Containers are different, because there the projection is a homomorphism.
`append(x <> xs, ys) == x <> append(xs, ys)` is satisfied by `append(a, b) = a`,
since it maps `x <> xs` to itself on both sides. What pins a container-valued
function is the **empty value on the left**: `append(Nil{}, ys) == ys` becomes
`Nil{} == ys` under the projection, which is false.

So the bank is built two ways. Tier 1 is one law whose right-hand side never
mentions the function, or a base law and a cons law that pin together. Tier 2
is a weak base law plus the inductive law.

## The test is mechanical

A law pins its function only if no argument-ignoring body satisfies it. That
is a thing you run, not a thing you read off the laws, and it is what
validation does (V3 in `gavel/validate.py`).

Three things make the sweep easy to get wrong, all of them measured here:

1. It must run against a `{==}`-only proof. Checking a bad solution against the
   reference proof asks whether that proof is brittle, not whether the laws
   pin the function.
2. It must try every same-typed parameter, not the first. An early version
   projected `add` onto `a` and never tried `add(a, b) = b`.
3. It must include the body that uses a parameter twice. `mul(a, b) = b + b`
   satisfies `mul_two` and nothing else in the sweep catches it.

A pair of laws can pin at most two functions. Beyond that, the corpus of
degenerate submissions is generated from the task itself, one function at a
time, so it follows the task rather than needing to be hand-written.

## Pinning is not the same as determining

Ruling out the argument-ignoring bodies is necessary and not sufficient. A law
set can pin a function on some inputs and leave it free on the rest:
`t3-absdiff-comm`'s first four laws fix `absdiff` on both axes and on the
diagonal, and a person found a body that agrees there and is wrong everywhere
else. That hole was closed by hand. The question is whether any others exist.

V2 was supposed to answer it, and could not. It counts a mutant as caught when
the mutant fails the *reference proof*, and a proof can fail on a body the laws
accept: one that rewrites a subterm the reference body *is* cannot be replayed
on any other body. A policy writes its own proof, so that kill is not a kill.

`gavel/ground.py` asks the question without a proof. It instantiates every law
at small closed values (Nats up to 3, lists up to length 3, prelude trees to
depth 2, at most 48 instances a law), evaluates both sides with the checker's
own evaluator in one run, and compares the functions the laws cite against the
reference at the same points. A candidate that satisfies every instance and
still disagrees with the reference is a **hole**, reported with the input it
disagrees on. V6 runs it over each task's shipped mutants and degenerate
bodies, and `tools/holes.py` also tries every mutant `tools/mutate.py` can
derive.

The first sweep found 10 holes in 7 tasks, every one of them a shipped mutant
whose comment named the law that supposedly rejected it:

- `t2-{count,max,sq,sum,zeros}-prefix-laws`: the laws fixed `f(n, xs)` at
  `n = 0`, at `n = len(xs)` and on `Nil{}`, so `f(1n + k, xs) = <the whole
  list's answer>` passed. Closed by a step law, `f(1n + k, h <> t) == ...`.
- `t3-concat-len`: two measures and the one-piece case left the order of the
  pieces free. Closed by `concat_cons`.
- `t3-isort-perm`: counts and two-element lists left `isort` free on lists of
  three. Closed by `insert_before`, `insert_after` and `isort_cons`.

Two of them were then proved outright against the old laws, in different
tokens from the shipped mutant so the tripwire would not withhold the reward:
`sum_prefix` answering `P.sum(xs)` for every nonzero count, and an `isort` that
never sorts its tail, each **earned reward 1.000**. Both are in `tests/holes/`,
and `tests/test_ground.py` pins that they no longer do.

A clean screen is a bounded claim: no instance outside the grid was tried, and
the candidates are only as varied as the mutation rules. It cannot read a law
whose binder type it has no values for, and says so as a V6 warning rather
than passing it.
