# Gavel — Build Plan

Companion to `SPEC.md`. This plan is grounded in experiments run against the
locally installed checker on 2026-09-18. Where the spec and the real checker
disagree, the checker wins and the deviation is recorded in §1.

## 0. Environment facts (measured, not assumed)

| Fact | Value |
|---|---|
| Installed Bend | 2.0.5 (auto-updated from 2.0.4 during the probe session; 2.0.3 also present) |
| Checker implementation | TypeScript, run as `bun ~/.bend/app/<ver>/<id>/bend2/main.ts file.bend` |
| Files that constitute a version | `bend2/{main.ts, bend.ts, comp.ts, base.bend, effs/}` |
| bun | 1.3.14 at `~/.bun/bin/bun` |
| Cold check of a 2-law inductive proof | 0.18–0.24 s wall (bun startup dominates) |
| Success signal | exit 0 **and** stdout `All terms check.` |
| Open law / `?TODO` | exit 1, `Error: N TODOs found.` |
| Type error | exit 1, `expected/observed` block with `Location: LAWS.<law>` |

Observed checker behaviors that shape the design:

1. **`@unsafe` exits 0 — but only when the term is otherwise well-typed.** Output is a warning (`1 term annotated as unsafe. The code is well-typed, but may contain logical paradoxes.`). Exit code alone is not a reward signal. *Amended in M0:* `@unsafe` switches off the descent checker, not the type checker, so `@unsafe def L.add_zero(x): {==}` against an incomplete solution still fails with exit 1. The exploit that actually pays out is a **self-referential def**, which inhabits its own goal type once termination checking is off:
   ```
   @unsafe
   def L.add_zero(x):
     L.add_zero(x)
   ```
   Measured: exit 0, stdout `1 term annotated as unsafe.` — a "proof" of `x + 0 = x` that proves nothing. Reproduced as a test in `tests/test_checker.py`.
2. **`main` in a submitted file runs.** IO side effects execute during "checking". `main` must be a forbidden name.
3. **Open laws cannot be used as axioms.** The checker rejects `Policy.magic(x)` where `Policy.magic` is an unfilled law: "an unfilled law is a dead claim: live code cannot use it". This makes per-law isolation runs sound (see §3.4).
4. **Duplicate top-level names are rejected** across files ("a fresh name (duplicate declaration: code.add)"). Redefining a prelude def in the proof file fails at parse time.
5. **A law-filling def cannot carry its own signature.** `def Laws.add_zero(x: Nat) -> ...:` is a parse error, so the policy cannot retype a law.
6. **Redeclaring a `law` in PROOF.bend does not override the original.** The gate still forbids `law` in submissions to keep the attack surface small.
7. **Module names are file basenames, globally.** In `PROOF.bend`, the solution is addressed as `solution.sort`, or via a local alias if `PROOF.bend` imports the file itself. Aliases from `LAWS.bend` are *not* visible in `PROOF.bend`.
8. **The checker reports the first type error only**, skipping `?TODO`s. One run cannot attribute pass/fail per law.
9. **`import 0x<hash>/...` fetches from `BEND_HUB` over the network**; `import "./x.c"` declares a foreign effect. Both are gate-forbidden and the sandbox blocks network regardless.
10. **The `bend` launcher phones home and self-updates** on every run unless `BEND_NO_TELEMETRY=1`. Gavel never calls the launcher; it calls `bun main.ts` on a vendored copy.
11. **The hole syntax is `?TODO`**, not `???` as written in the spec.
12. `bend base List` has no `is_sorted` / `is_perm`; tasks ship their own predicates in a prelude.

Added while implementing M0, each with a test in `tests/`:

