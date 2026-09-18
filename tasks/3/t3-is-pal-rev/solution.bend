import Base
import ./prelude.bend as P

# TODO(policy): `True{}` exactly when `xs` reads the same backwards, which is to
# say when it equals its own reverse under the prelude's element-wise equality.
def is_pal(+xs: List<&2, Nat>) -> Bool:
  ?TODO
