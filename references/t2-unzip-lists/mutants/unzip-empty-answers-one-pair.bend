import Base
import ./prelude.bend as P

# HAND MUTANT (base-case rule). The reference with `unzip`'s empty case
# answering a record whose first list already has an element. The law
# `unzip_nil` has a ground left-hand side -- `unzip(Nil{})` -- so it is an
# answer a stopped match gives rather than a step, and the generated mutants
# only rewrite steps. Measured 2026-09-19: tier 3, laws_failed
# [unzip_nil, unzip_len_fst] -- the cons laws still hold, since the extra
# element sits at the end of the first list and every cons law looks at a head.

def unzip(ps: List<&2, P.Pair>) -> P.ZP:
  match ps:
    case Nil{}:
      P.MkZ{0n <> Nil{}, Nil{}}
    case +h <> +t:
      P.MkZ{P.pfst(h) <> P.zfst(unzip(t)), P.psnd(h) <> P.zsnd(unzip(t))}
