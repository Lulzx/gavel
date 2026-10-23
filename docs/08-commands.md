# Commands

## Using the bank

```
uv run gavel list                                    # tasks by tier
uv run gavel info t1-add-plus                        # prompt, laws, stub
uv run gavel check t1-add-plus --reference
uv run gavel check t1-add-plus --solution my.bend --proof my-proof.bend
uv run gavel bench -n 10                             # check latency distribution
uv run gavel serve --socket /tmp/gavel.sock --http 127.0.0.1:8765
bun run examples/client.ts                           # a non-Python client
```

## Validating it

```
uv run python -m toolchain.fetch --bun                # the pinned bun, into toolchain/bun/
uv run gavel validate                                # V1–V6 over the whole bank
uv run python -m tools.validate --jobs 4             # the same, one process per task
uv run python -m tools.validate --strict             # warnings fail the build
uv run python -m tools.sandbox_check                 # prove the sandbox runs a real check
uv run python -m tools.holes -j 8                    # bodies the laws accept and the reference does not
uv run python -m tools.prompts check                 # the prompt contract, and every worked example
uv run python -m tools.soak -n 10000 -j 8 --out runs/soak
```

`tools/validate.py` and `tools/mutate.py` exit non-zero on failure, so they
can gate a merge.

## Authoring

```
uv run python -m tools.author tasks/2/t2-thing       # the stages, in order
uv run python -m tools.publish                       # derive metadata, rebuild manifest.json
uv run python -m tools.mutate --check                # author mutants, see which are strong
uv run python -m tools.screens anchors               # the static readings, per task
uv run python -m tools.docket                        # one review block per tier-3+ task
uv run python -m tools.calibrate --dry-run           # print the prompt, spend nothing
uv run python -m tools.calibrate -k 2 --via cli      # solve rate through the claude CLI
uv run python -m tools.prompts eval <task> "S.f(2n)" # the reference's value of a term
uv run python -m tools.migrate --from ~/.bend/app/2.0.4/rRKuW7 --label 2.0.4
```
