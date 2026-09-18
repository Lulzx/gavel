import Base

# Wrong: `snoc` puts the element at the front instead of the back -- the same
# length, a different list. The law observes which side `x` landed on, so it
# rules this out; a law set that only measured the length would not.
def snoc(xs: List<Nat>, x: Nat) -> List<Nat>:
  x <> xs
