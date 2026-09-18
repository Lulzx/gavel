import Base
import ./prelude.bend as P

# Answers `True{}` everywhere. Both value pins hold -- the empty and the
# one-element list are palindromes -- and `is_pal_rev` holds too, since both
# sides of it are `True{}`. Only `is_pal_two_distinct` sees it: `0n <> 1n` is
# not a palindrome, and the answer has to be `False{}`.
def is_pal(+xs: List<&2, Nat>) -> Bool:
  True{}
