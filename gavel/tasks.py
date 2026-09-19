"""Loading tasks from the bank and materialising a working directory.

A task is four files and a manifest entry. The directory the checker runs in is
built fresh from those files plus the submission, and never contains the
reference solution or the mutants (SPEC.md 15).
"""

from __future__ import annotations

import json
import shutil
import tempfile
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Iterator

from .hashing import hash_files, sha256_text
from .reviews import load_review

# The files a task owns. LAWS.bend and prelude.bend are immutable during an
# episode; solution.bend is the stub the policy replaces.
LAWS_FILE = "LAWS.bend"
PRELUDE_FILE = "prelude.bend"
SOLUTION_FILE = "solution.bend"
PROOF_FILE = "PROOF.bend"

# A task directory carrying this file is on disk but not part of the bank: it is
# held at the review checkpoint, and a publish skips it. The marker is a file
# rather than a manifest field because a manifest field can only describe tasks
# the manifest already has, and the whole point of a hold is to describe one it
# must not acquire. Removing the file is the deliberate act that registers it.
HOLD_FILE = "HOLD"


def is_held(root: Path) -> bool:
    return (root / HOLD_FILE).is_file()

# What the policy is allowed to submit (SPEC.md 6.3).
SUBMITTED_FILES = (SOLUTION_FILE, PROOF_FILE)

# The immutable files, and the key each is recorded under in meta.json. Shared
# with tools/publish.py so that the writer and the checker of a hash cannot
# drift apart -- when they did, the integrity check silently stopped covering
# LAWS.bend.
HASH_KEYS = {LAWS_FILE: "laws", PRELUDE_FILE: "prelude"}

DEFAULT_PROOF_HEADER = (
    "import Base\n"
    "import ./prelude.bend as P\n"
    "import ./solution.bend as S\n"
    "import ./LAWS.bend as L\n"
)


class TaskError(RuntimeError):
    pass


@dataclass(frozen=True)
class Task:
    task_id: str
    tier: int
    root: Path
    references: Path
    prompt: str
    laws_src: str
    prelude_src: str
    stub_src: str
    meta: dict[str, Any]
    hash: str

    @property
    def policy_targets(self) -> tuple[str, ...]:
        return tuple(self.meta.get("policy_targets", ()))

    @property
    def laws(self) -> tuple[str, ...]:
        return tuple(self.meta.get("laws", ()))

    @property
    def n_laws(self) -> int:
        return len(self.laws)

    @property
    def difficulty_weight(self) -> float:
        return float(self.meta.get("difficulty_weight", 1.0))

    @property
    def proof_header(self) -> str:
        return self.meta.get("proof_header", DEFAULT_PROOF_HEADER)

    @property
    def tags(self) -> tuple[str, ...]:
        return tuple(self.meta.get("tags", ()))

    @property
    def title(self) -> str:
        return self.meta.get("title", self.task_id)

    @property
    def reference_solution(self) -> str:
        return (self.references / SOLUTION_FILE).read_text()

    @property
    def reference_proof(self) -> str:
        return (self.references / PROOF_FILE).read_text()

    @property
    def mutant_paths(self) -> tuple[Path, ...]:
        mutants = self.references / "mutants"
        return tuple(sorted(mutants.glob("*.bend"))) if mutants.is_dir() else ()

    @property
    def repo(self) -> Path:
        """The repository this task was loaded from.

        Derived from the reference path (``<repo>/references/<task_id>``)
        rather than carried as a field, so a Task stays a description of its own
        files and nothing has to be threaded through ``load_task`` to answer
        where a task-level record outside the task directory lives.
        """
        return self.references.parent.parent

    @property
    def review(self) -> dict[str, Any] | None:
        """The task's review record, which no tool here can write.

        See ``gavel/reviews.py``: the record lives in ``reviews/<task_id>.json``
        so that the pipeline that publishes a task is not also able to attest
        that a person read it.
        """
        return load_review(self.repo, self.task_id)

    def task_files(self) -> dict[str, str]:
        return {LAWS_FILE: self.laws_src, PRELUDE_FILE: self.prelude_src,
                SOLUTION_FILE: self.stub_src}

    def observation(self, turn: int = 1, max_turns: int = 1,
                    feedback: str | None = None) -> dict[str, Any]:
        """SPEC.md 6.2, plus the proof header the policy must start from."""
        return {
            "task_id": self.task_id,
            "tier": self.tier,
            "title": self.title,
            "prompt": self.prompt,
            "laws": self.laws_src,
            "stub": self.stub_src,
            "prelude": self.prelude_src,
            "proof_header": self.proof_header,
            "policy_targets": list(self.policy_targets),
            "turn": turn,
            "max_turns": max_turns,
            "feedback": feedback,
        }

    def materialize(self, dest: Path, files: dict[str, str] | None = None,
                    include_proof: bool = True) -> Path:
        """Write the task files plus a submission into a fresh directory."""
        dest = Path(dest)
        dest.mkdir(parents=True, exist_ok=True)
        merged = self.task_files()
        if files:
            for name, text in files.items():
                if name in (LAWS_FILE, PRELUDE_FILE):
                    # Never overwritten: integrity is the whole point.
                    raise TaskError(f"{name} is immutable and cannot be submitted")
                merged[name] = text
        for name, text in merged.items():
            if name == PROOF_FILE and not include_proof:
                continue
            (dest / name).write_text(text)
        return dest


