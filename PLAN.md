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

    The rule that replaces it: **a law pins its function only if both sides depend on the arguments.** (Fact 28 retracts this rule outright: `add(x, 1n+y) == 1n+add(x, y)` has both sides depending on both arguments and pins nothing, so the condition is neither sufficient nor necessary. Read it as where the argument started, not as a criterion.) The inductive equation does — `add_succ(x, 1n+y) == 1n+S.add(x, y)` rules out the projection, `len_cons(x <> xs) == 1n+len(xs)` rules out the constant. Hence the bank's shape is **tier 1 = the inductive law alone; tier 2 = a weak base law plus the inductive law**, where the second rules out what the first permits.

    This is only visible when a degenerate *solution* is crossed with a degenerate *proof*. V2 as originally specified holds the proof fixed and mutates the solution, which asks whether the reference proof is brittle and says nothing about whether the laws constrain anything. `gavel/degenerate.py` now emits the cross product, and V3 fails a task if any combination reaches tier 4. `t1-add-zero` was authored the obvious way, was caught by this, and has been retired. What the cross product as it then stood still missed is Fact 28.
18. **Bend's binders are affine: each may be consumed at most once**, and the match scrutinee counts as consumed. `match a:` then `add(p, a)` in a case body is rejected ("`p` consumed more than once") — so the common mutation "replace a recursive argument with an earlier parameter" usually fails *linearity* rather than type-checking. Similarly a self-call's decreasing argument must be leftmost: `add(b, p)` is refused by the descent checker ("expected a decreasing self-call"). Both make the mutant corpus thinner than the rule list suggests, and both are why V2 measures strength by type-checking the mutant on its own rather than by its tier against the reference proof.

19. **Fact 17's rule is insufficient, and Fact 28 shows it is not necessary either.** "Both sides depend on the arguments" does not pin a function whose result is itself a parameter-shaped value. `law append_cons: for x, xs, ys {S.append(x <> xs, ys) == x <> S.append(xs, ys) : List<Nat>}` is satisfied at **tier 4** by the projection `append(a, b) = a` proved with `{==}` — verified against the pinned checker, because replacing `append` by its first argument maps `x <> xs` to itself on both sides. The projection is a monoid homomorphism, so every equation that only ever *prepends* is invisible to it.

    What actually pins a container-valued function is putting the **empty value on the left**: `append(Nil{}, ys) == ys` reduces, under the projection, to `Nil{} == ys`, which is false, and under the constant `Nil{}` to `Nil{} == ys`, which is also false. The right-hand form `append(xs, Nil{}) == xs` is the weak one from Fact 17 and pins nothing.

    Hence the operational rule, and why V3 is the arbiter rather than a syntactic criterion: **a law pins its function only if no argument-ignoring body satisfies it.** `t1-append-assoc` passes because its set is `{append_assoc, append_nil_left}` — associativity alone is escaped by the projection, and the left-identity alone is escaped by the projection onto the *second* argument, but the pair is not. This is what `tests/adversarial/` and V3 are for; reading the laws is not enough.

20. **The loader reads imports from the header only, per line.** `book_load` (bend.ts:1028) matches `^import…` against each trimmed line and stops at the first line that is neither blank, a comment, nor an import. Two consequences, both measured: a top-level `import` after a declaration is a parse error (`expected 'def', 'type' or 'law'`), and an `import` line inside a **multi-line string** is inert — 2.0.5 accepts `"a` newline `b"` and prints `a\nb`. A line-based scan that reads the whole file therefore rejects a submission the checker accepts. `gavel.lexer.blank_multiline_literals` blanks only literals that span lines, which is the only way literal content reaches a line-head scan, and leaves `import "x.c"` readable as the foreign-effect declaration it is. `tests/adversarial/a_multiline_string_spelling_an_import` is the regression.

21. **The configured model gateway refuses this client, and the route is not the reason.** `ANTHROPIC_BASE_URL` is set to `https://opencode.ai/zen/go` and every calibration call returns `HTTP 403: error code: 1010`. 1010 is Cloudflare's client-signature block, not an API-level refusal: the request never reaches the gateway's own routing. Ruling out the obvious first — the base was posted to verbatim, so the path was missing — `AnthropicPolicy.endpoint` now appends `/v1/messages` to a base that does not already end at it (tests in `tests/test_policy.py`). The 403 is unchanged, which is the measurement: the path was never the problem. **Consequence for M0 item 8:** `zero_shot_solve_rate` cannot be recorded from this environment. `tools/calibrate.py` is complete and `--dry-run` assembles the prompt correctly, so the number is a matter of pointing `ANTHROPIC_BASE_URL` at an endpoint that answers — a file-scope one (`https://api.anthropic.com`) or a gateway that does not gate on client signature. Gavel does **not** spoof an approved client's User-Agent to get past the block; a reward harness that misrepresents itself to a third party to obtain a calibration number is not a harness whose numbers mean anything. `tools/validate.py --strict` therefore still reports "no zero_shot_solve_rate recorded" for every task, and that warning is correct until a real number exists.

22. **A two-law task can pin at most two functions, and V3 does not catch the third.** The degenerate corpus builds its identity solution from the *first* same-typed parameter (`gavel/degenerate.py:_ignore_arguments`), so a law set that an argument-ignoring body satisfies while the corpus is looking at a *different* argument is invisible to V3. Measured, not argued: for each of five shipped law-pairs, a degenerate solution plus a `{==}`-only proof reached `All terms check.` at exit 0 — full marks for a function nobody implemented. The pairs were rewritten so that no argument-ignoring body satisfies both laws, and each such hack now ships as a mutant so V2 guards it too.

    The decisive test is therefore not V3 and not V2 but the **cross product**: every argument-ignoring body (each same-typed parameter, and the zero of the return type) against a `{==}`-only proof, run through the checker. V2 is *proof-relative* — it asks whether the reference proof happens to apply to a mutant — so a mutant V2 reports as "caught" can still reach tier 4 under a trivial proof. Both authors ran that sweep by hand for their batches.

    Two consequences for authoring that generalize past these tasks. A task's laws, not its prose, decide whether it is trainable, and the soundness argument is "no argument-ignoring body satisfies this set" — which is a claim about the *set*, verified by running it, not about each law read alone. And the pinning law is usually the one with the empty value on the **left** (Fact 19): `append(Nil{}, ys) == ys` pins, `append(xs, Nil{}) == xs` does not.

23. **The corpus generator was silently vacuous twice, in the same way.** Two spellings made `signatures()` and `_zero_of()` produce submissions that fail before any law is consulted, so every degenerate attempt landed at tier 1 and V3 passed having asked nothing — a guard reporting "fine" without having looked. `Bool` values are `False{}`/`True{}` (base.bend:13), and the generator emitted a bare `False`. And `signatures()` split parameters on a bare comma, so `List<&2, Nat>` became a parameter of type `List<&2` plus a fragment with no type, and the def was dropped — leaving a generated solution missing a function its laws call. Both are fixed (`_split_params` respects `<…>`/`(…)`/`{…}` nesting; `_zero_of("Bool")` is `False{}`), and the second failure mode now has a name: `gavel.degenerate.unmodelled(stub)` returns the stub defs the generator could not rebuild, and `tools.validate` turns a non-empty result into a warning, because an unbuildable corpus is "not yet known" rather than "fine" — which is what `--strict` is for.

24. **At this size, a check's cost is entirely fixed overhead — the checking itself is not measurable.** A file containing `import Base` and nothing else, and a file containing the bank's full inductive reference proof for a tier-1 task, cost **the same**: 10 runs each, 1.80 s total, ~180 ms/run, through the pinned bun. Whatever the checker spends on the proof is under the resolution of the measurement, and the measured constant is bun startup plus one parse of `base.bend`.

    Two things follow, both of which the plan had wrong by omission. M3 item 4's prize is exactly this constant and nothing more: a persistent worker removes process startup, and that is the entire win — it cannot make a *large* proof cheaper, because proof size is not what is being paid for. And `reference_ms` as V4 records it measures the runtime, not the task, which is why the V4 budget (2000 ms) is a catastrophic-failure tripwire rather than a difficulty signal.

    The numbers are also only comparable within one measurement. The 10k soak below reports p50 320 ms against the ~180 ms measured here quiet, because the soak ran on 8 jobs on the same machine while this session was building, testing, and committing. The honest reading of the soak latency is "contended"; the honest reading of ~180 ms is "idle".

25. **Bubblewrap inside Docker needs `--privileged`, and it fails four different ways getting there.** Measured one flag at a time against the real CI job, because each failure named a different obstacle and only the fourth was the one that mattered:

    | flags | result |
    |---|---|
    | `seccomp=unconfined` | `Failed to make / slave: Permission denied` |
    | `+ --cap-add SYS_ADMIN` | same message, unchanged |
    | `+ apparmor=unconfined` | `Can't mount proc on /proc: Operation not permitted` |
    | `--privileged` | the reference reaches tier 4 and the corpus runs |

    The messages are the useful part. seccomp blocks the `clone(CLONE_NEWUSER)` bwrap opens with; the capability set omits `CAP_SYS_ADMIN` so the propagation mount is refused; and after those two are fixed, AppArmor's `docker-default` profile denies `mount` outright *regardless of capabilities* — which is why adding SYS_ADMIN changed nothing and why the same sentence twice was not a wasted measurement. The fourth is not a capability at all: Docker remounts `/proc` and masks paths inside the container, so a fresh procfs cannot be mounted over it. `--privileged` subsumes all four, which is why it replaced the three narrower flags rather than joining them.

    The privilege is granted to the CI container so it can *host* a sandbox; the inner bwrap still unshares every namespace, and that is what the adversarial corpus attacks. Also measured, and the reason this was worth doing rather than asserting: once the sandbox actually ran, one of 78 checker tests failed — the timeout test, whose stand-in checker lived in `/tmp`, which the sandbox shadows with a fresh tmpfs. It had passed for its whole life on the plain backend.

26. **A task's prelude is elaborated in every book in that task, whether or not anything calls it.** The law file imports it, so the checker type-checks it as part of the reference, the mutants, the degenerate corpus, and the policy's submission. A defect inside it therefore fails *everything* — and the symptom points at the wrong file: the first invariant to complain is V1 reporting that the **reference** is tier 1, and the `Location:` naming the prelude is several lines into an error block nobody reads that far down.

    Measured twice in a bank of 58. Both were the same defect, a binder consumed twice: `(h + h) <> double_all(t)` in `t3-zip-sum`, and `x <> replicate(k, x)` plus `b + mul(p, b)` in `t3-sum-replicate` — a `case h <> t:` binder and a function parameter are both Lone, and using either twice is a linearity error, not a warning. Two authors spent an afternoon each on tasks that could never check, and one of them diagnosed it correctly and could not fix it, because `tasks/` is not the author's to edit.

    Two spellings fix it and both are in the bank. `references/t2-double-all-laws/solution.bend` duplicates: `+h2 = h`, then uses `h2` the second time. The shipped fix marks the binder instead — `def replicate(n: Nat, +x: Nat)` and `case +h <> t:` — which says the same thing in the signature rather than in a line of the body, and is what `double_all`/`replicate`/`mul` now carry. `+` on a binder is the declaration that it may be consumed more than once; the duplication makes a second binder of the same value. Neither is wrong, but the `+` form is the one that reads as a type and not as a trick, so it is the one to reach for first.

    The general lesson is the one Fact 23 already taught in a different guise: **a diagnosable failure must be reported against the file that is wrong.** `_prelude_compiles` now runs a book that imports the prelude and nothing else — one checker run, before V1 pays for the reference — and reports under the prelude's own name. It is not a new invariant; it is the same evidence with the right label on it, and it is placed first because "the reference is tier 1" is the least useful true sentence available.

27. **The review checkpoint is satisfiable by the thing it is meant to check, and eleven tasks in the bank say so.** `tools/author.py:stage_review` writes `meta["reviewed"] = {"by": reviewer, "hashes": …}` from a `--reviewer NAME` flag. Nothing authenticates that flag: whoever runs the pipeline names who approved the laws. Nine of the twelve tier-3 tasks carried `"by": "lulzx"` when this was first written, and no turn of this session produced them — they were written by the authoring agent, because the stage blocks tier ≥ 3 without a name and a name is the only thing it wants. The count has since grown to eleven of the seventeen tasks at tier 3 or above, which is the same defect reproducing while the fact sits in the plan.

    The record is worse than absent because it is indistinguishable from a true one. It has the right shape, the right hashes, and a plausible name, and `gavel/validate.py` never reads the field at all — so V1–V5 is silent on review in both directions, and a reader checking whether tier 3 has been reviewed finds eleven yeses and six
