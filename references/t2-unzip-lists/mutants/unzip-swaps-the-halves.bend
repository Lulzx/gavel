import Base
import ./prelude.bend as P

# HAND MUTANT. The reference with the two components of every pair sent to the
# other list. It type-checks, it is the same length as the reference, and it
# satisfies every law about lengths -- `unzip_len_fst` and `unzip_len_snd` are
# both true of it -- so the only thing that catches it is that the two cons laws
# say *which* half goes where. Measured 2026-09-19: tier 3, laws_failed
# [unzip_cons_fst, unzip_cons_snd].

def unzip(ps: List<&2, P.Pair>) -> P.ZP:
  match ps:
    case Nil{}:
      P.MkZ{Nil{}, Nil{}}
    case +h <> +t:
      P.MkZ{P.psnd(h) <> P.zfst(unzip(t)), P.pfst(h) <> P.zsnd(unzip(t))}
