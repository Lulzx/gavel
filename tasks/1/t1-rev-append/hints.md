The reference matches on `xs`: `Nil{}` answers `Nil{}`, and `h <> t` answers
`P.append(reverse(t), h <> Nil{})`, the head going behind the reversed tail.

`rev_nil` closes by `{==}`.

`rev_append` is an induction on `xs`; the `Nil{}` case is `{==}`. In the
`h <> t` case the goal's left side is `reverse(append(t, x <> Nil{}))` inside
the outer `append(_, h <> Nil{})`, while the hypothesis has that same term on
its left and `x <> reverse(t)` on its right, so flip it with `Equal.sym` and
rewrite with the hole where the reverse sat:

    %Equal.sym(List<Nat>, S.reverse(P.append(t, x <> Nil{})), x <> S.reverse(t), L.rev_append(t, x)) : {P.append(_, h <> Nil{}) == x <> P.append(S.reverse(t), h <> Nil{}) : List<Nat>}
    {==}

No `Policy.` lemma is needed.
