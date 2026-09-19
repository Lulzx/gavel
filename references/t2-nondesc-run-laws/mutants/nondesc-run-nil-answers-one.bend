import Base
import ./prelude.bend as P

# `nondesc_run` answers `1n` on the empty input.
#
# This file exists for a law no generated mutant fails: every rule in
# `tools/mutate.py` rewrites a step, and the empty case is an answer the walk has
# already stopped at. It is the reference with the `Nil{}` branch given a
# non-zero answer, so it type-checks and every recursive step is untouched.
#
# Measured 2026-09-19 against this task's law set: tier 3, failing
# `nondesc_run_nil` alone -- `nondesc_run_single`, `nondesc_run_up`,
# `nondesc_run_down` and `nondesc_run_le_len` all still check. The first
# measurement read tier 2 with every law failed, because `nondesc_run_le_len`
# was then stated over a bare `xs` and its induction base reduced to
# `P.le(nondesc_run(Nil{}), P.len(Nil{}))`; the empty answer was load-bearing
# for it, so no killer of `nondesc_run_nil` could leave the other laws proven.
# The law now carries its own head (`x <> t`), which is what its induction
# matches on, and the empty answer is out of its reach.
def nondesc_run(xs: List<&2, Nat>) -> Nat:
  match xs:
    case Nil{}:
      1n
    case +x <> +t:
      P.rl_step(x, t, nondesc_run(t))
