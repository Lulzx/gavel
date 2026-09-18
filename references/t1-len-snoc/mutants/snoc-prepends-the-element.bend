import Base

# `snoc` puts the element on the left instead of the right. Every law in the old
# set was about lengths, and `x <> xs` has the same length as `snoc(xs, x)`, so
# this body proved `len_single` and `len_snoc` at tier 4, reward 1.000 -- `len`
# is anchored by `len_single`, `snoc` was not observed at all.
# Measured: before `snoc_cons`, tier 4, reward 1.000; after, tier 3, two of
# three laws proven (0.433 by the tier-3 formula), failing at `LAWS.snoc_cons` --
# the law's two sides differ on which side `x` lands.
#
# The same body is caught in `t1-rev-snoc`, whose law observes which side `x`
# landed on; a length-only set cannot see a placement.
def len(xs: List<Nat>) -> Nat:
  match xs:
    case Nil{}:
      0n
    case h <> t:
      1n + len(t)

def snoc(xs: List<Nat>, x: Nat) -> List<Nat>:
  x <> xs
