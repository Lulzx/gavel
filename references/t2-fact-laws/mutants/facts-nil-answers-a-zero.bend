import Base

# `facts(Nil{})` answers `0n <> Nil{}` -- one element, `0n` -- instead of
# `Nil{}`; everything else is the reference.
#
# Hand-written, and the second of the two base cases the generator cannot move
# on its own. The interesting thing about it is that it fails *two* laws and
# that is not avoidable: `facts_nil` is a statement about the empty list and
# `facts_len` is a statement about every list, so any body that answers the
# empty list wrongly is a body whose length is wrong there too. `1` is not `0`.
#
# `fact_zero` and `fact_succ` are untouched, and `facts_cons` is untouched too,
# because `facts` still maps a cons cell the way the reference does -- the
# difference is confined to the arm the cons case never reaches.
def fact(n: Nat) -> Nat:
  match n:
    case 0n:
      1n
    case 1n++p:
      Nat.mul(1n+p, fact(p))

def facts(xs: List<&2, Nat>) -> List<&2, Nat>:
  match xs:
    case Nil{}:
      0n <> Nil{}
    case +h <> +t:
      fact(h) <> facts(t)
