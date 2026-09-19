import Base
import ./prelude.bend as P

# TODO(policy): implement. `run_lengths(xs)` is the list of the lengths of the
# maximal runs of equal elements of `xs`, in the order the runs appear, so it
# holds one cell per run and not one per element:
#
#   run_lengths([1n, 1n, 2n])  ==  2n <> (1n <> Nil{})
#   run_lengths([1n, 2n, 2n])  ==  1n <> (2n <> Nil{})
#   run_lengths([3n])          ==  1n <> Nil{}
#   run_lengths(Nil{})         ==  Nil{}
#
# An empty list has no runs, and a singleton is one run of one element. Longer
# lists are handled by the walk below.
def run_lengths(xs: List<&2, Nat>) -> List<&2, Nat>:
  ?TODO

# TODO(policy): implement. `run_lengths_go(t, cont, cur, h)` walks `t` carrying
# the length `cur` that the current run has reached and the element `h` it
# reached it with; `cont` says whether `h` was in that run at all. The element in
# hand is the head of `t`, and the comparison that decides whether it joins the
# run is against `h`, which is why the step cannot be a `match` on `P.same`: a
# `match` cannot scrutinise a value it computed, so the decision is made where
# both elements are in hand -- look one element further into `t` -- and passed to
# the recursion as an argument.
#
# `t` comes first because the checker reads a recursive call's arguments left to
# right and asks that each be passed on unchanged until one shrinks: the tail is
# the argument that carries the recursion, so it is the one that has to be
# handed to the call first.
#
# The run is emitted when the element in hand starts a new one, or when the list
# ends. `cur` is read twice in a step that emits it -- once as the run's length
# and once where the next run starts from -- so on those paths it is declared
# reusable: `+cur` in the reference.
def run_lengths_go(t: List<&2, Nat>, cont: Bool, cur: Nat, h: Nat) -> List<&2, Nat>:
  ?TODO
