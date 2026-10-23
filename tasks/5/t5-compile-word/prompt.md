Implement `compile` and `exec`, then prove the four laws in `LAWS.bend`.

The source language is the prelude's `P.Expr`, a description of a word (a list
of `Nat`): `P.Empty{}` is the empty word, `P.Sym{n}` the one-symbol word `[n]`,
and `P.Cat{a, b}` the word of `a` followed by the word of `b`. A program is a
`List<&2, P.Op>`, and the only instruction is `P.Emit{n}`, which puts `n` on
the end of the machine's word.

`compile(e)` is the program that emits the symbols of `e` in order, one
`P.Emit{n}` per symbol: nothing for `P.Empty{}`, `[P.Emit{n}]` for
`P.Sym{n}`, and the program for `a` followed by the program for `b` for
`P.Cat{a, b}`.

`exec(prog, w)` runs `prog` starting from the word `w` and returns the final
word: `w` with the number of each instruction appended, in program order. The
empty program returns `w`.

    compile(P.Cat{P.Sym{1n}, P.Cat{P.Empty{}, P.Sym{2n}}}) == [P.Emit{1n}, P.Emit{2n}]
    exec([P.Emit{3n}, P.Emit{4n}], [1n]) == [1n, 3n, 4n]
    exec(Nil{}, [5n]) == [5n]

Prelude names: `P.eval(e)` is the word `e` describes, and it is the
specification `compile` is judged against. `P.glue(xs, ys)` concatenates two
words and `P.splice(p, q)` two programs (`<>` is the list constructor, not
append).

- `exec_nil`: running the empty program leaves the word unchanged.
- `exec_emit`: running the one-instruction program `[P.Emit{n}]` from `w`
  gives `w` with `n` appended.
- `exec_splice`: running `P.splice(p, q)` from `w` is running `p` from `w` and
  then `q` from the word that produced.
- `exec_compile`: running `compile(e)` from `w` gives `w` followed by
  `P.eval(e)`.