@dataclass
class Manifest:
    path: Path
    bank: dict[str, Any]
    tasks: dict[str, Task] = field(default_factory=dict)

    @property
    def root(self) -> Path:
        return self.path.parent

    @property
    def bend_version(self) -> str:
        return self.bank.get("bend_version", "")

    @property
    def toolchain_hash(self) -> str:
        return self.bank.get("toolchain_hash", "")

    @property
    def hash(self) -> str:
        """The bank's identity: its version, and every task's hash by id.

        Not a hash of ``manifest.json``, which carries fields -- timestamps,
        calibration numbers -- that change without changing what a task *is*.
        This is the pair a trajectory has to record for its rewards to mean
        anything later: which tasks, and which checker.
        """
        return sha256_text(json.dumps(
            [self.bank.get("version"), self.bend_version, self.toolchain_hash]
            + [[task.task_id, task.hash] for task in sorted(
                self.tasks.values(), key=lambda t: t.task_id)],
            sort_keys=True))

    def __iter__(self) -> Iterator[Task]:
        return iter(self.tasks.values())

    def __len__(self) -> int:
        return len(self.tasks)

    def get(self, task_id: str) -> Task:
        try:
            return self.tasks[task_id]
        except KeyError:
            raise TaskError(f"no task {task_id!r} in {self.path}") from None

    def by_tier(self, tier: int) -> list[Task]:
        return [t for t in self.tasks.values() if t.tier == tier]

    def to_json(self) -> dict[str, Any]:
        return self.bank


def load_task(root: Path, entry: dict[str, Any], bank_root: Path) -> Task:
    root = Path(root)
    missing = [name for name in (LAWS_FILE, PRELUDE_FILE, SOLUTION_FILE, "meta.json")
               if not (root / name).is_file()]
    if missing:
        raise TaskError(f"{root} is missing {', '.join(missing)}")
    meta = json.loads((root / "meta.json").read_text())
    prompt_file = root / "prompt.md"
    laws_src = (root / LAWS_FILE).read_text()
    prelude_src = (root / PRELUDE_FILE).read_text()
    stub_src = (root / SOLUTION_FILE).read_text()
    references = bank_root / entry.get("reference", f"references/{meta['task_id']}")
    return Task(
        task_id=meta["task_id"],
        tier=int(meta["tier"]),
        root=root,
        references=references,
        prompt=prompt_file.read_text() if prompt_file.is_file() else "",
        laws_src=laws_src,
        prelude_src=prelude_src,
        stub_src=stub_src,
        meta=meta,
        hash=hash_files({LAWS_FILE: laws_src, PRELUDE_FILE: prelude_src,
                         SOLUTION_FILE: stub_src}),
    )


# ``gavel/``'s parent, which is the repository. A manifest entry's ``path`` and
# ``reference`` are relative to this rather than to the manifest, because that
# is what the tools that write them emit -- ``tools/publish.py`` builds both
# with ``root.relative_to(repo)`` -- so a manifest that has been moved out of
# the repository root still names the same tasks. Resolving against the
# manifest instead was correct only while every manifest sat at the root, and
# said so nowhere; when the authoring manifests moved into ``scratch/`` the
# whole CLI stopped being able to read them.
REPO_ROOT = Path(__file__).resolve().parent.parent


def _entry_base(bank_root: Path, entry: dict[str, Any]) -> Path:
    """The directory ``entry["path"]`` is relative to.

    The repository root, except where the manifest is at the root of a
    *different* tree -- a checkout copied into a temporary directory by a test,
    which is the case that made the manifest's own directory the right answer
    to reach for first. The two agree whenever the manifest sits in the
    repository it describes, which is every manifest this repository ships.
    """
    if (bank_root / entry["path"]).is_dir():
        return bank_root
    return REPO_ROOT


def load_manifest(path: Path | str) -> Manifest:
    path = Path(path)
    if not path.is_file():
        raise TaskError(f"no manifest at {path}")
    bank = json.loads(path.read_text())
    bank_root = path.resolve().parent
    manifest = Manifest(path=path, bank=bank)
    for entry in bank.get("tasks", []):
        # A quarantined task is excluded on purpose -- see ``tools/publish.py``
        # for why this is not a claim about validity.
        if entry.get("quarantined"):
            continue
        base = _entry_base(bank_root, entry)
        root = (base / entry["path"]).resolve()
        task = load_task(root, entry, base)
        manifest.tasks[task.task_id] = task
    return manifest


def prepare_workdir(task: Task, files: dict[str, str] | None = None,
                    parent: Path | None = None) -> Path:
    """A fresh directory for one check. Caller removes it."""
    workdir = Path(tempfile.mkdtemp(prefix="gavel-", dir=parent))
    task.materialize(workdir, files, include_proof=bool(files and PROOF_FILE in files))
    return workdir


def cleanup(workdir: Path) -> None:
    shutil.rmtree(workdir, ignore_errors=True)


def submission_hash(files: dict[str, str]) -> str:
    return hash_files(files)


def file_hash(text: str) -> str:
    return sha256_text(text)
