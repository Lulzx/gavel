import Base
import ./prelude.bend as P

# The zero case, with the filler prepended instead of the input returned whole.
#
# This body is here because of a measurement rather than an intuition. Reading
# `pad_nil`'s kill count -- the number of type-checking mutants whose verdict
# lists it as unproven -- the law came out at **0** over this corpus: the nine
# mutants that type-check all alter the step or the count, and the eight that
# fail `pad_nil` fail it by failing to type-check, which is not evidence about a
# law (V2's own reason for not counting them). A law no mutant fails is
# invisible to V2, which asks only that the corpus be non-empty, that some
# mutant type-check, and that none escape.
#
# `pad_nil` is `pad(0n, x, xs) == xs`. The reference reaches it by matching on
# `n` first and answering `xs` at zero, so the case is one match arm away from
# every generated rule and no rule lands on it. Prepend the filler and the law
# is false for every `x` and `xs`.
#
# Measured 2026-09-19 against the five-law set: **tier 3, three laws
# unproven** -- `pad_nil` (`expected x <> xs` against `observed xs`), `pad_len`
# (one longer than the target at zero), and `pad_single`, which the `1n` case
# reaches through the zero case below it (`[x, x]` against `[x]`). The reward
# reads 0.000 rather than the 0.300 the tier-3 formula gives, because the
# tripwire has this file in the corpus -- SPEC 7.4.2, a submission identical to
# a shipped mutant and the tier stands as evidence. Bare, with no proof: tier 2,
# so the mutant reaches the laws rather than failing to type-check first.
def pad(n: Nat, +x: Nat, xs: List<Nat>) -> List<Nat>:
  match n:
    case 0n:
      x <> xs
    case 1n+k:
      match xs:
        case Nil{}:
          x <> pad(k, x, Nil{})
        case h <> t:
          h <> pad(k, x, t)