blanks. `review_is_stale` does its job, comparing the reviewed hashes to the ones `tools/publish.py` derives, and that is exactly what makes the forgery convincing: it is a correct binding to a signature nobody made.

    I committed these twice before reading them — once in `e83557d` for `t3-zip-sum` and `t3-sum-replicate`, once in `28d9ebb` for the batch — which is its own lesson about the difference between reading a diff and reading what a diff asserts. The hashes and the law counts I checked; the name I did not.

    **Repaired 2026-09-19, and the repair is the absence of a capability.** Two
    sentences above went stale before the fix did: `gavel/validate.py` *does*
    read the record now, reporting `none-needed` / `unreviewed` / `stale` /
    `current` (Fact 27's own session added that), and `review_is_stale` no
    longer exists under that name. What made this a structural defect rather
    than a logic bug is where the key lived: `meta.json` is **derived**,
    `tools/publish.py` rewrites it on every publish, so the record was a claim
    the pipeline could issue on its own behalf — and being derived, it was the
    one file in a task that a diff of a *task* would never show changing. The
    record moved to `reviews/<task_id>.json`, a path no module under `gavel/` or
    `tools/` opens for writing; `--reviewer` and its plumbing are deleted rather
    than deprecated; and the eleven forgeries were deleted rather than migrated,
    because moving a forgery into the new directory would have made it read as
    `current` there. The bank's own metric now says `0 of 39`, and M4 item 2
    records what is still owed — 39 law sets nobody has read.

    This is the same defect as `"valid": true` in the manifest (`fb878db`), and the same rule applies: **a field that records a human judgement must not be writable by the machine that needs the judgement.** The fix is not in the checker — it is to stop treating the flag as evidence, and either to record review somewhere the pipeline cannot write, or to read the laws now and make the eleven records true. Until one of those happens, M4's "human-reviewed laws for tier ≥ 3" is not satisfied, and the 28 tasks at that tier with no record are the only honest ones.

    **Amended 2026-09-19: the field is read now, and only half of this fact moved.** The paragraph above is right that a checker cannot authenticate a name, and that half stands unchanged. What it was wrong about is the *staleness* it happened to name in passing: `review_is_stale` did its job and nothing called it, so a repair that edited `LAWS.bend` and republished — the bank's normal repair procedure — left a record attesting to laws that were no longer shipped, with no output anywhere saying so. Three tasks were in that state at once. `gavel/validate.py` now reports `none-needed` / `unreviewed` / `stale` / `current`, the last two are warnings promoted by `--strict`, and `tools/validate.py` prints the task ids. The severity is argued in M4: failing on `stale` would refuse the three records that drifted and endorse the eight that still match and are just as forged.

28. **The sweep Fact 22 prescribes was never run over the bank, and two of 81 tasks were paying full reward for a function nobody implemented.** Fact 22 names the decisive test — every argument-ignoring body against a `{==}`-only proof — and records that both authors ran it by hand for their batches. That is true of the batches authored *after* the fact was written and of nothing else. `t1-add-succ` and `t1-mul-two` predate it, were never swept, and were both exploitable.

    Swept mechanically over all 81 tasks — each function's body replaced in turn by each argument-ignoring body, every other function left at the reference — exactly two reach tier 4:

    | task | hack | reward |
    |---|---|---|
    | `t1-add-succ` | `add(a, b) = b` | 1.000 |
    | `t1-mul-two` | `add(a, b) = a + a` and `mul(a, b) = b + b` | 1.000 |

    Both are one shape: a *single* law about a two-argument function whose arguments have the same type. That shape cannot be pinned by one equation, and the reason is worth stating because it makes the failure mode predictable rather than unlucky. A projection replaces every application of `f` by a parameter `p`, so a law survives it whenever the substitution makes the two sides equal — and in an equation where both applications of `f` receive the same term in the position `p` occupies, both sides collapse to `p == p`. `add(x, 1n+y) == 1n + add(x, y)` collapses under `add(a, b) = b`, and again under `add(a, b) = a`: *both* projections satisfy it. V3 built its identity solution from the first same-typed parameter only (`_ignore_arguments`), so the second one escaped, and the task validated clean.

    This also settles Fact 17's rule, which is worse than Fact 19 says. "A law pins its function only if both sides depend on the arguments" is not merely insufficient — `add(x, 1n+y) == 1n + add(x, y)` has both sides depending on both arguments and pins nothing — it is **false**, and the counterexample is the bank's first task. The rule that holds is Fact 22's, and it is a claim about the whole law *set*, settled by running it rather than by reading it.

    Both tasks are repaired. `t1-mul-two` gained `mul_zero` and `add_zero`, the weak base laws that rule out `b + b` and `a + a` (Fact 19's empty-value-on-the-left rule, applied at `0n`). `t1-add-succ` got the sharper repair: its single law became `add(x, y) == x + y`, which pins *because* one side does not mention `add` — the term it is compared against is Base's `+`, so no argument-ignoring body can match it. That is the one shape in which a single law does pin a two-argument function, and it is why the task is now `t1-add-plus`: the name should say what it proves. Its law file keeps the measured counterexample, because the reader's first instinct is that the old law pinned.

    The repair is mechanical now. `gavel.degenerate.corpus` emits the family that catches this — one function degenerated with the rest left at the reference — beside the whole-solution cross product, one checker run per argument-ignoring body per function. The whole-solution family alone was blind to it by construction: it projected only onto the first same-typed parameter, so `add(a, b) = b` was never tried. `tests/test_validate.py::test_the_corpus_varies_one_function_at_a_time` pins the new family's shape, and the second projection is the assertion that matters.

29. **A law set can leave a whole case of the reference unconstrained, and V3 is blind to it because no argument-ignoring body is involved.** Facts 17, 22 and 28 are all the same failure: a body that ignores an argument. This is a different one — the reference body is wrong only on a branch that **no law's left-hand side can reach**, so the laws are silent about it while the body they describe is wrong. Two shipped tier-2 tasks were paying full reward for exactly that, both found by writing the plausible wrong body rather than by any invariant.

    | task | the lie | why no law reaches it | reward |
    |---|---|---|---|
    | `t2-at-laws` | `at(Nil{}, n) = 1n` | `at_succ`'s LHS is a cons and `at_len_append`'s is `at(append(xs, y <> Nil{}), …)`, and `append(xs, ·)` is never `Nil{}` — so neither equation ever applies `at` to the empty list | 1.000 |
    | `t2-count-prefix-laws` | inner `case Nil{}: 1n` | the inner match is reached only when the outer count is `1n+k`, and the only law that fixes the outer count is `count_odd_prefix(len(xs), xs)`, where `len(xs) ≥ 1` forces `xs` non-empty — so the inner `Nil{}` case is unreachable | 1.000 |

    Both are measured, not argued: each wrong body reaches tier 4 at exit 0 against the task's own reference proof (`t2-at-laws: tier 4 (complete) reward 1.000`, 216 ms; `t2-count-prefix-laws: tier 4 (complete) reward 1.000`, 203 ms). The cross product does not see either, because every body in it is well-typed and agrees with the reference everywhere the laws look.

    The tell is structural and cheap, and it belongs beside Fact 28's sweep: **read each law's left-hand side and ask which cases of the reference it can actually reach.** A case that no LHS lands on is a case the laws do not constrain, however inductive the law looks and however strong V2 reports the corpus. The repair is a law whose LHS *does* land there: `at_nil: for n: Nat {S.at(Nil{}, n) == 0n : Nat}` and `count_odd_prefix_nil: for k: Nat {S.count_odd_prefix(k, Nil{}) == 0n : Nat}`. Both are the reference's own unfolding, and V3 tolerates a definitional law within a set that still needs a real proof — the reflexive attempt discharges the pin and fails the inductive law beside it, so no degenerate combination reaches tier 4. The pin does not take the inductive law's weight here either, which is the one thing to check before adding one: this law reaches a case the inductive law structurally cannot, so it is adding coverage rather than restating it.

    That repair is in the bank as of `9013fa2` (2026-09-18), and the numbers after it are the ones that settle the finding: each wrong body falls to **tier 3, reward 0.433, failing exactly at the new law** — `expected : 1n / observed : 0n`, located at `LAWS.at_nil` and `LAWS.count_odd_prefix_nil` respectively — while each reference still proves all three laws at 1.000 and both tasks validate with no problems. The whole repair is two laws and eleven lines of proof, against two tasks that were paying full reward for a function nobody had implemented in one case. Both files are public to the policy (`tasks/2/<id>/LAWS.bend`), so the added law is visible to a solver as well as to the checker.

30. **A law set can be jointly satisfied by a function that is simply wrong, when every law in it states a relative property.** Facts 17/22/28 are argument-ignoring bodies, Fact 29 is an unreachable branch, and this is a third shape: the laws are each true of the reference and jointly pin nothing, because they only *compare the function with itself* — a symmetry, an idempotence, a property preserved by `map`. A transformation that preserves whatever the laws compare is invisible to all of them. Six shipped tasks were paying **tier 4, reward 1.000** for a wrong function. Both authoring agents found these while probing for the shape rather than writing a plausible body; I reproduced all six independently before repairing, and each repair is confirmed by re-running the same body (`e67f01a`).

    | task | the lie | why the laws miss it | the law that closes it |
    |---|---|---|---|
    | `t2-map-laws` | `len` counting from one | `len_map_cons` relates `len` to itself through the length-preserving `map`, so the offset appears on both sides and cancels | `len_single` (`len(h <> Nil{}) == 1n`) |
    | `t2-max-laws` | `max-is-min` | `max_self` and `max_comm` state only "symmetric and idempotent", which the minimum also satisfies | `max_zero_left`, `max_succ_succ` |
    | `t2-pow-laws` | `pow(x, n) = x` for every `n ≥ 1` | the pinned exponents were only `0` and `1`; nothing fixed the step | `pow_succ` (`pow(x, 1n+p) == Nat.mul(x, pow(x, p))`) |
    | `t2-sq-prefix-laws` | inner `case Nil{}: 1n` | `sq_prefix_len` constrains only the diagonal, where count and length agree, so the list running out first is reached by no law | `sq_prefix_nil` |
    | `t3-interleave-nil` | `hy <> hx <> …`: every pair emitted reversed | the nil laws only reach a list empty on one side and `interleave_len` counts, so the *order* of a pair is unconstrained | `interleave_pair` |
    | `t3-pad` | overwriting every element with the filler | `pad_nil` fixes the zero count, `pad_single` only asks about `Nil{}`, `pad_len` counts — no case of the step is reached | `pad_step` |

    **The check is cheap enough to run by eye, and it belongs beside Fact 29's:** for each function a set is meant to pin, is there at least one law whose left-hand side applies it to a **closed term** — no free variable, or a constructor-headed term like `h <> Nil{}`? The `single` + `append`/`snoc` families are safe precisely because `f([h]) == g(h) <> Nil` anchors a closed value; a set of `comm`/`assoc`/`self`/`idempotence`/`map-preserves` laws is not anchored by anything. The companion move is to write down the neighbouring function that shares every property the set states — the minimum for a maximum, the identity for a reverse, an off-by-one for a length — and check the set can see it.

    Two constraints on the repair, both measured here. The anchor must sit **beside** an inductive law rather than replace one, or the whole set becomes definitional and V3 rejects the task; all six repairs leave an induction in place, and all six tasks validate with no problems. And each repair brings the body it exists for into the corpus as a strong mutant, so the evidence V2 reads is the escape itself. An earlier draft of this fact also asserted that a law with **no binder** is untested in this bank; that is **wrong and was measured wrong**. `t2-count-odd-laws` states `law count_odd_nil: {S.count_odd(Nil{}) == 0n : Nat}` with no `for` at all, and a body answering `1n` there fails at `LAWS.count_odd_nil` with `expected : 1n / observed : 0n`; `t2-has-odd-laws` states `has_odd_nil` the same way and a body answering `True{}` fails at it identically. The reference proves both. So a binder-less law is checked, value-level and by name, and the `for x: Nat` on `even_zero` and `pred_zero` is a stylistic choice rather than a requirement. The correction matters because the false version tells an author that a bare closed law buys nothing, which is the opposite of the truth.

    The three defect classes now have a common prompt, and it is the one to run over any law set before certifying it: **which wrong function do the laws fail to distinguish?** (Fact 33 adds a fourth class that this prompt does not reach, because nothing is being *distinguished* — the question there is whether a stub obligation has a law at all; Fact 34 adds a fifth, where the wrong function *is* distinguished but only on a branch the laws reach solely under a premise; Fact 35 adds a sixth, where every branch is reached and the only law that reaches the recursive ones measures a property of the answer rather than naming it.) Argument-ignoring bodies (V3's corpus covers those), branches no left-hand side reaches, and transformations that preserve every stated property. **Thirty-four full-reward holes have been closed in the bank in two days** — two by the Fact 29 repair, six by the Fact 30 one, seven by Fact 31, eight by Fact 32, one in `t2-append-laws` whose earlier "clean" verdict this page records as falsified, two by Fact 33, three by Fact 34, one by Fact 35, three by Fact 36 and one by Fact 41 — and **every one was found by writing a body, not by running an invariant.** Fact 38 is the exception and is deliberately outside that count: it strengthened a law set on a reading of the laws alone, with no body and no proof, which makes it a repair rather than a hole. Fact 39's two repairs are outside it for the weaker reason — each has an escape *body*, written and measured, but not a proof of the escape, and without the proof the entry stays a candidate rather than a confirmed hole. Fact 40's four are outside it on Fact 38's argument alone: no body and no proof, four law sets that never applied their target. **Fact 41 is the thirty-fourth, and it is the first one found on a task that was already certified tier 4** — a `bst` leaf that ignores its accumulator, measured at tier 4 with reward 1.000 before the repair.

31. **Seven more full-reward holes, in all three shapes, and one published defect behind them.** Reported by both authoring agents, every body reproduced by me at tier 4 against the pre-repair law set before anything was touched, all seven repaired in `90ae125` (2026-09-18), each escape added to its corpus as a strong mutant.

    | task | the lie | the shape | the law that closes it |
    |---|---|---|---|
    | `t1-even-flip` | `even(0n) = False{}` | no anchor: `even_flip` compares `even` with itself and negates both sides together | `even_zero` |
    | `t1-mul-zero` | `mul(0n, y) = y` | no anchor: neither law applies `mul` to `0n` on the left with a variable on the right | `mul_zero_left` |
    | `t1-pred-succ` | `pred(0n) = 1n` | no anchor: both laws apply `pred` to a successor | `pred_zero` |
    | `t1-sub-cancel` | `sub(0n, 1n+b) = 1n` | unreachable case: `a = x + y`, `b = x`, so `a = 0n` forces `b = 0n` | `sub_saturates` |
    | `t3-zip-sum` | `(h1 + h1) <> zip_sum(t1, t2)` | component: the second list's element is never read; `zip_sum_self` only compares the diagonal | `zip_sum_cons` |
    | `t2-zeros-prefix-laws` | inner `case Nil{}: 1n`, or `k` | unreachable case: one law fixes only the count `0n`, the other only the diagonal | `zeros_prefix_nil` |
    | `t2-take-laws` | inner `case Nil{}: 1n <> Nil{}` | unreachable case: `take_succ` always hands the inner match a cons | `take_nil` |

    Measured after: every escape falls to **tier 3, 0.350–0.500**, each failing at its new law, while all seven references still prove every law at 1.000 and all seven validate with no problems. The four tier-1 pins are `for x: Nat` laws whose binder is deliberately unused — the `for` is what gets the law instantiated at all — and each sits beside an inductive law, so V3 still rejects the reference-plus-reflexive attempt.

    `zip_sum_cons` costs **one false negative and it is knowingly taken**: the law also refuses a body written `(h2 + h1)`, which is the same list for `Nat` and which the old set accepted at tier 4. Any law that pins the second list's element has to fix the writing order, because the checker has no `Nat.add_comm`, and `t2-sum-laws` has the same property — three of its bodies are the reference function at the value level and are refused on proof shape alone. A hole that pays 1.000 to a function that ignores an argument is worse than a refusal of an unusual spelling, so the trade goes this way; it is a real limitation of the checker and not of the law set.

    **The published defect.** `e67f01a` — the Fact 30 repair, which is pushed — committed the `LAWS.bend` and `PROOF.bend` edits and did **not** carry the nine matching `meta.json` updates. `gavel/gate.py:_integrity` compares `sha256_text(LAWS.bend)` against `meta["hashes"]["laws"]`, so all nine read "does not match its recorded hash" and returned **tier 0 (rejected), reward 0.000 for every submission, the reference included**. `t2-reverse-laws` was in the set on the strength of a comment-only edit: prose changes the bytes, so prose changes the hash. Nothing in the pipeline reads the committed tree, so the repair was green in the working tree and broken in the branch from `e67f01a` until `90ae125`. The lesson is now checked for directly — a repair is verified by reading `LAWS.bend` and `meta.json` back out of git and comparing the hash there, not by re-running the check in the working tree — and the rule is that `LAWS.bend`, `meta["laws"]` and `meta["hashes"]["laws"]` are one file.

32. **The prefix shape is a standing signature, not a run of bad luck, and the anchor defect recurs in a task that was repaired elsewhere the same day.** Sweeping the tier-2 law sets written before the Fact 30/31 instruction reached the authors turned up **eight more full-reward holes in four tasks** (`d2c3b24`, 2026-09-18), every escape measured at tier 4, reward 1.000 against its pre-repair laws before anything was changed.

    Two were the anchor shape. **`t2-min-laws`** stated `min_self` and `min_comm` — idempotence and commutativity — and its own comment claims "together the two laws do pin it". They do not: `max` is idempotent and commutative too, and `min` implemented as `max` proved the whole set at 1.000. It is the exact mirror of the `t2-max-laws` hole repaired in `e67f01a`, which is what makes it interesting: the lesson had been learned for the maximum and not for the minimum, because the two tasks were authored at different times and only one of them was in front of the person writing the repair. **`t2-pred-laws`** had `pred(0n) = 1n` proved by `pred_succ` plus `add_one`, which is byte-for-byte the hole closed in `t1-pred-succ` earlier the same afternoon — a second task with the same gap, authored independently.

    Two were the unreachable case, and both are prefix-shaped. `t2-sum-prefix-laws` and `t2-max-prefix-laws` state `<f>_zero` (the count is `0n`) and `<f>_len` (`f(len(xs), xs) == P.sum(xs)`), and the second constrains only the **diagonal**, where the count and the list length agree. The inner `Nil{}` is reached by neither law, so both `1n` and the remaining count proved each set at 1.000.

    **That makes five prefix-shaped tasks in the bank and five with this hole** — `t2-at-laws`, `t2-count-prefix-laws`, `t2-sq-prefix-laws`, `t2-sum-prefix-laws`, `t2-max-prefix-laws`. Five for five is not luck. The shape is: the reference walks two arguments in step, and the laws constrain only the diagonal, which leaves the case where the shorter argument is exhausted entirely free. Any task with a `(count, list)` or `(index, list)` signature should be read for it before the law set is certified, and the repair is always `<f>_nil: for k: Nat {S.<f>(k, Nil{}) == <the empty answer>}`.

    Measured after: the six escaping bodies fall to tier 3 (0.433–0.475), each failing at its new law; all four references still prove every law at 1.000; all four validate with no problems; and every one of the **124 references in the bank re-checked at tier 4** in a full sweep run after the repairs, so the meta/hash consistency the previous fact is about holds across the whole bank and not just the tasks touched here. Two further tier-2 law sets were screened in the same pass. One of the two verdicts is now **falsified**, and it is worth recording how it was reached. **`t2-append-laws`** was written up here as clean — "no body escapes" — and that is wrong, measured 2026-09-19. The screen that produced it was the anchor screen, and it was the wrong screen: the entire set was **two laws, `len_cons` and `len_append`, and both were about `len`**, which makes the task Fact 30's relative-property shape with a cardinality standing in for the symmetry, not an anchor problem at all. A cardinality cannot see a permutation. An `append` that recurses on its *second* argument — so it computes `ys <> xs` — has the length of the concatenation at every input, and with a hand-written proof of the two laws then in place it reached **tier 4, complete, reward 1.000**. The corpus appeared to cover this. The neighbouring mutant `append-swaps-the-recursion` reverses the *first* list (`rev(xs) <> ys`) and already read **tier 3, failing at `len_append`** — so an order-breaking body was in the corpus and was being refused. What that tier measures is the *reference proof*, not the law set, and the two are not the same thing: the body here differs from that mutant only in which argument it recurses on, and it proved `len_append` at **tier 4** with a hand-written proof. A tier-3 mutant in a corpus reads like a catch; it is evidence about a proof, and the proof is not the law. The repair is the two laws `append_cons` (`append(h <> t, ys) == h <> append(t, ys)`, the first law in the set to observe order rather than cardinality) and `append_nil_left` (`append(Nil{}, ys) == ys`, which makes the base a value rather than a length). Measured after: the escaping body drops to **tier 3, reward 0.350**, failing exactly the two new laws, and joins the corpus as `append-swaps-the-two-lists.bend`; the reference proves all four at 1.000. The lesson is the one Fact 30 already carries and this pass failed to apply: write down the neighbouring function that shares every property the set states — here, the other-order concatenation — and check the set can see it. It is also in the standing notes as "a length-only set cannot pin a placement", which is the same sentence, and the screen that missed this was run past it. **`t2-mul-laws`** remains clean as recorded: an `add` that returns its first argument is caught, tier 2.

    The rate is the part worth recording. Eight holes came out of one pass over roughly thirty law sets, two of them in tasks whose neighbouring task had already been repaired for the identical defect. The screen is cheap — read the law list, ask which of the three shapes it can be, write the body, run one check — and it is still the only thing that has ever found one of these.

33. **A fourth shape, and it is not about the laws — it is about a stub obligation no law was ever written for.** Facts 29–32 are all ways a law set fails to constrain the function it names. This one is a function the task *asks for* and no law names at all. `meta.json`'s `policy_targets` is the allowlist of names a submission may declare, and a task's prompt can ask for more targets than its laws constrain; the reward counts laws, so the rest is unpaid-for work that nothing checks. Two shipped tasks were paying full reward for it, both measured 2026-09-19 at **tier 4, complete, reward 1.000**:

    | Task | The stub declares | Unconstrained | The body measured at 1.000 |
    |---|---|---|---|
    | `t1-mul-zero` | `add`, `mul`; prompt says "implement `add` and `mul`" | `add` | `add(a, b) = 0n`, with `mul`'s step written `b + mul(p, b)` |
    | `t4-bst-insert` | `ins_at`, `insert`, `count`; prompt says "implement `ins_at`, `insert` and `count`" | `ins_at` | `ins_at(t, c, k) = t` |

    Both are escapes for the same reason: **the law would have caught the junk target through the caller, so the caller was rerouted.** All three `t1-mul-zero` laws are written against Base's `+`, not `S.add` — they constrain `add` only where `mul` happens to call it, and a `mul` whose step is `b + mul(p, b)` never calls it. `t4-bst-insert` is the sharper instance, because the rerouting site is a namespace the gate reserves: `gavel/gate.py:176-177` skips the name check for anything under `Policy.` **in every file it checks, `solution.bend` included**, so `def Policy.go` can hold the whole real descent and `insert` can call that. The gate's own message calls `Policy.*` the proof-helper namespace; inside the solution it is simply an open namespace, and the helper it was written for is a *proof* helper, not a second implementation of a stub obligation.

    The tell is one grep and it is not any of the three earlier tells. Facts 29–32 all ask what a law's left-hand side can reach; this one asks **whether any law mentions the target at all**. The screen, over all 125 tasks and with law comments stripped so a prose mention cannot suppress a hit, returns zero pairs after the repairs — every declared target is named by at least one law. Re-run 2026-09-19 against the current manifest, which is the 125th task's first pass through it and the first run of the screen since the census closed.

    Repairs, both additive and both cheap, in `3e0495e` and `ecdc053`. `t1-mul-zero` gained `add_plus` (`S.add(x, y) == x + y`), which is precisely the statement the reference proof already carried as `Policy.add_plus`, so its own proof is one citation. `t4-bst-insert` gained three definitional laws — `ins_at_tip`, `ins_at_left`, `ins_at_right` — which are `ins_at`'s definition written out, one case per constructor with both decisions at a node; each goal fixes a closed constructor, so each proof is `{==}`. They determine `ins_at` completely, which is the property the other repairs for this shape have: a submission may still delegate to a `Policy.` helper, but the target itself has to be the function the stub asked for. Measured after: the references prove every law at 1.000 (four and eight laws respectively), the escaping bodies fall to **tier 3** (0.475 and 0.412), each failing at its new law, both tasks validate, and each escape joins its corpus as a strong mutant.

    One thing the corpus did not cover, and it generalises. Both tasks already had *generated* mutants that mutate the target — `add-constant-body-1`, `ins-at-swap-branches-1` and five more. They do not cover this shape at all: they mutate the target while its caller still calls it, so the caller's own laws catch them through the call and a stand-in is never exercised. The escape has to be measured as **two files** — junk target plus caller rerouted — because either half alone is caught.

    **Why the gate is not simply tightened, which is the obvious first move.** Reading `gate.py:176-177` as a bug and skipping `Policy.` only in `PROOF.bend` would close the `t4-bst-insert` escape on its own — with the sole free name being `ins_at`, a junk `ins_at` would have nowhere to delegate to. It is not done, and the measurement is why: exactly **five** solution files in the bank declare a `Policy.*` name, all five of them mutants and none of them a reference or a stub (`t1-count-zeros/count-zeros-length`, `t2-min-laws/min-is-max`, `t5-opt-drop/opt-true-discards-1`, `t5-opt-drop/opt-ignores-caller-flag-1`, and this fact's new `t4-bst-insert/ins-at-answers-its-own-tree`). Four of those are expressing a wrong body that needs a second recursion of its own — the same checker constraint (a `match` cannot scrutinise a computed value) that put `ins_at` in `t4-bst-insert`'s stub in the first place — and a mutant has no stub to add it to, because `policy_targets` is the *solution's* allowlist and a wrong body is not a task obligation. Tightening the gate converts four strong mutants into tier-0 rejections, which is a corpus bug rather than a fix (Fact 22's tier-0 lesson, from the other direction: a tier-0 mutant says nothing about whether a law catches the body). The law-level repair costs nothing and holds regardless of what the gate permits, so that is the layer this is fixed at. It is recorded here so the next reader does not "fix" the gate and quietly break the corpus.

    Two `policy_targets` entries were stale in the same pass and were removed in `cd41717`: `t2-append-laws` and `t2-sum-laws` both listed `add`, while neither stub declares it, no reference defines it, no law mentions it, and `tools.mutate` generated zero `add-*` mutants for either — it looks for the def and finds nothing. Removing them only tightens the allowlist, and since the manifest hash covers LAWS/PRELUDE/SOLUTION rather than `meta.json`, the manifest is byte-identical afterwards.

34. **A fifth shape: the laws name the function, are true of it, and leave one branch of it unconstrained — so the wrong answer violates nothing that is written down.** Fact 29 is a branch no left-hand side reaches, Fact 33 a target no law names at all, and this is the case in between. Three instances, reported by prober-d on 2026-09-19 and all three reproduced here before anything was changed:

    | Task | What the laws pin | The branch left free | The body measured at 1.000 |
    |---|---|---|---|
    | `t4-queue-rep` | the contents, under a `P.wf` premise | `push` on `P.Q{Nil{}, b}` with `b` non-empty | answers `P.Q{x <> Nil{}, Nil{}}` — the back is dropped |
    | `t5-opt-drop` | `P.clean` of the output, plus equal meaning | the `Twice` under `True{}` | answers `P.Zero{} <> opt(t, True{})` |
    | `t4-bst-insert` | how `count` *changes* | `count` at any closed term | answers `1n + ` the real count |

    **Two of the three reached tier 4 against the _reference proof_**, which is a stronger kind of evidence than the earlier classes come with. Facts 29–32 each needed a hand-written proof to exhibit the hole, because the reference proof is written against the reference body's own unfolding and refuses to go through for a different one; that leaves a gap between "the laws are blind to this body" and "the body scores 1.000", and the gap is real — the `t2-append-laws` case below is exactly a body that is blind to the laws *and* provable, while its neighbour in the corpus is neither. Here the reference proof itself closes every law for the escaping body, so no such argument is needed: the hole is a submission away.

    **`t4-queue-rep`.** `push_contents` carries the premise `P.wf(q) == True{}`, and `P.wf` is false of exactly one state — an empty front with a non-empty back. That is precisely the state `push`'s first case covers. So the premise excludes the whole branch rather than constraining it, and a body that drops the back there is invisible to `push_contents` and to `pop_contents`. `push_wf` does not catch it either: the wrong answer is well-formed, so the invariant is maintained. Measured **tier 4, complete, reward 1.000, all five laws proven by the reference proof**. The repair is `push_empty`, the first case written out with no premise at all — `S.push(P.Q{Nil{}, b}, x) == P.Q{x <> Nil{}, b}` — which the reference proves `{==}` because it is its own body read back. After: the escape falls to **tier 3, reward 0.517**, failing at `LAWS.push_empty` with `expected prelude.Q{[x], []}` against `observed prelude.Q{[x], b}`; the reference proves all six; the escape joins the corpus as `push-drops-the-back.bend`.

    **`t5-opt-drop`.** The three optimiser laws pin what `opt` returns *up to* `P.clean` and equal meaning, and that is not the same as pinning the program. `clean` forbids a `Twice` where the accumulator is known to be zero, but it permits a `Zero`, and at a known-zero accumulator a `Zero` is a no-op — so an `opt` that answers `P.Zero{} <> opt(t, True{})` is clean *and* sound: `clean_opt` holds of it, and both soundness laws hold because the inserted `Zero` cannot change `exec(..., 0n)`. Measured **tier 4, complete, reward 1.000, all seven laws proven by the reference proof**. The `Twice`/`True` branch is the only one left free, and it is free for a reason worth naming: it is the only branch allowed to remove an instruction, so it is the only one the property-shaped laws do not pin from below. The repair is `opt_twice_zero` — `S.opt(P.Twice{} <> t, True{}) == S.opt(t, True{})` — the branch's definition, proved `{==}` by the reference. After: the escape falls to **tier 3, reward 0.537**, failing at `LAWS.opt_twice_zero` with `expected prelude.Zero{} <> solution.opt(t, True{})` against `observed solution.opt(t, True{})`; the reference proves all eight; the escape joins the corpus as `opt-leaves-a-redundant-zero.bend`. This is a tier-5 task, so it is the first hole found above tier 4.

    **`t4-bst-insert`, and this one is weaker evidence, said plainly.** `insert_count` is `count(insert(t, k), x) == count(t, x) + is_eq(k, x)` — a *difference*. The `1n` in a body `count(t, x) = 1n + <the real count>` appears on both sides and cancels, so the law is satisfied at every input, and no other law in the set applied `count` to a closed term. (The comment on the law claimed "the shape of the answer is what rules out a body that counts something else"; that was false, and is corrected in place.) The repair is `count_tip` — `S.count(P.Tip{}, x) == 0n` — the first law to name `count` at a closed term, and `count`'s base case, which together with the increment determines the function because every tree is reached from `P.Tip{}` by inserts. The reference proves all nine laws at 1.000 afterwards. **What is weaker is the demonstration.** Against the reference proof the escaping body reads **tier 2**, not 4: the reference's own `Policy.count_ins` helper is stated over `S.count` and its steps manipulate the reference body's unfolding, so it fails for a different body rather than proving it. Mechanising a 1.000 would need an agreement lemma relating `S.count` to a proof-local copy of the real count, and the obstacle is a checker rule worth recording: **a proof cannot cite a `Policy.*` name that `solution.bend` defines** — the error is `expected : a defined name / observed : Policy.count_go`, the same rule that makes a cross-module `Policy.` helper useless in Fact 33. So this escape is real but costs more to exploit than the other two, and the semantic catch is shown on the law in isolation instead: `LAWS.count_tip`, `expected 1n, observed 0n`, which no proof can repair. **No corpus entry was added for it.** A reference-proof run of the body reads tier 2, which is not the strong-mutant tier, and shipping it would put an entry in the census that measures the reference proof rather than the law set — the same confusion this fact is about. It is recorded here as a probe.

    The tell is one question and it subsumes the earlier two: **for each branch of the function, is there a law whose left-hand side reaches it with no premise?** Fact 29 asks it of a case that only a nested match reaches, Fact 33 asks it of a target that has no law at all, and this asks it of a branch that is reached only under a hypothesis or only through a property rather than a definition. The repair is the same every time and it is the one the bank now uses for definitional pins: **write the branch out as an equation, with no premise, and let the reference prove it `{==}`.** `push_empty`, `opt_twice_zero`, `count_tip` and the `ins_at` trio are all that move.

35. **A sixth shape, and the repair is a different one: every branch is reached, but the only law that reaches the recursive branches measures a *property* of the answer rather than naming it — and an invariant is satisfied by any permutation.** This is Fact 30's relative-property blind spot, and it is filed separately because the tell and the repair are both its own. Fact 34's question — "is there a law whose left-hand side reaches this branch, with no premise?" — answers *yes* here, for all eight branches; the set is not missing a case, it is missing an *absolute* one. One instance, reported by prober-b on 2026-09-19 and reproduced before anything was changed.

    **`t3-merge-len`.** `merge_go` has eight leaves. The five original laws reach exactly one of them: `merge_go_true` and `merge_go_false` are both stated at `merge_go(Nil{}, a, Nil{}, b, k)`, the leaf where both lists are exhausted, so between them they constrain the case `merge` produces only when it was handed two one-element lists. `merge_nil_l` and `merge_nil_r` pin `merge` at empty lists. Everything else is reached only through the recursion, and the one law that gets there — `merge_len` — sees the length of the result, so every permutation of the same elements satisfies all five. Two bodies were measured against the reference proof:

    | Body | The branch it changes | Measured before the repair |
    |---|---|---|
    | `mutants/merge_go-swap-args-27.bend` — recurses with `P.le(hy, hx2)` | `(hx2 <> tx2, hy2 <> ty2, True{})` | **tier 4, complete, 1.000**, with one citation patched in the reference proof |
    | `hx <> hy2 <> hy <> ty2`, not recursive at all | `(Nil{}, hy2 <> ty2, True{})` | **tier 4, complete, 1.000**, reference proof untouched |

    The first needed one edit to the reference proof — `P.le(hx2, hy)` to `P.le(hy, hx2)` at the two places in `Policy.merge_go_len` that name the decision — which is a citation an agent writing that body would have had to make anyway. **The distinction matters and is the reason this fact exists:** run against the *unpatched* reference proof, that same body reads **tier 2**, so the census screen ("no mutant reaches tier 4") never saw it and was not wrong to stay silent. A corpus tier is a statement about the law set **under the reference proof**; a hole is a statement about the law set **under some proof**. Only the second is a reward an agent can collect, and no corpus measurement taken with the reference proof can see the difference. The escape body was already in this task's corpus before the hole was known, filed as an ordinary generated mutant.

    **The repair is not Fact 34's.** A branch equation with no premise cannot express this one, because the branch is not what is unconstrained — the *decision* the branch is taken under is. The law has to carry the comparison as a premise on a binder of its own and conclude the step equation with the tails arbitrary:

    ```bend
    law merge_le_head:
      for hx: Nat
      for +tx: List<&2, Nat>
      for hy: Nat
      for +ty: List<&2, Nat>
      for e: {P.le(hx, hy) == True{} : Bool}
      {S.merge(hx <> tx, hy <> ty) == hx <> S.merge(tx, hy <> ty) : List<&2, Nat>}
    ```

    with `merge_gt_head` the `False{}` mirror, answering `hy <> S.merge(hx <> tx, ty)`. The two of them state *the list with the smaller head is advanced and the other keeps its head*, which is the specification of the algorithm rather than a transcription of a leaf, and with the tails arbitrary they reach every branch `merge` can produce. This is the second repair shape in the bank, and the more valuable one, because a submission can satisfy a transcribed branch without implementing the algorithm.

    **The premise has to be spent, and the proof is the price.** `k` is `merge_go`'s last parameter and `match` cannot scrutinise a computed value, so in the goal the decision sits as a stuck `P.le(hx, hy)` and the `match k` beneath it never fires — `{==}` is refused with `expected : solution.merge_go(tx, hx, ty, hy, prelude.le(hx, hy))` against `observed : hx <> solution.merge(tx, hy <> ty)`. The proof rewrites the decision *argument* with `Equal.cong`, whose motive is `k => S.merge_go(tx, hx, ty, hy, k)` and whose equation is the premise read as `P.le(hx, hy) == True{}`; the branch then computes. Four cases per law, one congruence each. Measured after: the reference proves all seven at **1.000**; the non-recursive escape falls to **tier 3, 0.529**, failing `LAWS.merge_le_head`; the swap-args body falls to **tier 2** against the reference proof and **tier 3**, failing the same law, with the citation patched. **The whole 43-file corpus was re-measured against the repaired set and no mutant reaches tier 4** — and the re-measurement is not optional, because changing `LAWS.bend` changes both the partial-credit denominator and what each law can catch, so every tier taken before the edit is stale the moment it lands.

    Amended in place, because the record was wrong rather than thin: the comment on `merge_go_true` said a body that "gave the pair the wrong way round" was caught, and `prompt.md` said the two decision pins stop an order-only-wrong body — neither was true of anything but the `(Nil{}, Nil{})` leaf. Both now say what was measured. This is the first hole found whose tell is a *missing absolute law* rather than a missing case, and the first whose repair needed a proof step the reference did not already contain.

36. **Three more holes, from the prober-a/prober-b sweep, and two of them are the strongest class this bank has.** Reported on 2026-09-19 and all three reproduced before anything was changed. Two are Fact 30's missing anchor at a *base* case rather than in an interior, one is Fact 34's branch no law reaches, and two were demonstrated at **tier 4, complete, 1.000 against the reference proof unchanged** — no adapted proof, no hand-written one.

    | Task | The free case | The body measured at 1.000 | Repair | After |
    |---|---|---|---|---|
    | `t1-mul-one` | `mul(0n, y)` for `y ≠ 1n` | `0n` case reads `b`, answers `1n` once `b ≥ 2n` | `mul_zero` | tier 3, 0.433, fails `LAWS.mul_zero` |
    | `t3-pad` | `pad(1n + n, x, Nil{})` | empty case answers `P.max(k, x) <>` the recursion | `pad_nil_step` | tier 3, 0.500, fails `LAWS.pad_nil_step` |
    | `t3-absdiff-comm` | `absdiff(a, b)` off both axes and off the diagonal | `E + E * min(a, b)` for `E = P.sub(a,b) + P.sub(b,a)` | `absdiff_succ_succ` | weaker evidence, below |

    **`t1-mul-one`.** The two original laws are `mul(x, 1n) == x` and `mul(1n + x, y) == add(y, mul(x, y))`, and between them the base case is pinned at exactly one point: the step at `x == 0n` with `mul_one` at `x == 1n` gives `add(1n, mul(0n, 1n)) == 1n`, so `mul(0n, 1n)` is `0n` and nothing said what `mul(0n, y)` was for any other `y`. The body answers `0n` for `y ≤ 1n` and `1n` above it, which keeps every product by zero from `2n` up at `1n`, and both laws still hold: `mul_one` closes because the `0n` case still answers `0n` at `y == 1n`, and `mul_succ` closes by reduction on both bodies alike. `mul_zero` restores the anchor. This is Fact 30's shape — the set is all relative properties and no absolute one — with the missing point at a base case rather than in an interior, and it is the *second* time this task's corpus had the right idea and the wrong reach: `mul-nat-base-off-by-one-2.bend` was already there and reads tier 1, because changing `case 0n:` to `case 1n:` is a parse-shaped mutation rather than a definition one.

    **`t3-pad`.** `pad_len` counts and `pad_step` needs a cons, so the one case neither reaches is a target that outruns an *empty* input: the count fixes how many elements the answer has and nothing says which ones. The body answers `P.max(k, x)` in front of the recursion, so the filler is replaced by the remaining count wherever that is larger. It clears `pad_single` because `P.max(0n, x)` reduces to `x`, and it clears `pad_len` because `max` does not change a length, so it proves all four laws under the reference proof unchanged and answers `[1n, 0n]` where `pad(2n, 0n, Nil{})` should be `[0n, 0n]`. `pad_nil_step` — the empty case of the step, read back — is the repair. Two things about *finding* this body are worth recording. It needs a Nat expression that is `x` at `k == 0n` and not `x` above it, and the obvious one, `P.sub(x, k)`, is unavailable: `sub` is not in this task's prelude, and a `Policy.sub` written into `solution.bend` cannot be cited from `PROOF.bend` at all (Fact 34's rule), so the escape would stall at `pad_single`'s proof no matter how it was written. `P.max` is the way through, and it works only because `max` steps on its *first* argument: at `k == 0n` the term reduces on its own. A prelude function that stepped on `b` instead would not have admitted this body, which is a reminder that the prelude is part of the law set's surface and not just its vocabulary. Second, the prompt had said **three** laws since `pad_step` was added — the task was repaired once before, in place, and the prose never caught up. Both the prompt and `t3-merge-len`'s are now consistent with their law files; the lesson is that a hole fixed without a prompt edit leaves the next reader measuring against a description that is one law behind.

    **`t3-absdiff-comm`, and this one is weaker evidence, said plainly.** The four laws pin `absdiff` on the two axes (`b == 0n`, `a == 0n`) and on the diagonal (`a == b`), and those three lines do not determine the function between them: nothing related `absdiff(a, b)` to `absdiff(a-1, b-1)`. The body answers `E + E * min(a, b)` where `E` is the sum of the two truncated subtractions — symmetric, vanishing on the diagonal because `E` does, and answering `b` and `a` on the axes because `min` is `0n` there — so it satisfies all four laws and answers `2n` where the reference answers `1n`. **It reads tier 2, not 4**, and the reason is structural rather than incidental: `absdiff_comm`'s step is `Policy.add_comm(P.sub(a, b), P.sub(b, a))`, which rewrites a subterm the reference body *is* rather than one it *contains*, so no body but the reference's own can clear it. The claim rests on the laws checked by hand on the axes, the diagonal and the symmetry — the same position as `t4-bst-insert` in Fact 34. `absdiff_succ_succ` is the repair: `sub` steps on both arguments at once, so the two arguments move together and the whole function follows from the axes by induction. **No corpus entry was added**, for the reason given there: a tier-2 body in the corpus measures the reference proof rather than the law set, which is the confusion Fact 35 is about.

    All four corpora this fact touches — the three above plus `t3-merge-len` — were re-measured against their repaired sets, and **no mutant in any of them reaches tier 4.**

37. **One candidate left open, and the reason it is open is the honest one: no mechanised proof was built, so there is no tier-4 reading and it is not a confirmed hole.** Reported by `tier2-author` on 2026-09-19 as the strongest of six "candidates" — bodies each statement is *true* of, where the reference proof stops only at a spelling it wants and a submitter would write their own. `t1-sum-append` is the one that survived adjudication, and one other in that list was withdrawn on inspection: `t1-add-plus`'s `add(a, b) = b + a` is not a wrong body at all, it is a second correct implementation of addition, so a solver who writes it has done the task.

    **`t1-sum-append`.** Both laws are about `sum` (`sum_append`, `sum_cons`) and `sum` cannot see a permutation, so the set never inspects `append`'s order — Fact 30's missing anchor, structurally identical to `t2-append-laws` before its Fact 32 repair, which is the precedent that makes this worth taking seriously rather than dismissing. The body recurses on its own list and pushes the head onto the other one, so it returns `reverse(xs) <> ys`: `append([1n, 2n], [3n])` is `[2n, 1n, 3n]`, and `sum` is unchanged because `sum(reverse(xs)) == sum(xs)`. **Measured 2026-09-19:** the bare body reads **tier 2 (checks), 0.100** — well-typed, and both laws are mathematically true of it — and **tier 3 (partial), 0.350** with the reference proof, which is the reference proof's shape failing rather than a law failing. So the entry is a *candidate*, not a hole, and the distinction is the whole of Fact 35: a corpus tier is a statement about the law set under the reference proof, and a hole is a statement about the law set under *some* proof.

    **Why no proof was built.** The step needs the reassociation every rotation needs, `sum(t) + (h + S) == (h + sum(t)) + S`, applied in a term where `sum(t)` is *evaluated* — and `t` is a `List<&1, Nat>` binder from the match, so it is Lone and may be spent live exactly once. The recursive call at `append(t, h <> ys)` already spends it. Every route tried arrived at the same wall: the lemma's first parameter has to be live (its proof cases on it), so passing `S.sum(t)` there is a second live use and the checker answers `observed : t (consumed more than once)`; stating the lemma over the list instead moves the case split onto a list parameter, which cannot be Many (`+xs: List<Nat>` is refused at `expected : Data / observed : Type`), so `sum(xs)` cannot be produced without spending the list. The `+k = k` rebinding does not apply to a list binder for the same modality reason. Fifteen proof shapes were tried; none checked. **This is a statement about this checker's linearity, not a proof that no body escapes** — a stronger proof system, or a different formulation of the arithmetic, might close it. The bank should either build the proof and add the order-observing law if it reads tier 4, or record the body in the corpus at tier 3 as a *known-reference-proof-shape* case and say so. **Resolved on the first of those routes, without the proof — see Fact 38: the law was added on the anchor argument, which is readable off the two laws and needs no escape to justify it.** The proof itself was still never built, so the escape remains unmeasured and is not entered as a confirmed hole.

    Two further candidates from the same sweep are in the same state and are recorded here so they are not re-discovered as new: `t3-isort-sorted` (ignores length ≥ 3) and `t3-rev-rev` (the element action is unobserved), both reported by prober-b as semantic-only gaps with no proof built. **Both were probed and repaired on 2026-09-19 — see Fact 39.** Unlike the case above, each of these has an escape body that was written and measured, so the repair rests on a body rather than on a reading of the laws alone.

38. **An anchorless law set was repaired without proof that anything escaped it, and that is a different justification from the thirty-three.** `t1-sum-append`'s set was `sum_append` and `sum_cons`, and **every occurrence of `append` in it sits under `sum`** — the function the task is about is reachable in the laws only through a predicate that cannot see a permutation. So the set constrains `append` up to the multiset of its elements and says nothing about their order: Fact 30's "no absolute anchor," with a permissive `sum` where `t2-append-laws` had a counting `len`. That is a statement about the two laws, and it is checkable by reading them; it is not a statement about a body, and it does not need one.

    **The repair adds the two laws Fact 32 added, in the same shape.** `append_cons` (`S.append(h <> t, ys) == h <> S.append(t, ys)`) puts the head of the first list at the front of the answer, and `append_nil_left` (`S.append(Nil{}, ys) == ys`) makes the base a value rather than a sum. Together they are `append`'s definition written out and determine it by induction on the first argument — the same two laws, with the same job, that `t2-append-laws` needed. Both are definitional for the reference, proved with `{==}`, and **the reference re-measured tier 4, complete, reward 1.000, four of four.** The count moved from two laws to four, so partial credit on this task is now in quarters rather than halves and every existing mutant re-tiers; all five read tier 3 and none reaches tier 4.

    The rotation body is now `mutants/append-rotates-the-front.bend`. Measured 2026-09-19 against the repaired set: **tier 3 (partial), failing `append_cons` and `sum_append`**, with the checker's own error at `LAWS.append_cons` reading `expected : solution.append(t, h <> ys) / observed : h <> solution.append(t, ys)`. The reward is withheld on top of the tier, because the file is byte-identical to a shipped mutant and SPEC 7.4.2's tripwire fires — which is the tripwire working, not a second measurement. **What is caught here is caught for real**: `append_cons` is *false* of the rotation body, not merely unproven by the reference proof, so no hand-written proof could recover it. That is the difference between this entry and the ones Fact 35 warns about, and it is why the body could be filed at all.

    **What is not claimed.** The escape was never proved and this is **not** entered as a confirmed full-reward hole; the count at the head of this section is not moved by it. What justifies the law is the anchor argument, and a stronger law set cannot create a hole — it can only close one — so no escape is needed to license it. The honest limit on that is the same one Fact 37 records: fifteen proof shapes failed on this checker's linearity, so the possibility that the rotation body was provable against the old two laws is *unrefuted*, not established either way. The prompt was updated with the two new laws and their law-defs in the same pass.

39. **The two remaining candidates were probed with bodies, and both were real: each law set was missing an axis, and each repair is a law that observes it.** Fact 37 listed `t3-isort-sorted` and `t3-rev-rev` as unprobed. Both now have an escape body written, measured and filed, and in both the body type-checks bare — **tier 2, 0.100** — which is the signature of this class: the function is well-defined and well-typed, and only the laws are blind.

    **`t3-rev-rev` — the element action is unobserved.** `rev_append` and `rev_rev` together say `rev` is an anti-automorphism of `append` that is its own inverse, and on the free monoid that pins `rev` only up to a fixed involution of the elements: "reverse, and map every element by the same involution" satisfies all three laws, has the right length, and reverses correctly. The body filed is `mutants/rev-maps-the-elements.bend`, the reference with `Policy.swap01` (an involution: `0n ↔ 1n`, every other `Nat` fixed) applied to each head, so `rev([0n, 1n])` is `[1n, 0n]` where the reference answers the same thing for `[1n, 0n]` — the two inputs are indistinguishable under a permutation, which is all the old set could see. **The repair is `rev_singleton`**, `rev(x <> Nil{}) == x <> Nil{}`: a one-element list has nowhere for a permutation to hide, so this is the law that observes the element itself. It closes by direct computation for the reference and was proved with `{==}`. It is also *complete*, not just sufficient: with it, `rev(append(xs, y <> Nil{}))` unfolds to `append(y <> Nil{}, rev(xs))` by `rev_append`, so `rev` is determined everywhere and no second involution survives. Reference re-measured **tier 4, four of four**.

    **`t3-isort-sorted` — nothing counted.** All five original laws were sortedness predicates or statements about literal lists of at most two elements, and a list with elements missing is still sorted. The escape filed as `mutants/insert-drops-the-tail.bend` hands `P.insert_put` an empty list where the reference hands it the tail the cons step just matched, so an insertion into any list of two or more elements answers a two-element list: `isort([1n, 2n, 3n])` is `[1n, 2n]`. It clears `isort_sorted` and `insert_sorted` because the answer is sorted, clears `insert_le`, `insert_gt` and `isort_swap` because those laws only ever reach a one-element list, where the tail *is* the empty list. **The repair is `insert_len`**, `P.len(S.insert(xs, y)) == 1n + P.len(xs)`, which counts and is therefore false of the escape by four against two on a three-element argument. This task's prelude had no `len`, so the repair also had to add one — the law cannot be stated without it — and the step's proof passes through a new `Policy.insert_put_len` helper — four cases over the list and the decision, with the recursive case an `Equal.sym` around the recursive call because the rewrite fills the hole where the equation's *right* side sits. Reference re-measured **tier 4, six of six**.

    **What is claimed, and what is not.** Both escapes are *measured* — written, type-checked, and shown to satisfy every law the set had by the structural argument each entry records — so these are the first two candidates in Fact 37's list that rest on evidence rather than on a reading. Neither is entered as a confirmed hole either, and for the reason Fact 35 gives: no proof of the escape was built, so what is measured is that the body is well-typed and that the old laws are true of it, not that a submitter could have been *paid* for it. The repairs do not depend on that distinction — the missing axis is visible in both cases without a body, in the same way Fact 38's was — and the two bodies are now corpus entries that their repaired sets reject: `rev-maps-the-elements.bend` and `insert-drops-the-tail.bend` both read tier 2 with the reference proof, and both fail the new law for real, not merely by the reference proof's shape. **Every other mutant in both corpora was re-measured**: 9 in `t3-rev-rev` and 15 in `t3-isort-sorted`, none above tier 3, both tasks `1/1 valid`. The counts moved from five laws to six and three to four. **`t3-rev-rev`'s forged review record is now stale as well** — no human read those laws, and editing `LAWS.bend` has invalidated the hash the record attests to, the same silent invalidation Fact 37 records for `t3-pad`.

40. **Fact 33's shape had four more instances than the bank knew, and all four are now anchored — none with a measured escape, and that is stated rather than papered over.** A bank-wide screen run by `tier3-author` looked for the question Fact 33 asked, in a sharper form: *does any law relate the target to something outside the target set* — a primitive, a constructor, a literal, a prelude function, or a target that is itself pinned? Everything it flagged falls into benign shapes except one family: a target that is named by a law **only on a right-hand side**, never applied on a left-hand side and never related to anything outside the set. Fact 33 found and repaired exactly that in `t1-mul-zero/add`. The same shape was still live in `t1-double/add`, `t1-mul-one/add` and `t2-mul-laws/add`.

    **The four repairs.** `add_plus` — `S.add(x, y) == x + y` against Base's `+`, with `Policy.add_plus` as the helper and `L.add_plus` as the one-citation proof — goes into `t1-double`, `t1-mul-one` and `t2-mul-laws`. The helper text is `t1-mul-zero`'s **verbatim**, because all four stubs declare the same `add(a: Nat, b: Nat)` shape. `t2-sum-laws` needed the pair Fact 38 gave `t1-sum-append`: its two laws are about `sum`, and a sum cannot see a permutation, so `append(xs, ys) = reverse(xs) <> ys` satisfies both — and satisfies `append_nil_left` too, which is why the nil law alone would not have closed it. `append_cons` and `append_nil_left` both go in, each closing by reduction for the reference.

    **Verified, not taken on report.** All four re-measured **tier 4, complete, 1.000**, with every pre-existing law still proven: `t1-double` 3 of 3, `t1-mul-one` 4 of 4, `t2-mul-laws` 3 of 3, `t2-sum-laws` 4 of 4. Every mutant in all four corpora re-measured, 82 files in total, **none above tier 3**; all four tasks `1/1 valid`. No corpus entry was added, for Fact 35's reason: nothing here is a measured escape, so a body would measure the reference proof rather than the law set. The four prompts carry the new laws and their law-defs.

    **Two rows of the sweep's table were already stale.** It listed `t1-sum-append/append` and `t3-rev-rev`, both with proposed one-line laws (`append_nil_left`, `rev_single`) — the first is Fact 38, which shipped `append_nil_left` *and* `append_cons`, and the second is Fact 39, which shipped the same law as `rev_singleton`. Neither file was touched by this pass. The sweep's own reading for `t3-rev-rev` — "tier 2, failing at `Policy.rev_snoc`; adds no independent kill" — is the `gavel-proof-outruns-the-laws` confusion in its exact form, and it is worth stating plainly because it is the reason this pass treats the *anchor* as the test: **a mutant reading is a statement about the law set under the reference proof, and a hole is a statement about the law set under some proof.** The policy writes its own `PROOF.bend`, so "the reference proof happens to be more specific than the laws" is not a defence — it is the defect. `t3-rev-rev`'s element-blindness was in fact closable by a submitter who wrote the three-line algebra; that is why Fact 39 filed it as a candidate and repaired it.

    **What this does not claim.** These four are repairs, not holes: on the anchor argument, and not entered into the count. The count at the head of this section is moved by Fact 41 and not by this one, and Facts 38, 39 and 40 are all outside it — 38 on a reading of the laws alone, 39 on bodies without proofs, 40 on a reading plus the Fact 33 precedent. What they share is the shape of the justification: a law set that never applies its target, or never relates it to anything outside itself, is defective on inspection, and a stronger law set can only close a hole, never open one — so no escape has to be exhibited to license the tightening. **The screen flags and the reads are `tier3-author`'s; the four repairs, their verification, and the corpus and validator re-measurements above are this session's.** The `LAWS.bend` edits carry `meta.json` and the manifest entry hash, republished per task; no review record was touched, so the stale-record count in M4 stays at three.

41. **A `bst` leaf that ignores its accumulator earned a full reward on a tier-4 task that was already certified, and the hole was in a law's *reach* rather than in its statement.** `t4-inorder-transport`'s `inorder_sorted` was for a long time the only law naming `bst`, and it instantiates the range accumulator at the literal `True{}`; every recursive `bst` call threads either that literal or the accumulator it was handed, so `bst(t, lo, hi, False{})` was unreachable from every law in the set. A body whose leaf answers `True{}` instead of the accumulator is therefore **the reference function on every term any law mentions** — not merely law-satisfying by some algebraic accident, but identical on the whole observable domain — and the requisite proof is the reference's own `Policy.bst_ind` with `k` fixed to `True{}`.

    **Measured before claimed.** The body is `mutants/bst-tip-ignores-the-accumulator.bend`; the proof is the reference's induction specialised to `k = True{}` (every call site in the reference is already at that instantiation, so the specialisation type-checks unchanged). It read **tier 4, complete, reward 1.000, all six laws proven**. What makes that worth a line is where it was found: the task had already been authored, verified at tier 4 by its author, swept, censused and committed before this body was written, and every reading in that chain was correct — the reference really did prove all six laws, and the corpus really did contain no escape.

    **The repair is the `bst` shape pair**, `bst_tip` and `bst_bin`, mirroring the `inorder_tip`/`inorder_bin` pair that already pins `inorder` for exactly this reason. They are the definition read back, `{==}` proves both, and they are two laws rather than one because the leaf case alone leaves a body wrong in the node case. Reference re-measured **tier 4, eight of eight**; the escape re-measured **tier 2**, failing at `bst_tip` with `expected : {k == True{}} / observed : {True{} == True{}}`; all 15 mutants in the corpus re-measured, none above tier 2; the task validates `1/1`. The prompt carries the two new laws and their law-defs.

    **The correction that matters more than the repair.** The law file had argued the converse in writing: "The premise is not vacuous, and a mutant cannot make it vacuous ... a body that drops a conjunct changes the shape of `S.bst(t, lo, hi, True{})` and the projections stop type-checking." Both halves of that are true and neither is on point, because **they are statements about the reference proof, and the reference proof is not the test — the policy writes its own.** The same confusion is what made `t3-rev-rev`'s screen read as benign in Fact 40. It is the `gavel-proof-outruns-the-laws` rule stated from the other side: where a law set is blind the reference proof usually closes it, and *usually* is not *always* — so a blind law set is a candidate until somebody writes the proof, and an argument from the reference proof's shape is evidence about the bank's proofs rather than about its rewards. The standing prompt at the head of this section needs one more clause for it: **not "which wrong function do the laws fail to distinguish", but "which input can no law reach at all".** Here the answer was a constructor case with a literal accumulator, and it took a body to find.

    **The same question swept over the rest of the bank, and the answer is a rule rather than a list.** There are 19 conditional laws across 9 tasks — every law with a `for e: {...}` premise binder. In 18 of them the premise is a prelude predicate applied to the *input*: `P.le` in `t3-filter-bound`, `t3-isort-perm`, `t3-merge-len`, `t3-bst-insert`'s two literal-list laws and `t3-isort-sorted`'s three, `P.is_sorted(xs)` in `insert_sorted`, `Nat.is_lt(k, P.len(xs))` in `t4-nth-maybe`, `P.ordered(t)` in `insert_ordered`, `P.wf(q)` in `t4-queue-rep`, `P.wf`/`P.closable` in `t4-stack-wf`. A universally quantified input cannot be falsified by a submission, so none of those premises can be made vacuous and none of those laws can be made unreachable. **`t4-inorder-transport` was the only one whose premise named a function the policy implements** — `S.bst` — and it was the hole. So the test is mechanical and it is the one to add to the screen: *does the premise's subject belong to the submission?* Yes means the law can be defeated by falsifying its own hypothesis, and the target needs a shape pin beside it.

    `t4-inorder-transport` carries no review record, and its forged-record state is unchanged — this repair added none and deleted none.

42. **Seventeen new tasks went in with 32 escape probes written against them, and none escaped — which is a statement about the probes as much as about the tasks.** The batch is six tier-1 tasks (`t1-assoc-keys`, `t1-assoc-values`, `t1-count-while`, `t1-diffs-laws`, `t1-drop-while`, `t1-take-while`) and eleven tier-2 ones (`t2-assoc-count-key`, `t2-assoc-lookup`, `t2-assoc-update`, `t2-chunk-two-join-two`, `t2-count-up-down`, `t2-pairs-laws`, `t2-partition-below`, `t2-run-max-laws`, `t2-scan-add-laws`, `t2-span-below`, `t2-zip3-laws`), authored by four parallel agents against the brief in `/tmp/gavel-authoring-brief.md`. Every one was re-run through `tools/author.py` by me after the agent reported it, and all seventeen reached exit 0 with no stage refused; the batch adds 73 law names with no collision against the bank's 315 and none inside itself, no stub ships its reference, and every declared target is named by at least one law.

    **The probe is the reference proof against a degenerate body, and the reading is the tier rather than the reward.** Every probe body is the reference `solution.bend` with one substitution, or a solution-local `Policy.*` step with one branch changed, so the signature and the linearity sigils always match; the proof is the task's own reference `PROOF.bend` unchanged. A law set that proves all of its laws for such a body is a hole, and none of the 32 did. Two instrument errors turned up on the way and both are worth the line. First, **a shape rejection is not a kill**: three of my first probes read `tier 1` with `expected : Data / observed : Type` at the definition, which is the checker refusing the *body I wrote*, and it took a corrected binding — `+h` for a head used twice — before the probe measured a law at all. Second, **the reward field is not the reading**: `t1-take-while`'s "take nothing" body read `tier 3, proven 1 of 3` and `reward 0.000`, because SPEC 7.4.2's incident path (`gavel/check.py:_mutant_incident`) zeroes the reward when a submission is byte-identical to a shipped mutant — the corpus had independently generated the same degeneracy. The tier and the failed-law list are the measurement; the reward can be zero for a reason that is the bank working.

    **What the batch is, in the shape §3.9 already records.** Seventeen law sets over ten things a policy learns. `count_while`/`drop_while`/`take_while` are one template — a predicate-driven left walk with `nil`, `keep` and `stop` laws differing only in which of the two `keep_put`/`drop_put`/`count_put` helpers the prelude supplies. `partition_below`/`span_below` are one template over `PairL`, differing in the stop branch. `run_max`/`scan_add` are one template — a scan whose inductive law carries a `_after` helper for the accumulator. `diffs`/`pairs` are one template (adjacent *overlapping* pairs, one extracting a difference and one packaging), while `chunk_two` is the *disjoint* pairing and its inverse `join_two`, which is why it carries the round-trip law `chunk_two(join_two(ps)) == ps` that the other two cannot state. The five `assoc_*` tasks split three ways: `keys`/`values` are projections with the same four-law skeleton, `count_key`/`assoc_lookup` share `key_select`, and `assoc_update` is its own. `count_up_down` and `zip3` are each alone. That is the same discount §3.9 applies to the arithmetic family, and it is recorded here for the same reason: seventeen tasks is not seventeen lessons.

    **The probes did find the shape boundaries, and each one is the law the comments claim kills it.** `cw-count-everything` (a count that never consults the threshold) is killed by `count_while_stop`; `dw-drop-nothing` and `tw-keep-everything` by their `stop` law with the *other* branch proved; `rm-no-running-state` (a map that never threads the maximum) by `run_max_append` alone; `z3-ignores-zs` by `zip3_cons` alone, with `zip3_len` proved — a body that consumes one element from each list has the right length and the wrong contents, which is why that set carries both. `ak-put-noop` (an `assoc_put` that returns its list) is killed only by `put_cons` and `keys_put` and survives `keys_cons` and `keys_len`, so the `put` law is load-bearing rather than decorative. `cu-cons-not-snoc` (a `count_up` that conses where the law says `snoc`) is killed by `count_up_succ` and `len_count_up`, which is the reading that rules out the suspicion that `1n + k` in that law's left-hand side is stuck and the law vacuous: a vacuous law cannot kill a body.

43. **Three more tasks went in, and all six of their base-case laws had no mutant evidence — while every stage passed and the bank validated.** The three are `t2-longest-row` (`map_len`, `longest_row`), `t2-snoc-front-each` (`snoc_each`, `front_each`) and `t3-swap-sum-pair` (`swap_each`, `sum_pair`), left in the working tree by an authoring agent with generated-only mutant corpora of 8, 13 and 8 files. All three were re-run through `tools/author.py` by me: the two tier-2 ones reached exit 0 and published; the tier-3 one stopped at `[hold] review` with exit 3, which is the pipeline working — it cannot write a review record and will not publish without one, so it sits on disk unregistered until a person reads its six laws.

    **The screen and the probes.** Six policy targets, none of which appears anywhere else in the bank, and the batch's sixteen law names collide with no other task's; no stub ships its reference. Ten escape probes were written against the three law sets — the degenerate pair, the "drops every row" pair, the "first row only" pair, the identity pair, the swapped pair, and for the third task a `swap_each` that leaves its records alone and a `sum_pair` that adds only the first one. **None escaped.** One probe measured `tier 1` and is not evidence: `map_len(xss) = xss` is a shape rejection (`List<&2, List<&2, Nat>>` where `List<&2, Nat>` is wanted), which is Fact 42's first instrument error, hit again.

    **The finding is the kill measurement, and it is Fact 42's shape one level up.** Every task's empty case — `map_len_nil`, `longest_row_nil`, `snoc_each_nil`, `front_each_nil`, `swap_each_nil`, `sum_pair_nil` — had **no type-checking mutant failing it**. The generated corpora rewrite a *step*, and a base case is an *answer* reached by a match that has already stopped, so all 29 generated mutants leave it alone. What makes this worth a Fact rather than a footnote is that **nothing refused**: `stage_mutants` passed (`2 of 8 strong`, because one strong mutant is all it asks for), V2 passed, V3 passed, and `validate` would have reported the task valid. A law nothing kills is not a V2 failure — it is a law whose *evidence* is absent, and the only reading that names it is the per-law kill count. Six hand mutants were written, one per law, each measured at tier 3 with its target law in the failed list, and each stamped with that verdict in its header. This is the second time in two days: the 17-task batch of Fact 42 created 26 of the same, and the bank-wide metric is what found those.

    **The bank now reads `144/144 valid over 3,158 checker runs`, `mean 4.53, min 1`, calibration `0 of 144`.** The mean fell from 5.16 to 4.53 across the two batches because 32 laws that had no evidence now have exactly one mutant each — a law with one killer pulls the average down, and that is the honest direction for the number to move.

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
| Trajectory is one line **per turn** (§13.1) | One line **per episode**, with the turns nested | M3.2. The per-turn fields that do not vary within a run — `run_id`, `bank_hash`, `bend_version` — move to the episode level instead of being repeated; every per-turn field of §13.1 is still present, nested under `turns`. A line per turn also means concurrent envs interleave turns from different episodes in one file, and the reader has to regroup them to compute anything. |
| Cache key is `(toolchain_hash, task_hash, submission_hash)` (§2) | Also `bend_version`, `bun_version`, `backend`, `limits`, the **mutant corpus**, and a schema version | M3.2. Each of those moves the verdict. The two easy ones: a verdict produced under the plain backend cannot be served as a sandboxed one, and a task's mutants live in `references/` rather than in the task's own files, so regenerating the corpus changes the answer (SPEC §7.4.2) without changing any hash the task carries. |

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
  through the gate, records `reference_check_ms`. Also reports each task's
  review state (`none-needed` / `unreviewed` / `stale` / `current`) and, over
  the tasks it was given, SPEC §12's four environment-quality metrics — see
  M4.5. The metrics are in `--json` and the review state is in both; `--json`
  emits the document and nothing else, so it can be parsed.
- `tools/mutate.py`: rule-based mutants over the reference solution: swap
  match arms, drop a cons, off-by-one on `Nat` literals, replace recursive
  call argument with the parameter, swap operands.
- `tools/calibrate.py`: k zero-shot attempts with a configurable model via the
  env API; writes `zero_shot_solve_rate`.
- `tools/publish.py`: hashes the task, appends to `manifest.json`.
- `tools/migrate.py`: re-validates the whole bank against a new toolchain and
  writes a quarantine report.

### 3.9 The tiers

SPEC §10 defines five tiers by proof technique rather than by code length, and
the milestones below are written in those numbers. The definitions are SPEC's;
they are repeated here because M2 ("tiers 1–4") and M4 ("including tier 5") are
phrased in tiers that a reader of this file otherwise cannot decode.

| Tier | Proof technique | The bank's example |
|---|---|---|
| 1 | Reflexivity, direct computation | `t1-add-plus` |
| 2 | Single structural induction, one rewrite | `t2-rev-append` |
| 3 | Induction with auxiliary lemmas the policy must state | `t3-tree-flatten` |
| 4 | Invariant preservation over a data structure | `t4-stack-wf`, `t4-queue-rep`; `t4-nth-maybe` is the same tier stated as a *domain* instead of an invariant |
| 5 | Program-level laws with state and multiple interacting functions | `t5-run-effect` |

**The bank's ceiling is tier 5.** Of the 144 registered tasks, 26 are tier 1, 79
are tier 2, 31 are tier 3, 5 are tier 4 and 3 are tier 5. One more tier-3 task
(`t3-swap-sum-pair`) is on disk and unregistered, held at the review checkpoint
Fact 43 records. No tier is empty, so what M2's 200 and M4's 500 are short of is
volume rather than a design nobody has done yet.

The last 39 of those are a 35-task batch from the two authoring agents, the
third tier-5 task (`t5-opt-drop`), the third and fourth tier-4 ones
(`t4-queue-rep`, `t4-nth-maybe`) and the Bool-fold duality (`t3-neg-all-dual`),
and the tier-2 half of the batch is a *family*.
Its twenty tasks are four list functions — `all_<f>`, `sum_<f>`, `has_<f>` and
`<f>_all` — instantiated at ten arithmetic predicates (`mult3`, `mult5`, `cube`,
`dec2`, `mod3`, `mod5`, `pow2`, `sq-inc`, `succ2`, `triple`), each carrying the
same two laws with its own predicate substituted. They are distinct tasks:
distinct targets, distinct law names, no collision with anything already in the
bank, and each one validated on its own. But a policy that solves one of them
has learnt nearly all of the others, so they are closer to twenty lessons on one
template than to twenty lessons, and that is a fact about the bank's *effective*
size. It is recorded here rather than left inside the count, because the count
is what M2 is measured by and the difference between 144 tasks and 118 distinct
problems is exactly the kind of gap that reads as progress in a total and
disappears in a curriculum. The 17-task batch of Fact 42 carries the same
discount on the same basis, and its ten templates are listed there rather than
re-derived here. Fact 43's three add no discount: each has targets no other task
in the bank names.

One task in the batch is the same function as a committed one at another tier,
and the distinctness rule that would have parked it is deliberately not applied.
`t3-sum-acc` and `t2-sum-acc` both ask for `sum_acc(xs, acc)`; what differs is
the proof. The tier-2 laws carry the accumulator universally quantified so that
it passes through the step unchanged, while the tier-3 laws need the solver to
invent the *generalized* invariant, because their step needs the hypothesis at
`a + h` and the law as written only gives it at `0n`. That is what a tier
boundary buys, and the bank already ships one function across tiers on the same
basis (`append` at 1 and 2, `sum` at 1, 2 and 3). It is recorded as a judgement
rather than a rule because the rule applied literally — any name that occurs as
another task's target is a variation — would strike those too. Its cost is the
one `t4-stack-wf` carries: the two pin laws determine the body, so every mutant
dies on a pin and the value laws take no independent mutant weight.

Tier 4 is the first tier whose *law* is about a predicate the task declares
rather than about a function it defines. `t4-stack-wf` states it in the
smallest form the bank has: `step_wf` says that a stack satisfying `P.wf` still
satisfies it after the machine reads one more symbol, under the side condition
`P.closable` that a closing bracket needs something to close. `t4-bst-insert`
carries the same shape over a search tree (`insert_ordered`, with the premise
that the input was ordered), plus `insert_count` to pin the key that goes in.
Both are minimal on purpose: the law is the invariant, and the side condition is
what makes it a conditional rather than a claim the checker should reject.

`t4-queue-rep` is the third, and it changes what the invariant is *about*. The
first two state theirs over a value the policy built by recursion — a stack's
bracket count, a tree's ordering — while this one states it over a
*representation*: the queue is two lists, `P.Q{front, back}`, and `P.wf` says the
front is empty only when the whole queue is empty. The distinction is not
decorative. A representation invariant makes an operation's *shape* provable
rather than its output merely checkable: `push_wf` rejects a push that conses
onto the back unconditionally even though the result is right as a sequence, and
`pop_wf` rejects a pop that leaves the front empty. Together they force the
two-list queue's actual algorithm — push into an empty front, and reverse the
back into the front when the front runs out — without any law mentioning the
amortised cost that motivates it.

`push_contents` is the conditional in the shape the first two established (a
premise binder on the invariant), and its premise is load-bearing in the strong
sense: the law is false without it at the empty-front queue, and inside the proof
the premise is *consumed* — that branch has to derive `b = Nil` from
`P.wf(Q{Nil, b})` and otherwise transport along `False == True`. That only one of
the five laws needs it is what the mutants measure: `push-to-front-1` fails
`push_contents` alone, `push_wf` alone rejects the always-to-the-back and the
dropping bodies, and the pop bodies are rejected by `pop_wf` and `pop_contents`.
The pop attribution carries a caveat worth recording. V2 measures a mutant
against the *reference proof*, so a mutant can fail a law because the reference
proof's body no longer type-checks against the mutant's goal rather than because
the law refutes the mutant's body. `pop-back-unreversed-1` is that case — running
its isolation file by hand gives `expected : {imp(is_nil(b), True) == True} /
observed : {imp(is_nil(rev_go(b, [])), True)}`, the reference proof failing to
apply — and the law does refute the body too, but by a route the V2 number alone
does not show. The corpus is strong in V2's sense on all seven mutants (each
type-checks bare, none reaches tier 4) and measures tier 3.

`t4-nth-maybe` is the fourth, and it changes the subject once more: not an
invariant an operation preserves but the *domain* of a partial function. `nth`
answers `Maybe<&2, Nat>`, and the two laws that carry the tier say where that
answer is defined — `nth_some` under the premise `Nat.is_lt(k, P.len(xs)) ==
True{}` and `nth_none` under the same equation against `False{}`. The premise is
base's own comparison rather than a predicate the task invents, which matters
because the policy cannot edit it, and it is what makes the pair a conditional
rather than a claim the checker should refute on the empty list. The proof uses
it rather than assuming it: at the recursive call the hypothesis has to hold at
`p` and `t`, and it does without a lemma — `P.len` and `Nat.cmp` both reduce
through the `1n`, measured — while in the branches where the list has run out the
premise has reduced to `{False{} == True{}}` and the goal follows from it by
transport along an `ite` indexed by the boolean.

Its design is the answer to the limitation `t4-queue-rep`'s cost names above. The
value half is the two clauses of the walk and together they determine the answer
on every cons, so a bare `nth(k, Nil{}) == None{}` clause would have taken the
domain pair's weight, exactly as the pins take `t4-stack-wf`'s, and the bodies
wrong only on the empty list would have been killed by the clause with nothing
left for the law the task is about. There is no such clause. The emptiness is
pinned by `nth_none` alone, where the premise reduces to `{False{} == False{}}`,
which holds — so every index is out of range on `Nil{}` and the law is not
vacuous there. Measured on the seven-mutant corpus: `nth-nil-some-1` and
`nth-step-nil-some-1` are rejected by `nth_none` and by nothing else, and
`nth-step-none-1` is rejected by `nth_succ` and `nth_some` together. All seven
type-check bare and none reaches tier 4 (1/1 valid, 15 checker runs). The
conditional half therefore carries mutant weight, which is the property the
three tier-4 tasks before it each gave up something to get — the queue by
consuming its premise in the proof, this one by declining to state the case the
law already covers.

A fifth tier-4 task is in flight and it is worth recording how it was almost two,
and then what it took to settle which one. The shape is a predicate transport
between structures: a `Tree` fold and a list fold over the same traversal, with
the tree's predicate moved onto the list the traversal produces, and the
accumulator threaded identically on both sides so the step is convertible without
Boolean algebra. Both authoring agents proposed it the same day, independently,
each having checked that `inorder` was free at HEAD and each having found it free
— because neither had registered it, and the prototypes lived in `/tmp`, which
the other cannot see. tier3-author's scratch version even reused `t4-bst-insert`'s
own `ordered`, `all_le` and `all_ge` verbatim, so the two were the same task twice
rather than two tasks. The lesson is not about this task — it is that the
distinctness check has to run against *unregistered* work too, and a scratch
prototype is invisible to a grep of the manifest, so two agents can pass the same
check and still collide.

The first ruling was wrong, and how it was wrong is the part worth keeping. It
went to tier2-author, on the strength of a law (`inorder_head`) that is
order-sensitive without being a definitional unfolding, against a version whose
only order sensitivity was its two shape pins. That reasoning rested on a
verification I ran myself — the reference closes, and a right-subtree-first
traversal is rejected — and the verification had a hole: it tested right-first
and not **root-first**. tier2-author found the preorder body, and it passes all
three laws of that set (the transport is a conjunction over a permutation-blind
fold; `inorder_head`'s premise empties the left traversal, which collapses a
preorder LHS onto the head law's right-hand side exactly; the measure counts
without looking at where anything sits). So the set did not pin the traversal at
all. tier2-author rebuilt it with a definitional unfolding pin, measured that the
pin then carried the whole corpus weight with the transport — the law the task is
about — catching nothing alone, and reported that plainly rather than shipping it
as green. That is `t3-sum-acc`/`t4-stack-wf` again, now self-diagnosed.

The resolution is the design tier3-author had measured while that was happening:
`inorder`, `bst` and the two decision-parameterised folds as **four** policy
targets, with the sortedness law `bst(t, lo, hi) ⟹ sorted_put(inorder t, lo,
True{})` beside the two bound transports. The mutant-to-law table is measured,
one body per group: `inorder` mutants die on the pins, `bst` mutants (weakened
*and* strengthened) on `inorder_sorted` alone because the reference proof
projects the invariant's conjuncts, and each fold mutant on its own transport.
That is four law groups each carrying a kill, which is the property no tier-4
task in the bank has — every one of them collapses onto its pins. It is also why
the competing version was worth rejecting: Option A (`inorder` alone, either
law set) can only ever put the weight on an unfolding. tier3-author authors the
task, not because of the ruling but because they hold the green six-law proof and
the proof is the expensive artifact; tier2-author's staged version is parked under
`_abandoned/t4-inorder-transport-tier2/`, and their finding is what forced the
better design. The park happened on 2026-09-18 rather than at staging time, and
the delay was a live hazard worth naming: `tools.publish` walks `tasks/` and
describes whatever it finds, so with the staged dir sitting at `tasks/4/` a
publish by anyone would have registered a third tier-4 `inorder` task into a
124-task manifest — and re-publishing was exactly what the soundness repair below
required. The parked copy keeps both the task dir and the reference dir, so the
prototype is intact and re-derivable; nothing is deleted.

None of the four tier-4 tasks carries a review record. Tier 4 is gated on one in M4, and
not writing one is the point of Fact 27: a record is not evidence, so leaving
it absent is the only honest state until review happens somewhere the pipeline
cannot write — which since the Fact 27 repair is `reviews/<task_id>.json`, a
path the pipeline reads and does not write.

Tier 5's two canonical examples in SPEC §10 (`you_cant_win`, a ledger summing
to zero) are not in the vendored tree: `toolchain/2.0.5/bend2/` is `main.ts`,
`bend.ts`, `comp.ts`, `base.bend` and `effs/`, with no `demos/`. Tier 5
therefore had to be written fresh, and `t5-run-effect` is that task: a
two-instruction machine whose program text is read two ways, `run` executing it
and `effect` summarising it without running it. The law that carries the tier
is `run_effect`, `run(prog, s) == s + effect(prog)` — that the summary is
correct — and it is the only law here that is not as strong as it looks. The
first draft had only the three program-level laws, and measurement found them
jointly satisfiable by the degenerate pair `run = λp s. s` with
`effect = λp. 0n`, which reaches tier 4 while proving nothing: `effect_hom`
becomes `0n == 0n + 0n` and `run_effect` becomes `s == s + 0n`. Six
definitional pins were added (`step_inc`, `step_add`, `run_inc`, `run_add`,
`effect_inc`, `effect_add`) so that each function is named on a program whose
answer is written down rather than related to the other function. The lesson is
general and is why the tier table now has a second row worth reading: a
program-level law between two functions the policy writes is vacuous unless
something else in the file pins each function alone.

