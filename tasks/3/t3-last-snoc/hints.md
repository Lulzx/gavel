The reference answers `d` on `Nil{}` and `last(t, h)` on `h <> t`: the head
becomes the new default on the way down.

- `last_nil` and `last_cons`: both sides compute, so `{==}`.
- `last_snoc`: the direct induction on `xs` does not go through. In the step
  `a <> b` the goal unfolds to `S.last(P.snoc(b, h), a) == h`, with the head `a`
  as the default, while the hypothesis is about the original default `d`. So
  generalize over the default in a `Policy.` lemma:

      def Policy.last_snoc_general(+xs: List<&2, Nat>, h: Nat, d: Nat)
          -> {S.last(P.snoc(xs, h), d) == h : Nat}:

  by induction on `xs`: `Nil{}` closes by `{==}`, and the cons case rewrites
  with the lemma at `(b, h, a)`:

      %Policy.last_snoc_general(b, h, a) : {S.last(P.snoc(b, h), a) == _ : Nat}
      {==}

  The law is then one rewrite with the lemma at `(xs, h, d)` and `{==}`.
  `xs` is `+` because the tail is used twice in the step.