13. **`@unsafe` is three tokens, and only a `def` may carry it.** `parse_def` (bend.ts:2540) takes `"@"`, then the word `unsafe`, then requires `def`. A scan that looks for the two-token `@unsafe` — or that computes the flag once and reuses it across declarations — silently misses it. Both mistakes were made and caught here; `test_unsafe_does_not_leak_to_a_later_declaration` is the regression.
14. **TODO counts are on stderr, not stdout**, contradicting the reading of §3.4 below. `Error: N TODOs found.` (main.ts:434).
15. **`RLIMIT_NPROC` is a per-*user* limit and must not be set to a constant.** With a cap of 64 and 447 processes already belonging to the user, every check failed at fork with `Resource temporarily unavailable`. Bend cannot spawn processes, so this was never the boundary that mattered; the wall clock, the memory ceiling, and the Linux sandbox are. `Limits.nproc` now defaults to `None`.
16. **The "`@unsafe` hangs the checker" observation from the probe session did not reproduce.** `@unsafe` with a self-call returns in ~200 ms (it is type-checked, not evaluated); forcing evaluation through a rewrite produces a type error, not a hang. The wall clock stays, but as defence against a checker bug we have not characterised rather than against a reproduced input — and it is tested against a stand-in that provably does not return, so the mechanism is covered regardless of what 2.0.5 does.
17. **A law does not have to determine the function it is about, and the obvious laws do not.** `law add_zero: for x: Nat {S.add(x, 0n) == x : Nat}` is satisfied by the projection `def add(a, b) = a`, proved with `{==}` — verified at exit 0 against the pinned checker. The same holds for any right-identity law (`f(x, e) == x`), any base-case law (`f(0n) == 0n` is satisfied by `f = 0n`), and `bool_not_not` (`not(b) = b` is an involution). This invalidates the tier-1 examples in §4 M0 item 7 and, more importantly, any law authored by the obvious method.

    The rule that replaces it: **a law pins its function only if both sides depend on the arguments.** The inductive equation does — `add_succ(x, 1n+y) == 1n+S.add(x, y)` rules out the projection, `len_cons(x <> xs) == 1n+len(xs)` rules out the constant. Hence the bank's shape is **tier 1 = the inductive law alone; tier 2 = a weak base law plus the inductive law**, where the second rules out what the first permits.

    This is only visible when a degenerate *solution* is crossed with a degenerate *proof*. V2 as originally specified holds the proof fixed and mutates the solution, which asks whether the reference proof is brittle and says nothing about whether the laws constrain anything. `gavel/degenerate.py` now emits the cross product, and V3 fails a task if any combination reaches tier 4. `t1-add-zero` was authored the obvious way, was caught by this, and has been retired in favour of `t1-add-succ`.
18. **Bend's binders are affine: each may be consumed at most once**, and the match scrutinee counts as consumed. `match a:` then `add(p, a)` in a case body is rejected ("`p` consumed more than once") — so the common mutation "replace a recursive argument with an earlier parameter" usually fails *linearity* rather than type-checking. Similarly a self-call's decreasing argument must be leftmost: `add(b, p)` is refused by the descent checker ("expected a decreasing self-call"). Both make the mutant corpus thinner than the rule list suggests, and both are why V2 measures strength by type-checking the mutant on its own rather than by its tier against the reference proof.

