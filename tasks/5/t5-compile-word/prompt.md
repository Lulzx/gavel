Implement `compile` and `exec`, then prove all four laws.

The prelude owns the source language (`P.Expr`, with the constructors
`P.Empty{}`, `P.Sym{n}` and `P.Cat{a, b}`), the machine's instruction set
(`P.Op`, whose only constructor is `P.Emit{n}`), the specification `P.eval`, and
the two concatenations `P.glue` (words) and `P.splice` (programs). `<>` in Bend
is the list *constructor*, not append, which is why both concatenations are in
the prelude rather than written inline in the laws.

`compile(e)` turns a description of a word into a program; `exec(prog, w)` runs a
program, starting from the word `w`, and gives back the word it produced. The
machine holds exactly one thing -- the word -- and the only thing an instruction
does is put its number on the end of it.

`P.eval` is **not yours**. It is the specification, and it is what the compiler
is judged against: `exec_compile` says that running a compiled expression
appends that expression's word to the state. Since `eval` is immutable and
cannot be made to agree with a wrong `compile`, this law is the whole of the
compiler's correctness rather than one property of it.

`exec_nil`, `exec_emit` and `exec_splice` are the pins on `exec`. Between them
they fix it completely, and the reason is the shape of a program: every program
is a splice of one-instruction programs, so a body that answers the empty one,
the singleton one, and the concatenation one has nowhere left to hide. The first
two are definitional. `exec_splice` is not, because `splice` matches on a
program it was not handed -- the law has to be taken over an arbitrary program,
and that is what rules out an `exec` that reads only the first instruction.

Note which laws are *not* here, and why. There is no definitional pin for
`compile`, no `compile(P.Empty{}) == Nil{}` and no
`compile(P.Cat{a, b}) == P.splice(compile(a), compile(b))`. Each would be a
restatement of a body, and each is already implied by `exec_compile`: a compiler
that emitted a stray instruction for the empty expression, or that emitted the
two halves of a concatenation in the wrong order, is caught by the theorem
because `eval` reads the halves in order. `exec_compile` is also why `compile`
does not need to be pinned separately to be *determined* -- a program is
identified by what running it does, and the law says what running this one does.

Two things about the shape of the work. `exec_splice` has to be proved by
induction on the program, and it is the hypothesis that carries the state
through: the second piece must be run at the word the first piece produced, not
at the word the machine started with, so the induction is taken at an arbitrary
state. And a rewrite `%e : P` is the J axiom, not a tactic: the `_` in `P` marks
the position at which the evidence's *right* endpoint sits in the current goal,
and the goal you are left with has the evidence's *left* endpoint there.
`exec_compile`'s `Cat` case needs four rewrites in a row, and three of them are
`Equal.sym` of a hypothesis, because the term to be replaced is the one on the
*left* of the evidence.

Write the implementation in `solution.bend` and the proofs in `PROOF.bend`, as
`def L.exec_nil(w)`, `def L.exec_emit(n, w)`, `def L.exec_splice(p, q, w)` and
`def L.exec_compile(e, w)`. Proof helpers go under the reserved `Policy.`
namespace, which the gate ignores, and none of them may cite a law.
