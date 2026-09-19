import Base
import ./prelude.bend as P
import ./solution.bend as S

# LAW: the product of nothing is one. The constant body `1n` satisfies it.
law fact_zero:
  {S.fact(0n) == 1n : Nat}

# LAW: a successor argument is that successor times the factorial of its
# predecessor. This is the law that pins `fact` at a variable argument; every
# other law about `fact` here is closed, so a body that is right at `0n` and
# answers something constant above it satisfies all of them.
law fact_succ:
  for n: Nat
  {S.fact(1n + n) == Nat.mul(1n + n, S.fact(n)) : Nat}

# LAW: nothing has no factorials. The constant body `Nil{}` satisfies it, and
# together with `facts_cons` it is what fixes the shape of the result.
law facts_nil:
  {S.facts(Nil{}) == Nil{} : List<&2, Nat>}

# LAW: a cons cell maps over as the factorial of its head and the factorials of
# its tail.
law facts_cons:
  for x: Nat
  for xs: List<&2, Nat>
  {S.facts(x <> xs) == S.fact(x) <> S.facts(xs) : List<&2, Nat>}

# LAW: mapping leaves the length alone. This one is not the reference's own
# unfolding: `xs` is a variable, so `P.len(S.facts(xs))` does not reduce and
# neither does `P.len(xs)`, and the goal is only closable by induction on `xs`.
# Every other law here can be discharged by reducing both sides, which is why
# this law is the one that makes the set an obligation rather than a restatement
# of the definitions.
law facts_len:
  for xs: List<&2, Nat>
  {P.len(S.facts(xs)) == P.len(xs) : Nat}
