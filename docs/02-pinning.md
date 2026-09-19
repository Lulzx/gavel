# Pinning

The `bend` on your PATH is a launcher. It contacts a hub and updates itself,
and it moved from 2.0.4 to 2.0.5 while this project was being started. A
reward computed by a program that can change overnight is not reproducible.

Gavel therefore:

1. vendors the real checker under `toolchain/` at a fixed version.
2. records the SHA-256 of the vendored tree.
3. pins the bun version in `toolchain/bun.version`.
4. calls `bun bend2/main.ts` directly, never the launcher.

`gavel.toolchain.Toolchain.load` refuses to run if either pin has drifted, and
the test suite checks the bun it runs under against the pin.

Every verdict carries the toolchain hash and the bank hash, so a reward
recorded in a trajectory can always be traced to the exact checker and the
exact laws that produced it.

Migrating to a new checker release is a tool, not a manual step:
`tools/migrate.py` re-validates the whole bank against a candidate tree and
reports what quarantines.
