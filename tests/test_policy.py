"""Reply parsing and prompt assembly. No network, no checker."""

from __future__ import annotations

import pytest

from gavel.env import Action
from gavel.policy import (AnthropicPolicy, EchoPolicy, PolicyError, ScriptedPolicy,
                          action_from_reply, build_prompt, extract_json)
from gavel.tasks import PROOF_FILE, SOLUTION_FILE

OBSERVATION = {
    "task_id": "t-x",
    "tier": 2,
    "title": "A title",
    "prompt": "Do the thing.",
    "laws": "law a:\n  for x: Nat\n  {S.f(x) == x : Nat}",
    "stub": "import Base\n\ndef f(x: Nat) -> Nat:\n  ?TODO",
    "prelude": "import Base\n",
    "proof_header": "import Base\nimport ./LAWS.bend as L\n",
    "feedback": None,
}


# --- extract_json ---------------------------------------------------------------

def test_a_bare_object_parses():
    assert extract_json('{"a": 1}') == {"a": 1}


def test_a_fenced_object_parses():
    assert extract_json('Sure!\n```json\n{"a": 1}\n```\n') == {"a": 1}


def test_prose_around_the_object_is_ignored():
    assert extract_json('I wrote:\n{"a": {"b": 2}} hope that helps') == {"a": {"b": 2}}


def test_a_brace_inside_a_string_does_not_end_the_object():
    assert extract_json('{"code": "def f() { return }"}') == {"code": "def f() { return }"}


def test_an_escaped_quote_does_not_end_the_string():
    assert extract_json(r'{"s": "a \" } b"}') == {"s": 'a " } b'}


def test_a_truncated_object_is_skipped_for_a_later_complete_one():
    assert extract_json('{"broken": \n{"good": 1}') == {"good": 1}


def test_no_object_at_all_is_an_error():
    with pytest.raises(PolicyError, match="no JSON object"):
        extract_json("I cannot help with that.")


# --- action_from_reply ----------------------------------------------------------

def test_a_well_formed_reply_becomes_an_action():
    action = action_from_reply('{"solution": "import Base", "proof": "import Base"}')
    assert isinstance(action, Action)
    assert action.files[SOLUTION_FILE] == "import Base"
    assert action.files[PROOF_FILE] == "import Base"


def test_a_reply_missing_a_file_is_refused():
    with pytest.raises(PolicyError, match="missing"):
        action_from_reply('{"solution": "import Base"}')


def test_a_reply_cannot_smuggle_in_a_laws_file():
    """The model does not get to write the laws it is being scored against.

    Extra keys are dropped rather than forwarded, so a reply that tries is a
    reply whose attempt has no effect -- not an error worth failing on.
    """
    action = action_from_reply('{"solution": "x", "proof": "y", "LAWS.bend": "z"}')
    assert set(action.files) == {SOLUTION_FILE, PROOF_FILE}


# --- the prompt -----------------------------------------------------------------

def test_the_prompt_carries_everything_the_policy_needs():
    prompt = build_prompt(OBSERVATION)
    assert "Do the thing." in prompt
    assert "law a:" in prompt
    assert "?TODO" in prompt
    assert "./LAWS.bend as L" in prompt
    assert "import Base\n" in prompt


def test_the_prompt_omits_feedback_on_the_first_turn():
    assert "rejected your previous attempt" not in build_prompt(OBSERVATION)


def test_the_prompt_carries_feedback_when_there_is_some():
    prompt = build_prompt({**OBSERVATION, "feedback": "Error: type mismatch"})
    assert "rejected your previous attempt" in prompt
    assert "Error: type mismatch" in prompt


# --- the scripted and echo policies ---------------------------------------------

def test_a_scripted_policy_advances_one_reply_per_turn():
    policy = ScriptedPolicy(replies=[
        '{"solution": "s1", "proof": "p1"}',
        '{"solution": "s2", "proof": "p2"}',
    ])
    assert policy(OBSERVATION).files[SOLUTION_FILE] == "s1"
    assert policy(OBSERVATION).files[SOLUTION_FILE] == "s2"
    with pytest.raises(PolicyError, match="exhausted"):
        policy(OBSERVATION)


def test_the_echo_policy_sends_the_stub_back():
    action = EchoPolicy()(OBSERVATION)
    assert action.files[SOLUTION_FILE] == OBSERVATION["stub"]
    assert action.files[PROOF_FILE] == OBSERVATION["proof_header"]


def test_a_policy_without_a_key_refuses_to_start(monkeypatch):
    monkeypatch.delenv("ANTHROPIC_API_KEY", raising=False)
    with pytest.raises(PolicyError, match="ANTHROPIC_API_KEY"):
        AnthropicPolicy()


def test_the_base_url_can_be_redirected(monkeypatch):
    monkeypatch.setenv("ANTHROPIC_API_KEY", "k")
    monkeypatch.setenv("ANTHROPIC_BASE_URL", "http://127.0.0.1:9/v1/messages")
    assert AnthropicPolicy().base_url == "http://127.0.0.1:9/v1/messages"