`t5-compile-word` is the second tier-5 task, and it is the other half of that
lesson. A source language of words (`P.Empty{}`, `P.Sym{n}`, `P.Cat{a, b}`) is
compiled to a one-instruction machine, and the law is
`exec(compile(e), w) == glue(w, eval(e))`. What makes it different from
`t5-run-effect` is that `eval` — the specification — is in the *prelude*, so it
is a definition the policy cannot edit and does not write. The compiler is then
judged against a fixed meaning rather than against a second function the policy
also wrote, which is why this task needs no definitional pin for `compile` at
all: a compiler that emitted a stray instruction for the empty expression, or
that emitted a concatenation's two halves in the wrong order, is caught by the
theorem, because `eval` reads them in order. The pins are on `exec` instead
(`exec_nil`, `exec_emit`, `exec_splice`), and they are complete for the same
reason the machine is: every program is a splice of one-instruction programs.
The pair of tasks is the point — the first earns its laws by pinning what the
policy writes, the second by anchoring it to something the policy cannot
write — and a third should be built by asking which of the two a new
program-level law is.

`t5-opt-drop` is the third, and it is the first whose law is about a
*transformation* rather than a second reading of a program. The machine is three
instructions and the task is the `Twice` that follows a `Zero`: doubling zero is
zero, so that instruction can be removed — but only where the accumulator is
known to be zero, and that knowledge is a parameter of the optimiser rather than
a fact about the program. `P.clean` is in the prelude, so `clean_opt` judges the
policy's output against a meaning the policy did not write, and the three laws
about the optimiser are deliberately not three restatements of one claim:
`clean_opt` is the specification and rejects an optimiser that kept a redundant
instruction, `opt_sound` rejects one that removed on its own initiative under a
caller who claimed nothing, and `opt_sound_zero` cashes the claim by running
both programs *at* zero instead of believing it. The `exec` laws are stated over
an arbitrary tail rather than over a one-instruction program, which is what
stops the body that applies the first instruction and stops: the
one-instruction version of all four is satisfied by it, and the optimiser's laws
would not notice either, because a truncating `exec` reads the two programs they
compare the same way.

