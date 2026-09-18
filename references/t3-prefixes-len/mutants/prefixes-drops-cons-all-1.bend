import Base
import ./prelude.bend as P

# Enumerates the tail's prefixes unchanged instead of putting the head on the
# front of every one of them. This is the body the step law names: `prefixes_cons`
# rejects it, wanting `P.cons_all(h, S.prefixes(t))` where this computes to
# `S.prefixes(t)`. The count is the same -- `cons_all` does not change how many
# prefixes there are -- so the length law is *true* of this body as arithmetic,
# and the reference proof still fails against it, because that induction is built
# around the `cons_all` lemma and this body has no `cons_all` to rewrite.
def prefixes(xs: List<&2, Nat>) -> P.Prefixes:
  match xs:
    case Nil{}:
      P.PCons{Nil{}, P.PNil{}}
    case h <> t:
      P.PCons{Nil{}, prefixes(t)}
