# Running episodes

```python
from gavel.cache import VerdictCache
from gavel.env import Action, GavelEnv
from gavel.trajectory import Trajectory

env = GavelEnv.from_manifest("manifest.json", mode="dense", max_turns=4,
                             cache=VerdictCache("cache.sqlite"),
                             trajectory=Trajectory("runs/trajectory.jsonl"))
obs = env.reset("t1-add-plus")
obs, reward, done, info = env.step(
    Action(files={"solution.bend": ..., "PROOF.bend": ...}))
env.close()          # ends any open episode, flushes the log
env.metrics.write("runs/metrics.json")
```

`info` is the full `Verdict`: tier, reward, the laws proven and failed, every
checker run, and the hashes of the task, the toolchain and the submission.

The env is in-process and owns no threads. `gavel serve` wraps the same
`handle` for other stacks over a Unix socket or loopback HTTP, and
`examples/client.ts` is a client in TypeScript.

## The cache

The verdict cache is keyed on everything a verdict is a function of: the
task's bytes, the mutant corpus, the toolchain, the backend, the limits and the
submission. A hit is the verdict a fresh run would have produced, and
`verdict.cached` says it was reused, so anything measuring latency knows to
filter it out.

## The log

One JSON object per episode. A half-written final line is skipped rather than
fatal. Metrics are derived from the same records the log holds, so a run
watched live and the same run read back afterwards cannot disagree.

## The soak

`tools/soak.py` drives the loop unattended with a scripted policy standing in
for a model, so what it exercises is the harness. Each episode's task and
script come from `Random(seed + index)`, so the same seed produces the same
episodes at any `--jobs`. `--policy noisy` marks each submission so no two are
byte-identical and the latency percentiles are the checker's. `--policy
scripted` re-sends identical bytes and measures the cache instead. At the end
it reads its own log back and checks it against the report it produced while
running.

The last ten-thousand-episode soak reported p99 check latency of 524 ms, zero
incidents and zero replay disagreements.