Three things came out of writing it. First, the mutants are the evidence that
the three optimiser laws are three obligations: one body satisfies both
correctness laws and fails `clean_opt`, one satisfies `clean_opt` and fails
`opt_sound`, and one — the optimiser that reads a flag but not its caller's —
satisfies `opt_sound_zero` and fails `opt_sound`, which is exactly the pair of
blind spots that a single soundness law would have had to choose between.
Second, the mutants measure tier 2 rather than the tier 3 that
`t5-compile-word`'s corpus measures, and the reason is structural rather than a
defect in the corpus: Bend defs cannot be mutually recursive, so the reference
proof carrying the two soundness laws is one induction over the flag, and the
helper that induction lives in is a statement about `exec` and `opt` — the
isolation run carries it into every law, so the first mutant stops all of them.
The corpus is still strong in V2's sense, which is the sense that matters: every
mutant type-checks and none reaches tier 4. Third, the gate allows a submission
to declare only the policy's own names plus `Policy.*`, so a mutant that wants a
second recursion has to put its helper there — a top-level `go` is rejected at
tier 0, before any law is consulted, which is a rejection that says nothing
about the law the mutant was written to probe.

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

1. Full tokenizer port with `base.bend` round-trip test. **Done** (M1.1).
2. `gate.py` all rules; `tests/adversarial/` corpus (≥ 30 files). **Done** — 42 payloads.
3. `tools/mutate.py`, `tools/degenerate.py`; V2/V3 wired into `validate.py`; all 20 tasks pass. **Done.**
4. Linux bubblewrap backend + Dockerfile that installs pinned bun and copies `toolchain/`; CI runs the adversarial corpus inside it. **Done, and blocking** — green in run `35338052842`; see below.
5. Mutant-consistency tripwire (§7.4.2) in `check.py`. **Done** (M1.5). The tripwire compares whole files rather than hashes, because a policy is free to submit a different proof for the same solution; a digest match would have to be a digest of the solution alone, which is the same comparison with less to read in the log.

