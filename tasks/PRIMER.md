# Writing a Gavel submission in Bend 2.0.5

This is shared by every task. A task's own prompt says what to implement and
what each law means; this page says how the files fit together and how the
checker reads them.

## The files

- `LAWS.bend` declares the laws. It is immutable. It imports the prelude as `P`
  and your solution as `S`.
- `prelude.bend` is the task's own vocabulary: types and functions the laws are
  stated in. It is immutable and imported as `P`.
- `solution.bend` is the stub. Fill in every `?TODO` def it declares and keep
  its imports. You may add helpers named `Policy.<name>` and nothing else.
- `PROOF.bend` is yours. It must begin with exactly the header the task gives
  you, and it holds one proof per law.

The solution does not re-export the prelude. A prelude name is always `P.len`
and never `S.len`, in the solution and in the proof. Spelling it `S.len` gets
`expected : a defined name / observed : S.len`, which reads like a proof bug
and is not one.

## A proof per law

Each law `law foo: for x: Nat  for +ys: List<Nat>  {...}` is proved by
`def L.foo(x, ys):` and a body. The def has no signature. Its parameters are the
law's binder names, in order, with any `+` or `-` dropped. A binder whose type
is an equation, `for e: {P.le(x, y) == True{} : Bool}`, is a hypothesis, and
its parameter is a proof of that equation.

The checker reads `PROOF.bend` top to bottom. A proof may use another law,
`L.bar(...)`, only if `L.bar`'s proof comes earlier in the file, and it may
call itself on a structurally smaller argument, which is how induction is
written.

Helpers go under `Policy.`, in either file, with a full signature:

    def Policy.add_zero(n: Nat) -> {n + 0n == n : Nat}:

A helper may cite a law only if the helper is declared after that law's proof.

Credit is per law. A law whose proof checks is credited even when another law's
proof fails, unless its proof depends on that failing law, directly or through
a helper. A law left as `?TODO` proves nothing.

Refused before the checker runs: `@unsafe`, a `def main`, any import other than
the header's, and a def name that is neither a stub target nor `Policy.*`.

## Terms

- `Nat`: literals `0n`, `3n`; patterns `case 0n:` and `case 1n+p:`. `a + b` is
  `Nat.add`, which steps on its **left** argument only.
- `List<Nat>`: `Nil{}` and `h <> t` (cons); `[1n, 2n]` is a literal. Patterns
  `case Nil{}:` and `case h <> t:`.
- `Bool`: `True{}` and `False{}`. A bare `True` is a type error.
- A prelude type's constructor is spelled with the module: `P.Bin{l, k, r}`.
- `match x:` with one `case` per constructor. `match a b:` takes two at once,
  with cases like `case 0n 1n+q:`, and its scrutinees must be parameters in
  the order they are bound.

Base has `Nat.add`, `Nat.sub`, `Nat.mul`, `Bool.and`, `Bool.or`, `Bool.not`,
and `List.*`. Run-of-the-mill facts are not definitional: `a + 0n == a`,
`a + (1n + b) == 1n + (a + b)` and `a + b == b + a` are each an induction on
`a`, because `+` cannot step on a variable left argument.

## What the checker enforces

- **A `match` cannot scrutinise a computed value.** `match P.le(k, h):` is
  refused. Give the decision its own def and pass it as a parameter.
- **Recursion must decrease.** Every self-call must pass a structurally smaller
  argument, read left to right. Two defs may not call each other.
- **Variables are used once.** A variable is Lone by default: usable live once
  per branch. Using it twice is `expected : x / observed : x (consumed more than
  once)`. Mark a parameter `+x` to make it reusable. A pattern variable needed
  twice is rebound first: `+p = p`. A `-x` parameter is erased: it may appear
  in types and rewrite motives, never in the computation. Uses inside a
  rewrite motive are free.

## Equality and rewriting

`{a == b : T}` is a type. `{==}` proves it when both sides are the same term
after reduction, and only then.

`%e : M` rewrites with `e : {A == B : T}`. `M` is the goal written out with a
`_` where `B` sits. The current goal must be `M` with `B` in the hole, and the
step leaves `M` with `A` in the hole. In other words, a rewrite replaces the
**right** side of `e` by its **left** side. To replace `O` by `R`, you need a
proof of `{R == O}`. If your lemma says `{O == R}`, flip it with
`Equal.sym(T, O, R, lemma)`. A motive whose hole is not where `B` sits is
rejected with `expected`/`observed` about the hole's type, which reads like a
bug in the lemma and is not one.

Write `M` with both sides reduced as far as they go. After the last rewrite,
close the goal with `{==}`:

    case h <> t:
      %L.sum_len(t) : {h + S.f(t) == h + _ : Nat}
      {==}

Also in Base: `Equal.trans(T, a, b, c, ab, bc)` and
`Equal.cong(A, B, f, a, b, e)`.

## Reward

0.0 if the gate refuses the submission or the solution does not type-check;
0.1 if it type-checks and no law is proven; `0.1 + 0.5 * proven/total` for some
laws; 1.0 for all of them. When an episode allows more than one turn, the
checker's error text comes back as feedback.
