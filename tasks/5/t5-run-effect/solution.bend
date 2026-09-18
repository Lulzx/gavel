import Base
import ./prelude.bend as P

# TODO(policy): one step of the machine -- `s` with the instruction `i` applied.
# The accumulator is the first parameter because `run` folds the program from
# the left, handing the result of one step to the next.
def step(s: Nat, i: P.Instr) -> Nat:
  ?TODO

# TODO(policy): the accumulator after running `prog` from `s`. A program is read
# left to right, so the first instruction is applied first.
def run(prog: List<&2, P.Instr>, s: Nat) -> Nat:
  ?TODO

# TODO(policy): what the program does to the accumulator, computed without
# running it. This is the summary the law claims `run` agrees with, so it has to
# be a recursion over the program text and not a call to `run`.
def effect(prog: List<&2, P.Instr>) -> Nat:
  ?TODO
