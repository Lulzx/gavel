import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

def L.exec_nil(s):
  {==}

def L.exec_zero(t, s):
  {==}

def L.exec_inc(t, s):
  {==}

def L.exec_twice(t, s):
  {==}

def Policy.clean_opt(p: List<&2, P.Op>, +z: Bool) -> {P.clean(S.opt(p, z), z) == True{} : Bool}:
  match p:
    case Nil{}:
      {==}
    case P.Zero{} <> t:
      Policy.clean_opt(t, True{})
    case P.Twice{} <> t:
      match z:
        case True{}:
          Policy.clean_opt(t, True{})
        case False{}:
          Policy.clean_opt(t, False{})
    case P.Inc{} <> t:
      Policy.clean_opt(t, False{})

def L.clean_opt(p, z):
  Policy.clean_opt(p, z)

def Policy.state(z: Bool, +s: Nat) -> Nat:
  match z:
    case True{}:
      0n
    case False{}:
      s

def Policy.ok(p: List<&2, P.Op>, +z: Bool, +s: Nat) -> {S.exec(S.opt(p, z), Policy.state(z, s)) == S.exec(p, Policy.state(z, s)) : Nat}:
  match p:
    case Nil{}:
      {==}
    case P.Zero{} <> t:
      Policy.ok(t, True{}, s)
    case P.Inc{} <> t:
      Policy.ok(t, False{}, 1n + Policy.state(z, s))
    case P.Twice{} <> t:
      match z:
        case True{}:
          Policy.ok(t, True{}, s)
        case False{}:
          Policy.ok(t, False{}, s + s)

def L.opt_sound(p, s):
  Policy.ok(p, False{}, s)

def L.opt_sound_zero(p):
  Policy.ok(p, True{}, 0n)

# The `Zero` branch is `opt`'s own body read back: on `P.Zero{} <> t` the body
# ignores the flag it was handed and answers `P.Zero{} <> opt(t, True{})`.
def L.opt_zero(t, z):
  {==}

# The drop is `opt`'s own body read back: on `P.Twice{} <> t` under a zero claim
# the body answers `opt(t, True{})` and nothing else.
def L.opt_twice_zero(t):
  {==}
