The reference matches on `xs`: `Nil{}` answers `x <> Nil{}`, and `h <> t`
answers `h <> snoc(t, x)`.

`rev_snoc` is an induction on `xs`; the `Nil{}` case is `{==}`. In the `h <> t`
case the goal's left side reduces to `P.append(P.reverse(S.snoc(t, x)), h <>
Nil{})`. The hypothesis has `P.reverse(S.snoc(t, x))` on its left, which is
where the goal has it, so flip it with `Equal.sym` and rewrite with the hole
where that reverse sat:

    %Equal.sym(List<Nat>, P.reverse(S.snoc(t, x)), x <> P.reverse(t), L.rev_snoc(t, x)) : {P.append(_, h <> Nil{}) == x <> P.append(P.reverse(t), h <> Nil{}) : List<Nat>}
    {==}

No `Policy.` lemma is needed.
