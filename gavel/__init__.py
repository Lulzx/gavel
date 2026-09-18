"""Gavel: a verifiable-reward RL environment where the Bend checker is the judge.

The public surface is small on purpose. ``GavelEnv`` is what an RL loop touches;
``check_submission`` is what a test or a tool touches; everything else is
machinery behind those two.
"""

from .check import CheckConfig, check_submission
from .tasks import Manifest, Task, load_manifest
from .toolchain import Toolchain, ToolchainError
from .verdict import (TIER_CHECKS, TIER_COMPLETE, TIER_NO_CHECK, TIER_PARTIAL,
                      TIER_REJECTED, CheckResult, GateFinding, GateResult,
                      Verdict)

__version__ = "0.1.0"

__all__ = [
    "CheckConfig", "CheckResult", "GateFinding", "GateResult", "Manifest",
    "TIER_CHECKS", "TIER_COMPLETE", "TIER_NO_CHECK", "TIER_PARTIAL",
    "TIER_REJECTED", "Task", "Toolchain", "ToolchainError", "Verdict",
    "check_submission", "load_manifest",
]