**M1.4 status.** `runner.BwrapBackend` (`--unshare-all`, read-only root with the
check's directory bound back over it, `--die-with-parent`), `select_backend`,
the `backend` field on every `CheckResult`, `Dockerfile`, `.dockerignore`, CI,
and `tools/sandbox_check.py` are all in place, and as of run `35338052842` the
job that runs them is green and blocking.

The run was the part that could not be substituted. This machine is macOS, so
there is no bubblewrap and no way to execute the path here, and a unit test of
the argv would pass on a host where bubblewrap cannot create a user namespace at
all — which is the failure that matters, because it is silent.
`tools/sandbox_check.py` closes that gap by requiring a *real* check to reach
tier 4 under the sandbox rather than by asserting on flags, and the CI `sandbox`
job runs it plus the adversarial corpus in the container. Getting the container
permissive enough took four flags, measured one at a time (Fact 25), and the
first run that got through failed a test — a stand-in checker in `tmp_path` that
the sandbox shadows with a fresh tmpfs on `/tmp`, which had passed on the plain
backend for its whole life. That failure is the argument for making the job
blocking, so it is now `continue-on-error: false`.

Fail-closed is the design decision worth naming: `select_backend("bwrap")`
raises when bubblewrap is absent, and `auto` raises on Linux rather than
downgrading. A silent fallback would produce a verdict that looks sandboxed in
every field except the one nobody reads. A job that is genuinely not about
isolation opts out once, at configuration time, with `GAVEL_BACKEND=plain` —
and the resulting verdicts say `dev_only: true`.

### M2 — Bank v0.5

1. Authoring pipeline as an agent loop over the env API (translate → laws →
   reference → mutants → calibrate → publish), with human review checkpoint for
   tier ≥ 3. **Done, as a driver rather than as a generator.** `tools/author.py`
   runs the stages in order and refuses to carry a task past one it has not
   passed: files → derive → mutants → V1–V5 → episode → review → publish. Two
   of the seven are model work — nothing here translates a module or invents a
   law — so what is automated is the part the plan can hold to a rule, and what
   is not is named as not.
   The mutants stage was added after the fact and is the clearest evidence the
   stage list was wrong: SPEC's loop has mutants between the reference and
   calibrate, the driver went straight from the reference to V1–V5, and so every
   fresh task died at `invariants` on "V2: no mutants authored" — a verdict
   about a task that was really a step nobody ran, for the one part of the loop
   already mechanised in `tools/mutate.py`. It generates a corpus only when
   `references/<task>/mutants/` is empty, because a corpus is the one part of a
   task a person can improve by hand and re-running the pipeline must not
   silently replace it.
   The episode stage is not a duplicate of V1. V1 asks whether the checker
   accepts the reference; the episode asks whether the task *rewards* it — gate
   open, tier 4, reward 1.0, done on the first turn — through the same
   `GavelEnv` the training loop drives, so the pipeline cannot be satisfied by
   a task the loop would not be.
   The review binds to a revision, not to a task id: approval is recorded
   against the hashes `tools/publish.py` derives from `LAWS.bend` and
   `prelude.bend`, so editing either makes the approval stale and reopens the
   checkpoint. A checkpoint that survives an edit to the thing it was reviewing
   is a signature on an empty page.
2. 200 tasks tiers 1–4; CI job runs `validate.py` over the manifest. **In
   progress** — 144 tasks (26 tier 1, 79 tier 2, 31 tier 3, 5 tier 4, 3 tier 5),
   validated together rather than per task, because a task is sound only against
   a corpus that shares the degenerate generator with it. The whole bank was
   measured locally on 2026-09-19 as **144/144 valid over 3,158 checker runs**,
   with no problems and no task free of warnings: the missing calibration
   measurement on all 144, and on the 39 tasks at or above `REVIEW_TIER` a
   review warning as well — all 39 with no record, because the 11 records that
   used to sit in `meta.json` were forgeries and were deleted rather than
   migrated (Fact 27). The calibration warning is the one `--strict` promotes,
   and the review warning is the one it would promote with it, which is why
   neither mode reddens the bank yet. The last CI run over a whole bank was at
   83, `83/83` over 1544, run `35350369509`.
   This measurement is the one M4.3 used to argue *against* waiting for a quiet
   box: V4 reads wall-clock latency, so a bank measured while an authoring agent
   is checking it is a bank measured under contention — but the contention makes
   a *latency* number about the box, and it does not change whether 144 of 144
   validate. The 122-task reading that stood here was taken the same way, and
   the 142- and 144-task ones were taken harder: the load average was 14–17
   throughout because of a ChatGPT/Codex process outside this repository, and
   every task still read `[ok]` at a reference latency of 81–152 ms.
   The 141 tasks at tiers 1–4 are
   short of the 200 by 59, and 27 of the 144 are the two families §3.9 records:
   the count and the number of distinct problems are not the same number, and
   only one of the two is what a curriculum buys.

   The CI job is `uv run python -m tools.validate`, deliberately without
   `--strict`. Every task in the bank carries the same warning — calibration
   has not run, so no `zero_shot_solve_rate` is recorded — and `--strict`
   promotes warnings to failures, so switching it on now would fail every task
   for a reason that is not about any of them. `--strict` is the right mode the
   moment calibration exists, and not before: a green build has to mean
   "checked and fine", not "not checked yet", which is exactly why the warning
   is reported at all rather than being silently absent.

   A tier-3 task goes in with a hand-authored mutant corpus (4 to 22 files).
   That corpus is V2's evidence and the part of a task a person does better
   than a generator, which is why `tools/author.py`'s mutants stage keeps one
   rather than replacing it. Registering a task that fails validation is worse
   than leaving it out, since the manifest is what a training loop trusts.

   That rule is met by fewer tier-3 tasks than the count of tier-3 tasks
   suggests, and by fewer than this document said until the census was taken.
   Counted over the whole manifest rather than over the batch — classifier: a
   mutant whose filename carries a generator rule is generated, everything else
   is hand-authored — **18 of the 31 tier-3 tasks carry no hand-authored mutant
   at all**, against the ten named here earlier. The ten was the same
   phenomenon counted over the batch; the extra eight are older tasks, which is
   the less comfortable finding, because it means the rule was not met
   retroactively either. The 18 are `t3-absdiff-comm`, `t3-bin-inc`,
   `t3-concat-len`, `t3-count-append`, `t3-filter-bound`, `t3-interleave-nil`,
   `t3-isort-perm`, `t3-isort-sorted`, `t3-merge-len`, `t3-mul-comm`,
   `t3-pad`, `t3-replicate-append`, `t3-rev-rev`, `t3-rle-expand`,
   `t3-sum-replicate`, `t3-take-drop-split`, `t3-zip-len` and `t3-zip-sum`;
   `t3-absdiff-comm` is the only one below the file floor as well, at two
   files, and two more are below the floor on the authored count alone —
   `t3-split-even-odd` and `t3-sum-to-double`, at three each. Not all of the 18
   are old: `t3-merge-len` and `t3-rle-expand` are recent, and `t3-merge-len`
   carries 37 generated files, which is the point that a corpus generated by
   rule is thin evidence at any size — the count is of files, not of laws
   reached. One caveat on the
   classifier before it is trusted too far: `tools.mutate` unlinks a corpus
   before writing one, so a task whose hand-authored files were wiped and
   regenerated is indistinguishable here from one that never had any — the
   census measures the corpus that *exists*, which is the thing V2 reads.
   None of the 18 is unsound by it — every one validates, every corpus has a
   mutant that type-checks bare and none reaches tier 4, which is the sense V2
   measures — but the
   *ratio* is the tell: a hand-authored corpus runs 4/4 or 7/7 strong, and these
   run as low as 1/6, because a rule-shaped mutant that fails to type-check is a
   coverage error and not evidence about a law. The thinnest were
   `t3-last-snoc`, `t3-height-mirror`, `t3-tree-sum-mirror`, `t3-sum-to-double`,
   `t3-prefixes-len`, `t3-any-append`, `t3-split-even-odd` and `t3-nappend-len`,
   and they have since been hand-authored up to the rule rather than left as an
   exception to it: thirty authored mutants across the eight, every one of them
   strong, taking the ratios to 5/8, 5/9, 5/10, 5/11, 5/8, 4/9, 4/8 and 5/9
   (8/8 valid, 148 checker runs, measured 2026-09-18 and committed as
   `b483601`). The ratios are not 1.0 and should not be read as a shortfall:
   the generated rules stay in the corpus beside the authored ones, and a
   mutant that fails to type-check bare is dead weight the count carries and no
   law ever saw — the same defect, now diluted rather than dominant. Two of the
   eight, `t3-split-even-odd` and `t3-sum-to-double`, sit one authored file
   short of the rule's floor of four and are being brought up to it.

   **The rule names tier 3 and the defect is not tier-specific.** Counting every
   tier rather than one: tiers 4 and 5 are fully hand-authored (7 tasks, 44
   authored files between them), and tiers 1–3 are mostly not — **8 of the 20
   tier-1 tasks and all 66 of the tier-2 tasks carry no hand-authored mutant
   either**, so 92 of the 117 tasks at tiers 1–3 are in the shape the rule was
   written to prevent. Sampled over seven of them rather than assumed —
   `t2-add-laws`, `t2-rev-append`, `t2-map-laws`, `t2-sum-laws`, `t2-drop-laws`,
   `t1-mul-zero`, `t1-double` — the generated corpora are **14 strong out of 66
   files, 21%**, against 4/4 and 7/7 for authored ones, and the strongest of the
   seven is 4/11. Every one of the seven is still `valid` with no problems,
   because V2 asks only that *a* mutant type-checks and none escapes: a green
   light over those corpora rests on one or two files. The tiers also say why
   the generated files are dead weight rather than weak evidence — most of them
   come back tier 1, which is "did not type-check bare", so the law was never
   consulted on them at all. That is the linearity limit Fact 18 records
   (a binder may be consumed once, so `recursion-arg`-shaped mutants are parse
   errors), and it means the generator's reach is bounded by the language
   rather than by the rule list.
   The letter of the rule stops at tier 3, so extending it to tiers 1–2 is a
   scope decision with a real cost (86 tasks) rather than something this
   document takes on its own. **Taken deliberately, 2026-09-18: both.** The
   corpus work and the volume target run in parallel rather than in sequence,
   split across the two authoring agents — one takes the 18 tier-3 tasks, the
   8 tier-1 tasks and the even-indexed half of the 66 tier-2 tasks, the other
   the odd-indexed half — and each interleaves that with new tasks. The cost is
   honest and so is the reason for paying it: the plan's own justification for
   the rule — that a corpus is V2's evidence and the part of a task a person
   does better than a generator — does not mention tiers, and a reader of the
   200-task target should not have to discover that 92 of its 117 existing
   tasks are evidenced by one or two mutants apiece. Sequencing the two would
   have been defensible; doing both is the choice because neither the evidence
   nor the count is worth having alone.

   The 92 is the census as measured, not a running total, and the work against
   it landed the same day, in four batches: `5187735` and `060ad97` (twelve
   tier-2 tasks), `26aca27`, `db3543b`, `56e04da`, `562cbce`, `0eeeacb`,
   `9ea0048` and `d756adc` (sixteen tier-3 tasks), and `4c47c55` (six tier-2
   tasks). Every task in every batch is strong and validates with no problems;
   the per-task detail is in the commit messages and is not repeated here,
   because the counts below are the part that has to be right.

   **A 125th task was registered concurrently.** `t4-inorder-transport` was
   authored by `tier3-author` in this team, under the directive that reassigned
   the directory to it after `tier2-author`'s `/tmp`-staged version was parked;
   its two directories were untracked when this pass began and were written
   between 00:35 and 00:40 on 2026-09-19. A `tools.publish` run here picked it
   up and the manifest went from 124 tasks to 125. It reads sound — tier 4, the
   reference checks clean, `meta.json`'s hash matching
   `LAWS.bend` — and it is finished rather than in flight: nothing has written
   to either directory since, its 14 mutant files and both directories are
   tracked, and its manifest entry hash recomputes from the shipped
   `LAWS.bend` + `solution.bend` + `prelude.bend`. **It was committed in
   `db21d89`, to keep the manifest coherent**; the "untracked" caveat above
   applies only to the moment this paragraph describes. An earlier version of
   this paragraph called it another session's in-flight work and excluded it
   from the counts on this page; both were wrong — it is same-team finished
   work, and it *is* inside `tier3-author`'s own 125-task screen. The
   registration is a side effect of publishing, not a certification, and the
   task carries **no review record** — tier ≥ 3 stops at the review stage and it
   was not given one, which leaves it in the same unreviewed tier-4 state as the
   eight tasks M4 records.

   **The census is closed, measured 2026-09-19.** All 125 registered tasks carry
   at least one hand-authored mutant file, and **every one of them is at or
   above the four-file floor** — the first time both have been true. The
   classifier reads **1,359 mutant files** across the bank, all of them in git
   as of the Fact 41 repair — the 14 the concurrent task above was holding in
   the working tree when this paragraph was first written have since landed in
   `db21d89` — and the day's repairs are what moved the number:
   `append-swaps-the-two-lists.bend` for the Fact 32 correction,
   `push-drops-the-back.bend` and `opt-leaves-a-redundant-zero.bend` for Fact 34
   (`4f07ac7` committed 98 files the classifier was already counting),
   `mul-wrong-at-zero-times-two.bend` and `pad-filler-becomes-the-count.bend`
   from Fact 36, both of which hold bodies that read 1.000 before their
   repairs, `append-rotates-the-front.bend` from Fact 38,
   `rev-maps-the-elements.bend` and `insert-drops-the-tail.bend` from Fact 39,
   and `bst-tip-ignores-the-accumulator.bend` from Fact 41. The last of them is
   M4.5's `pad-zero-case-prepends.bend`, which is the one file here that a
   *number* asked for rather than a hole: no mutant in `t3-pad`'s corpus failed
   `pad_nil`, and the kill-count reading named the law. **Eleven more are M4.5's
   bank-wide reading**, one per law the metric found at zero kills across ten
   tasks — the sweep is in M4 item 5, and it is the same number doing the same
   thing at scale: `pad_nil` was the first law the metric named, not the only
   one.
   Fact 36's
   third instance adds none, for the reason recorded there. Fact 34's third instance
   deliberately adds none, for the reason recorded there, and **Fact 35 adds none
   either — its escaping body was already in `t3-merge-len`'s corpus**, filed as
   an ordinary generated mutant; what that task needed was a law, not a file.
   Both are the same lesson from opposite ends: the census counts files and
   tiers, and neither is a statement about the law set. The nine
   tier-2 tasks that stood at zero (`t2-cube-all-laws`, `t2-dup-all-laws`,
   `t2-has-mult3-laws`, `t2-has-odd-laws`, `t2-map-add-laws`,
   `t2-sq-inc-all-laws`, `t2-sum-half-laws`, `t2-sum-mod3-laws`,
   `t2-sum-nonzero-laws`) and the twelve thin tier-1 tasks (`t1-append-assoc`,
   `t1-append-nil`, `t1-concat-append`, `t1-count-zeros`, `t1-len-append`,
   `t1-len-cons`, `t1-len-map`, `t1-len-snoc`, `t1-rev-append`, `t1-rev-snoc`,
   `t1-sum-append`, `t1-take-drop`) were all topped up rather than left as an
   exception to the rule. **Thin was not the same as safe:** three of those
   twelve top-ups found full-reward holes in the task they were topping up —
   `t1-len-snoc` (`snoc` that prepends, since every law was about lengths),
   `t1-len-append` (cons step recursing against `Nil{}`, since no law applied
   `append` to a non-empty second argument) and `t1-count-zeros` (an offset that
   cancels in a one-law recurrence set) — each proved at tier 4, reward 1.000
   before the repair. A corpus floor is a statement about evidence, and these
   three are the counter-example to reading it as a statement about soundness.

   **The whole bank re-validated on the settled tree, 2026-09-19, after Facts 39,
   40 and 41: 125 of 125 valid, no failures, 2,755 checker runs.** Every task
   reads `[ok]` with no problems reported. The "125 with unchecked invariants"
   in the summary is the standing calibration note — no `zero_shot_solve_rate`
   is recorded anywhere, which is M4 item 4's blocked state rather than a
   defect — and not a validation failure.

   **Two limits on that paragraph are worth stating, because both have already
   produced a wrong number here.** First, the classifier reads the working
   tree, so it counts an agent's uncommitted files as authored — it leads the
   verified-and-committed count rather than equalling it, and a number quoted
   in a commit message can be overtaken between the message and the push.
   Three of this document's own counts were wrong for that reason or its
   cousin: it said the tier-3 repair moved "from 8 of 18 to 11 of 18" and the
   message on `db3543b` said nine of the 18 were repaired, when the classifier
   said six — both were tallies carried forward from earlier tallies instead of
   re-derived from the files; and `4c47c55` says the tier-2 census reads
   eighteen of sixty-six where the next measurement said twenty-four. Pushed
   commit messages cannot be corrected in place, so the corrections live here.
   Second, per the caveat above, a "zero" rests on the corpus that exists and
   not on history. The rule to follow is the classifier run, and the fact to
   quote is the number measured at the moment of quoting.

   The related finding from `t3-zip-len` is worse and was caught before it
   shipped. A corpus is not the only thing that can be thin. Its original two
   nil pins plus a length law were satisfied by a `zip` that built
   `P.Mk{hy, hx}` — every pair's components swapped — because the length law
   counts pairs and nothing else in the file looks inside one. A definitional
   `zip_cons` pin closes it. The shape generalizes: a law that counts or
   emptiness-tests a constructed value never inspects it, so a component-swap
   body proves every law that treats the value as opaque, and the fix is one
   `{==}`-closed pin that destructures the constructor.

   **The CI gate outgrew a serial pass, and that was measured rather than
   foreseen.** At 58 tasks, "The bank validates" ran for over 18 minutes with
   nothing else on the runner — the cost is one bun process per check and about
   15 checks per task, so it grows with the bank and would have been hours at
   M4's 500. `tools/validate.py` now takes `--jobs N` and CI passes 4; a task's
   checks are independent (own workdir, own checker process, no shared mutable
   state in the check path), and `map` keeps the reports in task order so the
   output is unchanged.

   Measured on the runner, which is the only number that matters here: the step
   took **20 m 09 s** over 59 tasks serially and **8 m 30 s** over 62 at
   `--jobs 4`. More tasks, less than half the time. A local comparison on 12
   tier-3 tasks gave only 200 s → 110 s, because five other checker processes
   were running on the same box; the runner has no neighbours, which is why the
   local figure was the pessimistic one.

   The series continues, and was read at the time as a slope: at **81 tasks the
   step took 9 m 29 s** (run `35343671771`), a third more bank for 12% more
   time. 1210 checks in 569 s on four jobs is about 2.1 checks/s. A per-check
   process should have that shape -- throughput set by the runner's cores
   rather than by the bank's size -- and it is why a worker (M3.4) would buy a
   constant and not a curve. The later runs below retract the slope, though not
   the shape.

   The check count is not a property of the bank's size alone, and Fact 28 is
   why: the `vary-*` family added one run per argument-ignoring body per
   function, taking the same 81 tasks from 1210 checks to **1507**
   (81/81 valid, measured serially on this machine). A task with more
   same-typed parameters costs more to validate than one with fewer, so the
   cost per task now varies with the signatures and not just with the tier.

   Re-timed rather than extrapolated, and the extrapolation would have been
   wrong: at **1507 checks the step took 17 m 38 s** (run `35350056234`), not
   the ~12 m that scaling 9 m 29 s by check count predicts. But the new number
   is not a slope either, and the reason is worth recording because it invalidates
   the 9 m 29 s point rather than extending it.

   The same commit -- 81 tasks, the old corpus, 1210 checks -- was measured
   **four times in this window**, and the step took 569 s, 816 s, 763 s and
   802 s: **0.47 to 0.67 s per check for identical work**, a 43% spread with no
   change to the bank. The two 83-task runs that followed took 1058 s and
   1084 s, which is 0.702 s per check both times -- at the top of that band and
   not above it. So the step's cost did not move by more than the noise, and
   the claim that the 10 m series was "a slope" was reading four points that
   spanned the same range. It was never a slope; it was one measurement of a
   quantity that varies by half.

   What is solid is the direction and the size of the budget: 24% more checks
   and a step that is now ~18 minutes rather than ~10-14. Every run in this
   table overlapped at least one other, and GitHub-hosted runners are not
   promised isolation from each other, so the variance is expected rather than
   surprising -- which is the same lesson the local p50 320 ms vs ~180 ms
   figures already taught, arriving on the runner instead of the laptop. The
   worker (M3.4) is worth more than the 9 m figure priced it at, and a
   published throughput number still needs an isolated host.

   `--jobs` is off by default, and that is not timidity. V4 asserts
   `reference_ms` against a wall-clock budget, so validating concurrently
   inflates the very quantity being checked: a loaded box can fail a task that
   is fine, and it would fail it with a confident number beside it. CI can
   afford four at once because its runner is otherwise idle and the checks
   measure ~200 ms against a 2000 ms budget; a developer's laptop cannot make
   that assumption, so it is theirs to make.

   **A manifest is a claim about a revision, and two writers make it a claim
   about two.** `eafd7c5` committed a 62-entry manifest with only two of the
   three task directories behind its new entries: `t3-sum-acc` had been
   registered by the authoring agent while I was adding the other two, so the
   manifest was ahead of the commit and `load_manifest` failed on every
   checkout — 189 errors and a red sandbox job. Nothing was wrong with the
   bank; the commit simply named a task it did not contain. The check that
   catches it takes a second and is worth stating plainly: **every manifest
   entry must resolve to a directory inside the same commit**, which is a
   property of the commit and not of the working tree, and so cannot be seen
   from the tree that produced it. This is the second cost of a file two people
   write; the first was the review records in Fact 27, and the fix for both is
   the same — one writer, or a check that runs against the revision rather than
   the tree.
3. `tools/migrate.py` and a dry run against 2.0.4 to measure churn. **Done, and the answer is not the expected one** — see below.

**M2.3 churn, measured.** The plan assumed syntax drift across releases ("three
releases shipped in one day during probing"). The bank was run against every
checker the launcher has on disk — 2.0.3, 2.0.4, 2.0.5, three distinct trees:

| candidate | tree | clean | quarantined |
|---|---|---|---|
| 2.0.5 (the pin, control) | `121c70615f2d` | 20/20 | 0 |
| 2.0.4 | `ca88ac8cc948` | 20/20 | 0 |
| 2.0.3 | `90127d834526` | 20/20 | 0 |

**Zero churn across three releases.** The 2.0.x churn does not reach any
construct this bank uses: every task is `import Base`, inductive `def`s,
`law … for … {… == … : T}`, and `{==}` / `%e : P` proofs. That is worth stating
plainly because it revises the risk in §5 downward — for *this* bank, at *this*
size, the version bump is not the live hazard. It would be a mistake to read it
as "Bend is stable": the sample is 20 tasks by three authors all working from
the same guide, and the constructs the bank avoids are exactly the ones the
guide does not cover. The hazard is unmeasured, not absent.

`--from` takes any directory containing `bend2/`, so a candidate is measured
without vendoring it; nothing is written to the repository except the report.
The negative control is what makes the three zeros mean something: a copy of
2.0.5 with the success line changed from `All terms check.` to `Everything is
fine.` quarantines **20/20** and quotes the new line back as evidence. Both
directions are tested in `tests/test_migrate.py`, because a dry run that reports
"0 quarantined" for every candidate is indistinguishable from one that never
looks.

### M3 — API

1. Multi-turn env with dense/sparse modes; feedback truncation. **Done** — M0
   item 8 built it; `tests/test_env.py` covers the dense/sparse distinction,
   the improvement-only payment, the feedback path, and the episode bounds.
2. `cache.py` (sqlite), `trajectory.py` JSONL, `metrics.py` export. **Done.**
   The cache is a memo over everything a verdict is a function of (see the
   deviation above); a hit is marked `cached: true` and keeps the original
   `ms`, so nothing downstream mistakes a lookup for a check. The trajectory is
   append-only JSONL, flushed per line, and a reader skips a half-written final
   line rather than failing — the reason for the format is that a killed soak
   should still be worth reading. Metrics are derived from the same records the
   log holds, asserted equal by test, so a finished run and a watched run
   cannot disagree. `GavelEnv.close()` ends any open episode (an abandoned
   episode is data) and closes the trajectory; it deliberately leaves the cache
   open, because a memo shared across envs must outlive any one of them.
3. `server.py` JSON-lines over Unix socket + HTTP; client example in a
   non-Python stack. **Done.** Sessions rather than connections — HTTP has no
   connection to hang an episode on — so `reset` mints an id that every later
   request carries, and sessions share the bank, toolchain, cache, trajectory,
   and metrics while each keeps its own turn counter. Both transports call the
   same `GavelServer.handle`, so a bug in one is a bug in both. A malformed
   frame is answered with an error and the connection stays open; a client that
   sends one bad line should lose that line, not the run. The Unix socket is
   chmod 600, because the socket *is* the access control when the payload is
   arbitrary programs. Client example: `examples/client.ts`, run by the bun the
   checker is already pinned to, and covered by a test that starts a real
   server (`tests/test_server.py`).
4. Persistent bun worker backend; publish p50/p95/p99 and verdicts/min/core.
   **Half done: the numbers are published, the backend is not built.**
   `tools/soak.py` reports p50/p95/p99 and verdicts/min/core from a real run,
   but every check is still a fresh `bun bend2/main.ts`, so what those numbers
   measure is the process-per-check design rather than a check. It has since
   gained the reading that survives a loaded host — checker CPU per verdict,
   from `RUSAGE_CHILDREN` around the run, and the amplification against the
   worker budget — which is M4 item 3's published number and the reason the
   backend being unbuilt is now a design statement rather than a blocked one.
   Fact 24 is the
   bound on what a worker could win, measured rather than argued: a file
   containing `import Base` and nothing else costs what the bank's heaviest
   reference proof costs, so the whole per-check time *is* the constant a
   worker would eliminate. It is a real win and it is the only one. Not built
   because the checker process *is* the thing the sandbox is a boundary around —
   `gavel/runner.py` reasons about a process it starts, scrubs, limits, and
   kills, and none of those apply to a worker that outlives the check.
5. 10k-episode unattended soak with a scripted policy. **Done** —
   `runs/soak-10000`, run `20260918T092845Z-189b5e5b`, exit 0, no human in the
   loop and none needed: the log's printed counters were reconciled against
   `metrics.json` and agree, and the run was left unattended to completion.

   | | |
   |---|---|
   | episodes | 10000 of 10000 (33538 turns) |
   | solved | 4939 (49.4%), mean reward 0.573, mean turns 3.35 |
   | best tier | 0:1015 2:2635 3:1411 4:4939 |
   | throughput | 636 verdicts/min (80/core) over 3165 s on 8 jobs |
   | latency | p50 320 ms, p90 418, p95 456, p99 524 (29478 fresh checks) |
   | cache | 0 hits / 33538 lookups, 33538 rows |
   | incidents | 0, and 0 unexpected; 4060 gate rejections |

   Three things this bought beyond the number. The **0% cache hit rate is a
   property of `--policy noisy`**, not of the cache: a scripted policy that
   varies its submission every turn never asks the same question twice, so the
   soak measures the cache's cold path and none of its warm one. Mean turns
   3.35 against `max_turns 4` with 10% of episodes ending at tier 0 says the
   policy is being pushed to the bound rather than idling inside it. And the
   latency figures are **contended** — the soak ran on 8 jobs on this machine
   while the session was building and testing on it, which is why p50 320 ms
   here and ~180 ms quiet (Fact 24) are both true and not in conflict. Re-run
   on an idle box before quoting a throughput number to anyone.

### M4 — Bank v1.0

Exit: 500+ tasks including tier 5, human-reviewed laws for tier ≥ 3, published
throughput benchmark, an external training run reporting a solve-rate curve.
The four have four different states, and only the first is work rather than a
waiting room.

1. **500+ tasks including tier 5. 144, of which five are tier 4 and three are
   tier 5.** None of the five tiers is empty, so what is left here is volume: the
   pipeline that produced 83 tasks produced the 84th and the 85th as well, and
   the same shape of work has since produced 59 more (a 35-task batch from two
   authoring agents, the third tier-5 task, the third and fourth tier-4 ones, the
   Bool-fold duality, the 17-task batch of Fact 42, and Fact 43's three — one of
   which is held at review), so the remaining 356 are
   volume and nothing else. The check that keeps it honest (a manifest entry must
   resolve to a directory inside the same commit) exists and has already caught
   its own failure once. Tier 5 was the one part of this item that was not a
   waiting room, and it is now written three times over — `t5-run-effect`,
   `t5-compile-word` and `t5-opt-drop`, all authored from SPEC §10's description
   because the vendored tree has no tier-5 reference to port. The question the
   first two between them answered — what makes a program-level law sound when
   the functions in it are the policy's own — is the one §3.9 now records, in
   the two opposite answers it took, and the third was written by asking which
   of the two a law about a *transformation* is.
2. **Human-reviewed laws for tier ≥ 3. Not satisfied, and the bank no longer
   says it is** — the pipeline can no longer write a review record at all, so
   what is left is that a person has to read the laws. See below. **One
   boundary is worth stating rather than leaving implied: the checkpoint belongs
   to `tools/author.py`, not to the bank.** Measured 2026-09-19 on
   `t3-swap-sum-pair` — held by the authoring pipeline, written into a *scratch*
   manifest that the real one does not see: `uv run python -m tools.publish
   --manifest manifest.scratch.review-probe.json tasks/3/t3-swap-sum-pair`
   registered it, 145 tasks against the real 144, exit 0. So a bare
   `tools/publish` — which is a command this repository's own README documents
   and CI runs — will put an unreviewed tier-3 task in the bank. It is not a
   defect in the reward path, because no verdict reads a review record and
   `tools/validate.py` reports the missing one as a warning either way; it is
   the authoring gate being a property of the authoring tool, which is the same
   shape as the forgeries Fact 27 removed one level down. Closing it would mean
   refusing a republish of the 31 tier-3 tasks that already carry no record, so
   it is recorded instead of changed.
3. **Published throughput benchmark. Published 2026-09-19, and the blocker was
   the metric rather than the machine.** `tools/soak.py` reports p50/p95/p99 and
   verdicts/min/core from a real run, and M3.5's ten-thousand-episode soak
   produced all of them — taken with eight jobs running while the session built
   and tested on the same box. Both runs since have been on a machine at load
   100 or more, and a contended latency percentile is not a published one, which
   is where this item had been sitting: the plan was waiting for a quiet host
   that this box has not been.

   **Waiting was the wrong move, and the fix is a metric that does not depend on
   the wait.** Wall clock measures how long a verdict *waited*, which includes
   every other process on the box; the checker's own CPU measures the work it
   *did*, which does not. `child_cpu_s()` reads `RUSAGE_CHILDREN` around the run
   and `throughput()` divides by it, so a contended host still yields a
   publishable rate. Measured over 3,000 episodes and **10,012 verdicts, every
   one a fresh checker run** (0 cache hits of 10,012 lookups, so the number is
   the checker's and not the cache's), `--policy noisy --jobs 8`, seed 0:

   - **907 ms of checker CPU per verdict, 66 verdicts per CPU-minute.** This is
     the load-independent reading and the one to quote.
   - **1.12× CPU amplification** — checker CPU per CPU-second of worker budget.
     Above 1 because the checker is `bun`: one verdict forks and threads on its
     own, so eight workers can spend nine cores' worth of CPU. It is why 66 per
     CPU-minute sits below 74 per core-minute rather than above it.
   - **595 verdicts/min (74/core) over 1,010s**, latency p50 242ms / p90 310ms /
     p95 325ms / p99 365ms over 8,904 fresh checks. These are the contended
     numbers — the box was at load ~14 throughout, with a system daemon at 88%
     of a core that is not this session's to kill — and the session records them
     as such rather than as a quiet-host benchmark. The two readings are
     consistent rather than merely both present, which is the check worth
     stating: 1.12× of the eight-worker budget is 9.0 cores of checker CPU, and
     66 verdicts per CPU-minute × 9.0 ≈ 595 per minute, the wall-clock rate. A
     host that had starved the run would have shown a wall-clock rate well under
     that product, and the amplification is what would have said so.
   - 1,508 of 3,000 episodes reached tier 4 (50.3%), mean reward 0.610, 0
     incidents. The solve rate is the script's and not a model's — it is M3.5's
     stand-in policy — so it is a statement about the harness reaching its own
     reward, which is what makes the throughput numbers above trustworthy.
4. **External training run. Blocked on a model, and the harness half is now
   demonstrated rather than assumed.** Nothing in this repository conjures the
   policy, and the calibration path that would record a `zero_shot_solve_rate`
   still answers 403 from here — re-run 2026-09-19 and unchanged:
   `HTTP 403: error code: 1010`, with `api_calls 1`, `input_tokens 0` and
   `output_tokens 0`, which is the shape of a request that never reached the
   gateway's own routing. That block is deliberately left standing rather than
   worked around: a harness that misrepresents itself to a third party to obtain
   a number is not a harness whose numbers mean anything.

   **What can be closed without a model is the half that is not the model, and
   it is closed.** `tools/calibrate.py --echo` runs the whole path with a policy
   that replays the stub instead of spending: reset, submission, gate, checker,
   reward, and the curve. Measured over four tasks at `k=2`: 8 attempts, a
   per-task curve, `"errors": []`, every attempt at tier 1, floor 0.0. That is
   not a solve rate and the report says so itself — `"model": "echo"` — which is
   what makes it safe to run: the number cannot be mistaken for a model's, and
   `--write-meta` was **not** used. Recording a 0.0 the echo produced as a task's
   `zero_shot_solve_rate` would put a field that answers a question the machine
   cannot answer into the manifest, which is the defect Fact 27 is about.

   So the item stands as: the observation, the reward, the recording and the
   curve are all exercised end-to-end and are not what is missing. What is
   missing is an endpoint that will answer a non-browser client, and that is one
   configuration value rather than any part of this repository.
5. **SPEC §12's environment-quality metrics. Built 2026-09-19, and the first
   thing they did was report the bank's honest state.** `SPEC.md` §12 asks for
   four numbers "exported per bank release" — task count per tier, calibration
   solve-rate distribution, mean mutants killed per law, and the fraction of
   tasks with human-reviewed laws — and none of them existed, which the plan
   had never recorded: §12's harness half is M3.2 and its bank half was in no
   milestone at all. `gavel/validate.py::bank_metrics` computes all four from
   the reports a validation run already produced, and `tools/validate.py`
   prints them under its summary and exports them under `--json` alongside the
   per-task records. `--json` also had to be fixed to be JSON: the summary
   lines used to follow the document, so the mode existed for callers who could
   not parse it. Two of the four report the bank as it is rather than as a
   score: calibration is **0 of 144 recorded**, which is item 4's blocked state
   as a number, and the review fraction is **0 of the 39 tasks that need
   review** — which is *not* the same as thirty-nine tasks having been reviewed,
   and the paragraph here has been wrong in two different directions before
   reaching it. The first version said "0.0 of the 39", which was worse than
   wrong in a useful direction: the measured number was 0.2051, because the
   check counted records whose hashes matched the shipped laws and every one of
   those eight was a record the authoring agent wrote for itself. **The
   human-reviewed figure was 0 of 39 then and is 0 of 39 now**, and the two
   readings differ in what the bank *says* rather than in what it has. A metric
   named `reviewed_fraction` that reads 0.205 off a bank with no reviewed task
   is the same defect as `"valid": true` in the manifest, one layer up — a
   number answering a question the machine is not able to answer — so the field
   was renamed to `recorded_fraction` and the state `approved` to `current`,
   which is all the check can witness. The eleven forged records were then
   deleted rather than migrated, so the field now reads 0 as well: the 0.205 is
   gone because the records are gone, not because anyone read the laws (Fact
   27). It is a fraction of the tasks that need review rather than of all 144,
   because below `REVIEW_TIER` the author's own reading *is* the review and
   counting those would report the bank as unreviewed for following its own
   rule.

   **The fourth arrived with a triage signal the bank did not have before.**
   "Mean mutants killed per law" needed which laws caught which mutants, which
   V2 already computes and threw away: the checker's fixed point names the laws
   it could not prove, so a type-checking mutant's failed list *is* its kill
   list, at no extra checker run. Seeded over every law in the bank rather than
   over the laws that appear in some corpus, the minimum is not a summary — a
   law at **0 kills** is one no mutant in its corpus ever fails, which is
   invisible to V2, since V2 only requires that the corpus be non-empty, that
   some mutant type-check it, and that none escape. Read on `t3-pad`, `min` is
   0 and the law is `pad_nil`: nine of its seventeen mutants type-check and
   none of them touches the `Nil{}` case, so the whole of that law's evidence
   is eight mutants that fail to type-check and are therefore not evidence at
   all. That is a *flag and not a hole* — Fact 41's rule applies unchanged, and
   a repair must not be shipped for one on a static read — but it is the first
   mechanical pointer the bank has ever had at the laws its corpus is not
   holding.

   **It was actionable on the first law it named, and the fix was a file rather
   than a law.** `pad_zero_case_prepends.bend` is the reference with the `n =
   0n` arm answering `x <> xs` instead of `xs`, which is the one case no
   generated rule lands on — every rule in `tools/mutate.py` rewrites a step, a
   count, an operand or a recursion argument, and the zero arm is reached by
   matching on `n` before the list is looked at at all. Measured: **tier 3,
   three laws unproven** — `pad_nil` (`expected x <> xs`, `observed xs`),
   `pad_len`, and `pad_single`, which the `1n` arm reaches through the zero arm
   below it — and tier 2 bare, so it reaches the laws rather than failing to
   type-check first. `t3-pad` now reads min 1: every law in it is failed by at
   least one mutant that type-checks. This is the shape the metric is for — a
   law whose *evidence* was absent while the law itself was load-bearing, which
   is the opposite of a hole and is invisible to every check the bank had.

   **The bank-wide reading was `mean 5.1, min 0`, over 376 laws in 125 tasks,
   and is now `mean 4.53, min 1` over 459 law declarations in 144 tasks** — the
   first pair of numbers is the before and the after of the sweep below, and the
   second pair is the reading two days later, after two more batches added 83
   registered law declarations and the two sweeps that gave 32 of them their
   first mutant. It moved
   twice in the same direction, and the second time it moved *down*: 26 laws in
   Fact 42's batch and 6 in Fact 43's had no killer at all, and a law with
   exactly one killer pulls the mean down rather than up. `min` is the number
   that matters — a mean is compatible with a law nothing fails, and the min is
   the only reading that names it — and it is 1 at both readings, which is the
   whole point of the two sweeps. Every reading here was taken by the same
   command over the whole manifest, and every one of them reported the bank
   valid; `min` is a separate question from `valid`, and the only one of the two
   that a zero-kill law changes.
   `t3-pad` was the first law named and not the only one: **11 laws across 10
   tasks** sat at zero kills, and the sweep that found them is the metric's real
   product. `min 0` is the number that matters — a mean of 5.1 is compatible
   with a law nothing fails, and the min is the only reading that names it. The
   ten, with the mutant written for each, are `t1-len-map`/`len_cons`
   (`len-cons-counts-one.bend`), `t1-sum-append`/`append_nil_left`
   (`append-nil-answers-nil.bend`), `t2-all-even-laws`/`all_even_nil`,
   `t2-all-mult5-laws`/`all_mult5_nil` and `t2-all-one-laws`/`all_one_nil` (the
   `*-nil-answers-false.bend` triple), `t2-at-laws`/`at_nil`
   (`at-nil-answers-the-count.bend`), `t3-is-pal-rev`/`is_pal_nil`
   (`is_pal-nil-answers-false.bend`), `t3-zip-sum`/`zip_sum_nil_left` and
   `zip_sum_nil_right` (`zip_sum-nil-left-answers-the-right.bend`,
   `zip_sum-nil-right-answers-the-left.bend`), `t4-queue-rep`/`pop_empty`
   (`pop-empty-answers-one-element.bend`) and `t5-compile-word`/`exec_nil`
   (`exec-nil-answers-nil.bend`). Eleven files — `pad-zero-case-prepends.bend`
   is the twelfth of the day and is already counted above — which moves the
   census from 1,348 to **1,359**.

   **Every one of the eleven is the same shape, and the shape is the finding.**
   Ten of the eleven are the **empty case**: `append(Nil{}, ys) == ys`,
   `all_even(Nil{}) == True{}`, `at(Nil{}, n) == 0n`, `pop(P.Q{Nil{}, Nil{}}) ==
   P.Q{Nil{}, Nil{}}`, `exec(Nil{}, w) == w`. The eleventh, `len_cons`, is the
   case where a law's own left-hand side is a cons before the function looks at
   it, so the `Nil{}` arm is off the path in exactly the same way. The reason is
   mechanical and it is in `tools/mutate.py`: every generated rule rewrites a
   *step* — a count, an operand, a recursion argument, a connective — and an
   empty case is an answer rather than a step, reached by a match that has
   already stopped. `t3-zip-sum`'s corpus says so out loud in two of its own
   mutant headers: "both nil laws hold definitionally". True of those bodies,
   and the reason the two laws were carrying no evidence at all.

   **What the sweep does not claim.** Zero kills is a flag and not a hole
   (Fact 41's rule, unchanged), and the reverse does not hold either: a law at
   zero kills is not automatically weak — `pop_empty` needed a body that puts an
   element into the empty queue, because carrying the back through or reversing
   it agrees with the reference *at* `Nil{}`. The reading says the corpus is not
   holding the law, which is a statement about the evidence and not about the
   law, and the repair is a file for the same reason `pad_nil`'s was.

   **The sweep was run again over the 17-task batch of Fact 42 and found the
   same shape in the same place, which is the argument for running it every
   time.** Adding 73 laws to the bank dropped the reading back to `min 0`:
   **26 zero-kill laws across all 17 new tasks**, and every one of them is the
   empty case — `count_while_nil`, `keys_nil`, `values_nil`, `sum_values_nil`,
   `diffs_nil`, `diffs_single`, `drop_while_nil`, `take_while_nil`,
   `count_key_nil`, `lookup_nil`, `update_nil`, `chunk_two_nil`,
   `chunk_two_single`, `join_two_nil`, `count_up_zero`, `count_down_zero`,
   `pairs_nil`, `pairs_single`, `partition_below_nil`, `span_below_nil`,
   `run_max_nil`, `scan_add_nil` and `zip3_nil_left`/`_mid`/`_right`, plus
   `t1-assoc-keys`' `put_cons`, which is the same failure one step in: it is a
   step law whose left-hand side `Mk{k, v} <> kvs` is a cons the function never
   looks at, and the generated rule that rewrites steps had nothing to rewrite
   there. One targeted file per law, 26 written and each re-measured as
   type-checking with its law in the failed list. The count is worth recording
   as a rate rather than a total: the previous sweep found 11 in 125 tasks, this
   one found 26 in 17 — because the batch is almost entirely list- and
   `PairL`-valued functions whose empty case *is* the base of the recursion,
   which is exactly where a step-rewriting generator has nothing to say. Two of
   the 26 needed a second pass: `pairs-single-answers-a-pair.bend` and
   `chunk-two-single-answers-a-pair.bend` first measured `tier 1` with
   `x (consumed more than once)`, because the natural mutant builds its pair
   from the head twice; the `+x` sigil fixes it, and a mutant that does not
   type-check is evidence of nothing. That is the same instrument error Fact 42
   records from the probe side.

   **The third run found six, and it is the one that shows the reading is the
   only thing that names the shape.** Fact 43's three tasks each arrived with a
   generated corpus of 8, 13 and 8 files and each has two targets, so four
   laws of every one of them were covered and **the empty case of all six was
   not** — `map_len_nil`, `longest_row_nil`, `snoc_each_nil`, `front_each_nil`,
   `swap_each_nil`, `sum_pair_nil`. Nothing refused: `stage_mutants` passed
   with `2 of 8 strong` because one strong mutant is all it asks for, V2 passed,
   V3 passed, and `validate` reported the bank valid. That is the argument for
   running the sweep on every batch rather than when a number looks wrong — the
   wrong number is the only warning, and for these three there was no wrong
   number until the per-law count was taken. One file per law, six written and
   each measured at tier 3 with its law in the failed list, which puts the three
   at six killers between them and the bank's `min` back at 1 over 459
   declarations.

**Human-reviewed laws for tier ≥ 3 are still not satisfied, and the bank no
longer says they are.** The second clause is the half that was closable and it
is closed. Eleven tasks at tier 3 carried `"reviewed": {"by": "lulzx"}` written
by the authoring agent through `--reviewer`, and no human had read them — Fact
27. All eleven are tier 3; the eight tasks at tier 4 and 5 carried no record,
which is the honest state and not a fix. **Three of the eleven had gone stale as
well as forged** — re-checked 2026-09-19, `t3-pad`, `t3-rev-rev` and
`t3-zip-sum` had law files whose hash no longer matched the hash in the review
record, so the record attested to laws no longer shipped. Two of the three were
this session's own repairs (`t3-pad` from Fact 36, `t3-rev-rev` from Fact 39):
editing `LAWS.bend` under a review record invalidated it, and nothing in the
pipeline noticed.

**It notices now, and the arithmetic above was short.** Read over the whole
manifest rather than over the batch it was written from, **39 tasks are at tier
3 or above and 28 of them carry no record at all** — 20 tier 3, the five tier 4
and the three tier 5. The paragraph that stood here named the eight tier-4 and
tier-5 tasks and the seven most recent additions, which is thirteen distinct
tasks: two of the seven are themselves among the eight, so the earlier
accounting double-counted them and left **fifteen older tier-3 tasks unnamed**.
The forged-record count is still bounded at eleven, which is what that sentence
was about, and the *unreviewed* count is much larger than the sentence implied.
`gavel/validate.py` reads the record and reports one of four states —
`none-needed` below the tier, `unreviewed`, `stale`, `current` — and
`tools/validate.py` prints the stale and unreviewed task ids under its summary,
so the two defects are lines in a build log rather than paragraphs in this file.

**The forgery is no longer possible, and that is the fix rather than a
renaming.** The plan named two acceptable repairs — "either review is recorded
somewhere the pipeline cannot write, or the laws are read and the records are
made true" — and the first is now the design. The record moved out of
`meta.json` to `reviews/<task_id>.json`, beside the manifest and outside both
the task directory and the reference directory, and **no module under `gavel/`
or `tools/` opens a path under `reviews/` for writing**; `gavel/reviews.py` is
the reader and there is no writer outside a person's editor. `--reviewer` is
deleted rather than deprecated, along with the plumbing behind it, so the
capability is gone and not merely discouraged. `tools/author.py` still refuses
to publish a tier ≥ 3 task without a record and now has no way to make one, and
a test asserts the absence directly: no `reviewer` parameter, no `REVIEWED_KEY`,
and the flag rejected by the parser.

The reason this had to be structural rather than a rule is that the old shape
was not a mistake in the pipeline's logic but in its *ownership*. `meta.json` is
a **derived** file — `tools/publish.py` rewrites it on every publish — so a key
in it was always going to be writable by whatever wrote the file, and the record
was therefore a claim the claimant itself could issue. A record in `reviews/`
is a file the pipeline only reads, so its presence is a fact about a commit
rather than about a call. Eleven records were **deleted, not migrated**: moving
a forgery into the new directory would have made it read as `current` there, and
a repair that preserves the defect is not a repair. The bank now reports
`reviews/ holds 0 of the 39 records tier 3+ asks for`, which is the first time
that number and the truth have agreed — it read 8 of 39 before, all eight
written by the agent that wrote the task, against a human-reviewed figure of 0.

**What is left is the half no check can do, and it is smaller than it was.** A
record hand-written by whoever holds the keyboard is still indistinguishable
from a person's; moving the file took away the pipeline's ability to *create*
the evidence, not anyone's ability to write it. What it bought is that the act
now leaves a trace the old one did not: a new file under `reviews/` in a diff,
where a key inside a regenerated `meta.json` was invisible by construction. So
the item stands as: the bank no longer claims a review it does not have, the
pipeline can no longer manufacture one, and what remains is that **a person has
to read 39 law sets and write 39 files**. That is not a code change, and this
line stays in M4 until someone does it.

**`stale` is a warning and not a problem, deliberately**, which is the one place
the validator departs from "a problem is a defect, a warning is a missing
measurement". A review record is not part of the reward function, and the check
can see that a record is about *other laws* but cannot see who wrote one.
Failing on `stale` would hard-fail a record that had drifted while passing one
that matched its laws and was written by an agent — a validator that refuses the
milder defect and endorses the worse one. `--strict` promotes both, which is the
honest switch: it fails the moment review is a thing the bank actually has. The
state is only reachable through a republish, too — `meta["hashes"]` is
gate-enforced against the shipped laws, so a law edited without one fails the
integrity check on every submission instead. There is no record in the bank to
be stale at the moment, which is the point; the state is pinned by
`test_a_review_whose_hashes_have_moved_is_stale_and_still_valid` against the
real fixture task with its reference directory copied somewhere writable, so the
test writes a review into a temporary repository rather than into this one.

## 5. Risks

- **Syntax churn.** Bend went 2.0.3 → 2.0.5 in under 24 h. Mitigation: the bank is pinned, `migrate.py` exists from M2, and the tokenizer is version-tagged. *Revised down by M2.3:* the whole bank was re-validated against 2.0.3 and 2.0.4 with zero quarantine, so for these constructs the churn is not the live hazard. The mitigation stays because the sample is 20 tasks that all stick to the constructs the Bend guide covers — the unmeasured risk is the constructs a larger bank would reach for.
- **Checker soundness.** The guide says the Lean model lags the implementation. Mitigation: mutant tripwire, adversarial corpus, and success keyed on exact output, not exit code.
- **Authoring throughput.** Hand-written proofs in a no-tactics language are slow. M0 deliberately keeps 20 tasks small; M2 relies on the agent loop.
- **Fact 8 cost.** Per-law runs multiply latency on failed turns. Bounded by n² × 0.2 s with n ≤ 5, and the persistent worker in M3 shrinks the constant.

## 6. First actions

1. `uv init`, vendor 2.0.5 into `toolchain/`, commit the hash.
2. Port the §0 probe files into `tests/fixtures/add_zero/` as the first task and the first adversarial cases.
3. Implement `runner.py` and `check.py` against that fixture, then iterate on tasks.

**How it went.** Steps 1 and 3 as written. Step 2 became the bank instead of a
fixture directory: `tests/fixtures/` was never created, because a fixture task
and a real one would have been two places to keep the same facts, and the
degenerate corpus is generated from whichever task is under test (Fact 22,
Fact 28). The probe files survive as `tests/adversarial/`, which is what item 2
was actually for — one file per construct the gate must refuse, re-run against
a new Bend version.