**Latency.** Re-measured at 187–297 ms per check, consistent with the figure above. Earlier readings of 0.49–0.69 s were taken at load averages of 49–119 on this machine (Chrome and node processes, not Gavel's) and should not be used to revise the figure. `gavel bench` reports the distribution; run it on an idle box before quoting a number.

## 1. Deviations from SPEC.md

| Spec | Plan | Reason |
|---|---|---|
| Success = nonzero exit is failure (§7.3) | Success = exit 0 ∧ stdout == `All terms check.` ∧ no `annotated as unsafe` line | Fact 1 |
| `stub.bend` holds immutable helpers + holes (§5.3) | Split into `prelude.bend` (immutable, laws' predicates) and `solution.bend` (policy-owned, holes as `?TODO`) | Facts 4, 7, 11; makes integrity a file hash instead of a region diff |
| Forbidden list (§7.2) | Add: `main`, `law`, `import "<string>"`, `import 0x…`, `?TODO`/`?name` in credited proofs (they fail anyway), `do IO` | Facts 2, 3, 9 |
| `bend PROOF.bend` once per turn (§7.3) | Full run first; on failure, a solution-only run and then per-law isolation runs to a fixed point | Fact 8 |
| Pin by "version and installer commit" (§14) | Pin by sha256 of the vendored `bend2/` tree + bun version; recorded in `manifest.json` and every verdict | Fact 10 |
| Container per version (§9) | Linux: bubblewrap/nsjail profile around `bun`; macOS dev: subprocess with scrubbed env, `BEND_HUB=http://127.0.0.1:9`, rlimits, timeout | Bend is a bun script, not a binary; a full image is M1, not M0 |

## 2. Repository layout

```
gavel/
  SPEC.md  PLAN.md  README.md
  pyproject.toml                 # uv, python >= 3.12, no runtime deps beyond stdlib for the core
  toolchain/
    2.0.5/                       # vendored bend2/ tree (main.ts, bend.ts, comp.ts, base.bend, effs/)
    2.0.5.sha256                 # tree hash; checked at harness start
    bun.version                  # pinned bun version string
    fetch.py                     # pulls a release tarball, verifies sha, vendors it
  gavel/
    __init__.py
    toolchain.py                 # locate + verify pinned checker; build the argv
    runner.py                    # run one check: tmp dir, env scrub, timeout, rlimits, parse output
    lexer.py                     # tokenizer ported from bend.ts (parse_* rules), version-tagged
    gate.py                      # static gate: forbidden constructs, namespace, size, integrity
    laws.py                      # parse LAWS.bend: law names, proof-def names, dependency scan
    verdict.py                   # dataclasses: GateFinding, CheckResult, Verdict
    reward.py                    # pure tier/reward function (spec §8)
    tasks.py                     # Task, load by manifest, hashing, working-dir materialization
    check.py                     # full run → solution run → per-law fixed point; returns Verdict
    env.py                       # GavelEnv: reset / step / close, dense/sparse, multi-turn
    cache.py                     # (toolchain_hash, task_hash, submission_hash) -> Verdict, sqlite
    trajectory.py                # JSONL writer (spec §13.1)
    metrics.py                   # counters + latency histograms, exported as JSON
    server.py                    # JSON-lines over Unix socket / HTTP (M3)
    cli.py                       # `gavel check`, `gavel validate`, `gavel run`, `gavel bench`
  tasks/                         # public bank: tasks/<tier>/<id>/{prompt.md, LAWS.bend, prelude.bend, solution.bend, meta.json}
  references/                    # hidden: references/<id>/{solution.bend, PROOF.bend, mutants/}
  manifest.json
  tools/                         # authoring pipeline (offline)
    validate.py  mutate.py  degenerate.py  calibrate.py  publish.py  migrate.py
  tests/
    test_lexer.py  test_gate.py  test_check.py  test_reward.py  test_env.py
    adversarial/                 # gate corpus: one file per attack, expected finding
    fixtures/                    # tiny tasks used by tests
```

Python for the harness because the gym API is Python-native and every RL stack
speaks it. The only external process is bun. No Bend knowledge is required on
the caller side (G5).

## 3. Component design

### 3.1 Task format (revised)

```
tasks/<tier>/<id>/
  prompt.md
  LAWS.bend        # import Base; import ./prelude.bend as P; import ./solution.bend as S; laws
  prelude.bend     # immutable predicates and helpers, e.g. P.is_sorted
  solution.bend    # signatures with ?TODO bodies; the policy replaces this file
  meta.json        # see spec §5.4 plus toolchain_hash, proof_header
references/<id>/
  solution.bend  PROOF.bend  mutants/m01.bend ...
```

`meta.json` gains `proof_header`, the exact import block the policy must start
`PROOF.bend` with (Fact 7):

```
import Base
import ./prelude.bend as P
import ./solution.bend as S
import ./LAWS.bend as L
```

Laws are proven by `def L.<law_name>(args):`. The observation includes this
header verbatim so the policy is not guessing module names.

### 3.2 Toolchain pinning

`toolchain/fetch.py` downloads a release tarball, verifies the sha256 published
by the launcher's `latest.json` (or a hash we record), and extracts `bend2/`
into `toolchain/<ver>/`. `toolchain.py` recomputes the tree hash at import and
refuses to run on mismatch. Every verdict carries `toolchain_hash`. bun is pinned
by version string and its path is taken from `GAVEL_BUN` or the vendored copy.

### 3.3 Runner

One check = one subprocess:

```
bun <toolchain>/bend2/main.ts PROOF.bend
  cwd     = fresh tmp dir containing only LAWS.bend, prelude.bend, solution.bend, PROOF.bend
  env     = {PATH: <bun dir only>, HOME: <tmp>, BEND_HUB: "http://127.0.0.1:9", BEND_NO_TELEMETRY: "1"}
  limits  = RLIMIT_AS (2 GiB), RLIMIT_NPROC (small), wall timeout 10 s, stdout/stderr capped at 64 KiB
```

Output parsing yields `CheckResult{ok, unsafe_warning, todo_count, error_block, ms}`.
On Linux the same argv is wrapped by bubblewrap (`--unshare-all`, ro-bind
toolchain + bun, tmpfs cwd, seccomp denying `execve` except bun). The wrapper is
selected by `runner.Backend` and the macOS backend is explicitly marked dev-only.

Latency: 0.2 s cold is bun startup plus one parse of `base.bend`. M3 adds a
persistent bun worker that imports `bend.ts` as a library and checks files over
stdin, which should bring p50 well under 100 ms. Not needed for M0.

### 3.4 Check protocol (per turn)

```
1. gate(submission)                       -> tier 0 on any finding
2. run PROOF.bend (full)                  -> ok  => tier 4
3. run solution.bend alone (with prelude) -> fail => tier 1
4. per-law fixed point:
     proven = {}
     repeat:
       for law in laws - proven:
         write PROOF_i.bend = header + defs[proven] + defs[law]
         run; ok iff output == "Error: K TODOs found." with K == n - |proven| - 1
              (or "All terms check." when K == 0)
         if ok: proven.add(law)
     until no change
   -> tier 2 if proven empty, tier 3 if strict subset
```

Soundness of step 4 rests on Fact 3: a proof that references an unfilled law
fails, so a law is credited only when its proof depends on nothing beyond
already-credited laws and the solution. Cycles get no credit. Worst case
n² runs, typical n+2. A def with an internal `?TODO` inflates K and is not
credited.

Law names and the submitted defs are found by `laws.py`, which reuses the
tokenizer rather than regexes.

### 3.5 Gate

Tokenizer ported from `bend.ts` (`parse_*` functions, lines ~1478–2640 in
2.0.5) into `lexer.py`, tagged with the toolchain version and covered by a
test that round-trips the vendored `base.bend`. The gate scans tokens of each
submitted file and rejects on:

- file set ≠ {`solution.bend`, `PROOF.bend`}; any file > 64 KiB
- `@unsafe`; `law`; `main`; foreign import (`import` followed by a string);
  hub import (`import 0x…`); any `import` other than `Base` and the four task
  files; `do IO`
- top-level names in `solution.bend` outside `policy_targets ∪ solution.*`
  helpers; top-level names in `PROOF.bend` outside `L.<law>` and `Policy.*`
- names that collide with `prelude.*`, `LAWS.*`, or Base (belt-and-braces over
  Fact 4)
- integrity: sha256 of `LAWS.bend` and `prelude.bend` in the working dir must
  equal `meta.json` after the submission is written

`tests/adversarial/` holds one file per row above plus every probe from §0; CI
fails if any yields a passing gate or a credited law.

### 3.6 Reward

`reward.py` is a pure function `(GateResult, CheckSummary, n_laws) -> (tier, reward)`
implementing spec §8 exactly, plus `difficulty_weight`. Dense multi-turn mode
returns the delta of the best-so-far tier reward. Property-tested: monotone in
proven count, 0 for tiers 0/1, 1.0 only at tier 4.

### 3.7 Env

```python
env = GavelEnv(bank="manifest.json", mode="dense", max_turns=4, backend="auto")
obs = env.reset(task_id=None)   # sampler by default
obs, r, done, info = env.step({"files": {"solution.bend": ..., "PROOF.bend": ...}})
```

`obs` is the spec §6.2 dict plus `proof_header`. `info` is the full `Verdict`.
`close()` flushes trajectories and metrics. A `GavelEnv.batch(actions)` helper
runs verdicts through a `concurrent.futures` process pool for throughput.

### 3.8 Authoring tools

- `tools/validate.py <task>`: V1–V5. Runs reference, runs every mutant against
  the reference proof (must fail), runs the degenerate library (empty, identity,
  constant, head) against the reference proof (must fail), lexes all files
  through the gate, records `reference_check_ms`.
- `tools/mutate.py`: rule-based mutants over the reference solution: swap
  match arms, drop a cons, off-by-one on `Nat` literals, replace recursive
  call argument with the parameter, swap operands.
- `tools/calibrate.py`: k zero-shot attempts with a configurable model via the
  env API; writes `zero_shot_solve_rate`.
- `tools/publish.py`: hashes the task, appends to `manifest.json`.
- `tools/migrate.py`: re-validates the whole bank against a new toolchain and
  writes a quarantine report.

## 4. Milestones and work packages

### M0 — Feasibility (target: 2 weeks)

Exit: 20 tasks tiers 1–3, `gavel check` CLI, p50 < 1 s, zero-shot solve rate 10–60%.

1. `toolchain/`: vendor 2.0.5, hash, bun pin, `toolchain.py` verification. *(½ day)*
2. `runner.py` macOS/Linux-plain backend, output parser, timeout, rlimits, tests against the §0 probe files. *(1 day)*
3. `laws.py` + minimal `lexer.py` (enough to find top-level `law`/`def` names and imports). *(1 day)*
4. `check.py` protocol §3.4, `reward.py`, `verdict.py`, tests with a 3-law fixture covering ok / partial / cyclic / TODO-inflated cases. *(2 days)*
5. `tasks.py`, `manifest.json`, `cli.py check|validate`. *(1 day)*
6. `tools/validate.py` V1, V4, V5 (mutants come in M1). *(½ day)*
7. Author 20 tasks by hand with references: tier 1 (`add_zero`, `length_lit`, `bool_not_not`, ...), tier 2 (`add_comm`, `append_nil`, `reverse_reverse`, `length_append`, ...), tier 3 (insertion sort ascending+perm, `filter` length bound, ...). Each proof verified with the pinned checker. *(4–5 days; the long pole)*
8. `env.py` single-turn, in-process; `tools/calibrate.py` against one frontier model; record numbers. *(1 day)*

### M1 — Gate

1. Full tokenizer port with `base.bend` round-trip test.
2. `gate.py` all rules; `tests/adversarial/` corpus (≥ 30 files).
3. `tools/mutate.py`, `tools/degenerate.py`; V2/V3 wired into `validate.py`; all 20 tasks pass.
4. Linux bubblewrap backend + Dockerfile that installs pinned bun and copies `toolchain/`; CI runs the adversarial corpus inside it.
5. Mutant-consistency tripwire (§7.4.2) in `check.py`: compare submitted `solution.bend` hash against the task's mutant hashes; on match plus success, withhold reward and write an incident record.

### M2 — Bank v0.5

1. Authoring pipeline as an agent loop over the env API (translate → laws → reference → mutants → calibrate → publish), with human review checkpoint for tier ≥ 3.
2. 200 tasks tiers 1–4; CI job runs `validate.py` over the manifest.
3. `tools/migrate.py` and a dry run against 2.0.4 to measure churn (three releases shipped in one day during probing; expect syntax drift).

### M3 — API

1. Multi-turn env with dense/sparse modes; feedback truncation.
2. `cache.py` (sqlite), `trajectory.py` JSONL, `metrics.py` export.
3. `server.py` JSON-lines over Unix socket + HTTP; client example in a non-Python stack.
4. Persistent bun worker backend; publish p50/p95/p99 and verdicts/min/core.
5. 10k-episode unattended soak with a scripted policy.

### M4 — Bank v1.0

500+ tasks including tier 5, human-reviewed laws for tier ≥ 3, published throughput benchmark, external training run.

## 5. Risks

- **Syntax churn.** Bend went 2.0.3 → 2.0.5 in under 24 h. Mitigation: the bank is pinned, `migrate.py` exists from M2, and the tokenizer is version-tagged.
- **Checker soundness.** The guide says the Lean model lags the implementation. Mitigation: mutant tripwire, adversarial corpus, and success keyed on exact output, not exit code.
- **Authoring throughput.** Hand-written proofs in a no-tactics language are slow. M0 deliberately keeps 20 tasks small; M2 relies on the agent loop.
- **Fact 8 cost.** Per-law runs multiply latency on failed turns. Bounded by n² × 0.2 s with n ≤ 5, and the persistent worker in M3 shrinks the constant.

## 6. First actions

1. `uv init`, vendor 2.0.5 into `toolchain/`, commit the hash.
2. Port the §0 probe files into `tests/fixtures/add_zero/` as the first task and the first adversarial cases.
3. Implement `runner.py` and `check.py` against that fixture, then iterate on tasks.
