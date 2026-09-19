# Reward

`gavel/reward.py` is a pure function. No I/O, no clock, no model. That is what
makes it property-testable and what keeps old trajectories reproducible after
the harness changes.

## Tiers

| tier | name | condition | reward |
|------|------|-----------|--------|
| 0 | rejected | the gate refused the submission | 0.0 |
| 1 | no-check | the solution is not a well-typed program | 0.0 |
| 2 | checks | it type-checks and no law is proven | 0.1 |
| 3 | partial | a strict subset of laws proven | 0.1 + 0.5 * proven/total |
| 4 | complete | every law proven | 1.0 |

Tiers 0 and 1 both pay nothing but stay distinct, so a training pipeline can
penalise gate failures separately if it wants to.

Tier 2 exists so a policy that produces well-typed but unproven code gets a
non-zero step rather than an all-or-nothing cliff.

## Multi-turn

An episode is up to `max_turns` independent submissions. Nothing carries over
except the feedback text, which is the checker's own words. Bend's terse
errors are the signal a policy learns to repair from, so they are truncated to
a byte budget and otherwise untouched.

In `dense` mode a turn pays the improvement over the best turn so far, so
repair is rewarded and regression is not. In `sparse` mode nothing is paid
until the episode ends.

## The mutant tripwire

Each task ships wrong solutions that its laws are supposed to reject. If a
live submission is byte-identical to one of them and still reaches a proving
tier, the reward is withheld and the verdict records the incident. The tier is
left as computed, because it is the evidence.
