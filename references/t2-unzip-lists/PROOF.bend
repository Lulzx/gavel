import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def L.unzip_nil():
  {==}

def L.unzip_cons_fst(a, b, t):
  {==}

def L.unzip_cons_snd(a, b, t):
  {==}

def L.unzip_len_fst(ps):
  match ps:
    case Nil{}:
      {==}
    case h <> t:
      %L.unzip_len_fst(t) : {1n + P.llen(P.zfst(S.unzip(t))) == 1n + _ : Nat}
      {==}

def L.unzip_len_snd(ps):
  match ps:
    case Nil{}:
      {==}
    case h <> t:
      %L.unzip_len_snd(t) : {1n + P.llen(P.zsnd(S.unzip(t))) == 1n + _ : Nat}
      {==}
