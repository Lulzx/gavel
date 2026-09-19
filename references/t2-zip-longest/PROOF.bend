import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L

# The list is the literal `Nil{}`, the arm the walk stops at.
def L.zl_pad_left_nil(d):
  {==}

# The head and tail come off the pattern, so both sides are the padded pair in
# front of the walk on the tail.
def L.zl_pad_left_cons(h, t, d):
  {==}

# The mirror of the first law: the list is the literal `Nil{}`.
def L.zl_pad_right_nil(d):
  {==}

# The mirror of the second: the padded pair goes in front of the walk on the
# tail, with the components the other way round.
def L.zl_pad_right_cons(h, t, d):
  {==}

# Both lists are literals, so the outer match takes its nil arm and the walk it
# hands to takes its own nil arm.
def L.zip_longest_nil_nil(d):
  {==}

# Both lists are conses, so the outer match steps and the inner match steps, and
# both sides are the packed heads in front of the walk on the two tails.
def L.zip_longest_cons_cons(hx, tx, hy, ty, d):
  {==}

# The first list is a literal `Nil{}`, so the outer match takes its nil arm at
# once; the second is a cons, so the walk it hands to steps.
def L.zip_longest_nil_cons(h, t, d):
  {==}

# The first list is a cons, so the outer match steps; the second is a literal
# `Nil{}`, which is the inner match's nil arm.
def L.zip_longest_cons_nil(h, t, d):
  {==}

# Numerals on both sides, so the checker walks the two lists out.
def L.zip_longest_equal_lengths():
  {==}

# Numerals on both sides, so the checker walks the two lists out.
def L.zip_longest_pads_the_right():
  {==}

# Numerals on both sides, so the checker walks the two lists out.
def L.zip_longest_pads_the_left():
  {==}
