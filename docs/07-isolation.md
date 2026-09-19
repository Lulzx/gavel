# Isolation

Every check is a subprocess with a scrubbed environment, rlimits and a wall
clock. On Linux it is wrapped in bubblewrap: every namespace unshared, the
whole root bound read-only with the check's own directory bound back over it,
and no network.

Every verdict names the backend it ran under and whether that backend is a
security boundary. A reward is only as trustworthy as the process that
produced it, and that fact should travel with the reward rather than live in
someone's configuration.

## auto fails rather than downgrades

`auto` picks the strongest backend the machine can run. On Linux without
bubblewrap it raises rather than silently using the plain subprocess, because
a silent fallback produces a verdict that looks sandboxed in every field except
the one nobody reads.

A job that is not about isolation, such as macOS development or a lint job,
opts out once with `GAVEL_BACKEND=plain`. Every verdict it produces carries
`dev_only: true`.

## What the plain backend still does

Scrubbed environment, `BEND_HUB` pointed at an unroutable address, CPU and
memory rlimits, output caps, a process group that is killed on timeout. It
stops the checker from reaching the network and the filesystem by convention
only, which is why it is marked dev-only.

## Where the real thing is tested

`Dockerfile` builds the Linux environment with bubblewrap present, and
`tools/sandbox_check.py` proves a real check runs inside it. The first time the
adversarial corpus ran under it, it failed a test that had passed on the plain
backend for its whole life, which is why the check exists. The root is bound
read-only, so the checker can read host files; the boundary is writes,
processes and the network, not reads.
