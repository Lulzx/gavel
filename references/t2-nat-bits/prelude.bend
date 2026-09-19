import Base

# How many elements a bit list has. The laws need the length of the list the
# solution builds and nothing else about it; `List.length` in `Base` wants the
# element kind spelled out, which is noise in a law statement.
def len(bs: List<&2, Nat>) -> Nat:
  match bs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)
