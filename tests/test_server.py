"""The socket protocol. The handler is tested without a socket; the transports
are tested over a real one.

Splitting it that way is deliberate: almost every way this can be wrong is a
question about :meth:`GavelServer.handle`, and running those through a socket
would make each one cost a bind, a thread, and a connect.
"""

from __future__ import annotations

import json
import shutil
import socket
import threading
from pathlib import Path

import pytest

from gavel.server import MAX_LINE, GavelServer, HTTPServer, UnixServer
from gavel.tasks import PROOF_FILE, SOLUTION_FILE

pytestmark = pytest.mark.checker

TASK = "t1-add-succ"

# Enough threads that the counter is contended, few enough that the assertion
# on it is readable.
WORKERS = 8


@pytest.fixture
def server(manifest, toolchain):
    made = GavelServer(manifest=manifest, toolchain=toolchain, backend="plain")
    yield made
    made.close()


def ask(server, **request):
    return server.handle(request)


def solve(server, session, task):
    return ask(server, op="step", session=session,
               files={SOLUTION_FILE: task.reference_solution,
                      PROOF_FILE: task.reference_proof})


# --- the handler ------------------------------------------------------------------

def test_health_describes_the_bank(server):
    reply = ask(server, op="health")
    assert reply["ok"]
    assert reply["tasks"] == len(server.manifest)
    assert reply["bend_version"] == server.toolchain.version
    assert reply["bank_hash"] == server.manifest.hash


def test_a_malformed_frame_is_answered_not_fatal(server):
    """A client that sends one bad line should lose that line, not the run."""
    reply = json.loads(server.serve_line("{not json"))
    assert not reply["ok"]
    assert reply["error"] == "invalid"
    # And the server still works.
    assert ask(server, op="health")["ok"]


def test_an_unknown_op_is_refused_by_name(server):
    reply = ask(server, op="frobnicate")
    assert not reply["ok"] and reply["error"] == "invalid"
    assert "frobnicate" in reply["message"]


def test_a_request_that_is_not_an_object_is_refused(server):
    assert server.handle(["reset"])["error"] == "invalid"


def test_reset_mints_a_session_and_returns_the_observation(server):
    reply = ask(server, op="reset", task_id=TASK)
    assert reply["ok"] and reply["session"]
    observation = reply["observation"]
    assert observation["task_id"] == TASK
    assert observation["turn"] == 1
    assert observation["prompt"]
    assert observation["proof_header"]


def test_stepping_without_a_session_is_refused_not_crashed(server):
    reply = ask(server, op="step", files={})
    assert not reply["ok"] and reply["error"] == "refused"


def test_an_unknown_session_says_so(server):
    reply = ask(server, op="step", session="no-such-session", files={})
    assert not reply["ok"] and "no-such-session" in reply["message"]


def test_files_must_be_an_object_of_strings(server):
    session = ask(server, op="reset", task_id=TASK)["session"]
    assert not ask(server, op="step", session=session, files=[])["ok"]
    assert not ask(server, op="step", session=session,
                   files={SOLUTION_FILE: 42})["ok"]
    assert not ask(server, op="step", session=session)["ok"]


def test_a_reference_submission_solves_over_the_protocol(server, task):
    session = ask(server, op="reset", task_id=TASK)["session"]
    reply = solve(server, session, task)
    assert reply["ok"]
    assert reply["done"]
    assert reply["reward"] == pytest.approx(1.0)
    assert reply["info"]["tier"] == 4
    assert reply["info"]["laws_proven"] == list(task.laws)


def test_a_rejected_submission_still_answers_with_a_verdict(server, task):
    """Tier 0 is a reward, not a transport error."""
    session = ask(server, op="reset", task_id=TASK)["session"]
    reply = ask(server, op="step", session=session, files={
        SOLUTION_FILE: "import Base\n@unsafe\ndef add(a: Nat, b: Nat) -> Nat:\n  add(a, b)\n",
        PROOF_FILE: task.proof_header})
    assert reply["ok"]
    assert reply["reward"] == 0.0
    assert reply["info"]["gate"]["passed"] is False
    assert reply["info"]["gate"]["findings"]


def test_an_action_that_cannot_be_scored_is_an_error_frame(server, task):
    """``Action`` refuses a file the policy may not write; the server turns
    that into a reply rather than a traceback that kills the connection."""
    session = ask(server, op="reset", task_id=TASK)["session"]
    reply = ask(server, op="step", session=session, files={"LAWS.bend": "x"})
    assert not reply["ok"]
    assert reply["error"] == "failed"


def test_two_sessions_do_not_share_a_turn_counter(server, task):
    one = ask(server, op="reset", task_id=TASK)["session"]
    two = ask(server, op="reset", task_id=TASK)["session"]
    ask(server, op="step", session=one, files={SOLUTION_FILE: task.reference_solution,
                                               PROOF_FILE: task.proof_header})
    reply = ask(server, op="reset", task_id=TASK, session=two)
    assert reply["observation"]["turn"] == 1
    assert two in server.sessions


def test_closing_a_session_twice_is_not_an_error(server):
    """A client cleaning up after a dropped connection cannot know whether the
    first close landed."""
    session = ask(server, op="reset", task_id=TASK)["session"]
    assert ask(server, op="close", session=session)["ok"]
    assert ask(server, op="close", session=session)["ok"]
    assert session not in server.sessions


def test_a_session_is_stepped_by_one_thread_at_a_time(server, task):
    """The transport is threaded and a client may open two connections on one
    session id, so a step has to be atomic.

    Testing this by its *symptom* does not work, which is worth recording.
    ``turn += 1`` is four bytecodes and CPython does not switch between them,
    so the obvious assertion -- eight threads step, the counter reads eight --
    holds whether or not the lock is there. What the lock actually buys is
    that two steps are never inside the env at once, so that is what is
    measured: a step takes a checker subprocess, and two threads released
    from a barrier are inside that window together unless something stops
    them.
    """
    session_id = ask(server, op="reset", task_id=TASK)["session"]
    session = server.sessions[session_id]
    # Not solved, so the episode runs its turns out rather than ending on the
    # first one -- every thread has to reach the env to be counted.
    submission = {SOLUTION_FILE: task.reference_solution,
                  PROOF_FILE: task.proof_header}
    session.env.max_turns = WORKERS
    watched = _Watched(session.env)
    session.env = watched
    watchers = threading.Barrier(WORKERS)

    def step() -> None:
        watchers.wait()
        ask(server, op="step", session=session_id, files=submission)

    threads = [threading.Thread(target=step) for _ in range(WORKERS)]
    for thread in threads:
        thread.start()
    for thread in threads:
        thread.join()

    assert not watched.overlapped
    assert watched.entered == WORKERS
    assert server.metrics.turns == WORKERS


class _Watched:
    """An env that notices if two threads are ever inside :meth:`step`."""

    def __init__(self, env) -> None:
        self._env = env
        self._count = threading.Lock()
        self.inside = 0
        self.entered = 0
        self.overlapped = False

    def __getattr__(self, name):
        return getattr(self._env, name)

    def step(self, action):
        with self._count:
            self.inside += 1
            self.entered += 1
            self.overlapped |= self.inside > 1
        try:
            return self._env.step(action)
        finally:
            with self._count:
                self.inside -= 1


def test_resetting_an_id_the_client_already_holds_keeps_the_old_episode(server,
                                                                        task):
    """A second reset on the same id starts a new episode, and the turns the
    first one spent are data -- so the old env is closed, which logs an open
    episode, rather than dropped."""
    submission = {SOLUTION_FILE: task.reference_solution,
                  PROOF_FILE: task.proof_header}
    ask(server, op="reset", task_id=TASK, session="mine")
    ask(server, op="step", session="mine", files=submission)
    assert server.metrics.episodes == 0            # still open: one turn left
    ask(server, op="reset", task_id=TASK, session="mine")
    assert server.metrics.episodes == 1            # the abandoned one was logged
    assert ask(server, op="step", session="mine", files=submission)["ok"]


def test_a_solved_episode_lands_in_the_servers_one_report(server, task):
    """The report is about the run, and the run is every client."""
    for _ in range(2):
        session = ask(server, op="reset", task_id=TASK)["session"]
        solve(server, session, task)
        ask(server, op="close", session=session)
    report = ask(server, op="health")["metrics"]
    assert report["episodes"] == 2
    assert report["solved"] == 2
    assert server.metrics.episodes == 2


# --- the transports -----------------------------------------------------------------

def read_line(sock: socket.socket) -> dict:
    buffer = b""
    while not buffer.endswith(b"\n"):
        chunk = sock.recv(4096)
        if not chunk:
            break
        buffer += chunk
    return json.loads(buffer.decode())


@pytest.fixture
def unix(server):
    """A short socket path on purpose: ``sockaddr_un`` holds 104 bytes on
    macOS, and pytest's own tmp_path is longer than that."""
    import tempfile

    home = tempfile.mkdtemp(prefix="gv-")
    path = Path(home) / "s.sock"
    listener = UnixServer(path, server)
    thread = threading.Thread(target=listener.serve_forever, daemon=True)
    thread.start()
    try:
        yield path, listener
    finally:
        listener.shutdown()
        listener.server_close()
        thread.join(timeout=5)
        shutil.rmtree(home, ignore_errors=True)


def test_an_overlong_socket_path_is_refused_by_name(server, tmp_path):
    """The failure is otherwise an OSError from inside bind(), which says
    nothing about what to do."""
    from gavel.server import ServerError

    with pytest.raises(ServerError, match="socket path is"):
        UnixServer(tmp_path / ("x" * 200) / "s.sock", server)


def connect(path):
    """Connect once the listener is up. The file appears before the bind
    completes, so a bare exist() check races."""
    import time

    deadline = time.monotonic() + 5
    while True:
        probe = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        try:
            probe.connect(str(path))
            return probe
        except OSError:
            probe.close()
            if time.monotonic() > deadline:
                raise
            time.sleep(0.01)


def test_a_unix_client_can_run_a_whole_episode(unix, task):
    path, _ = unix
    with connect(path) as sock:
        send = lambda **r: (sock.sendall((json.dumps(r) + "\n").encode()),
                            read_line(sock))[1]
        session = send(op="reset", task_id=TASK)["session"]
        reply = send(op="step", session=session,
                     files={SOLUTION_FILE: task.reference_solution,
                            PROOF_FILE: task.reference_proof})
        assert reply["done"]
        assert reply["info"]["tier"] == 4
        assert send(op="close", session=session)["ok"]


def test_a_bad_frame_over_the_socket_does_not_close_it(unix):
    path, _ = unix
    with connect(path) as sock:
        sock.sendall(b"garbage\n")
        assert read_line(sock)["error"] == "invalid"
        sock.sendall((json.dumps({"op": "health"}) + "\n").encode())
        assert read_line(sock)["ok"]


def test_an_overlong_line_is_refused_without_reading_it(unix):
    """A frame past the cap is a client bug or an attempt to make the server
    allocate; either way it is answered, not read."""
    path, _ = unix
    with connect(path) as sock:
        sock.sendall(b"x" * (MAX_LINE + 10) + b"\n")
        assert read_line(sock)["error"] == "invalid"


def test_the_socket_is_not_world_writable(unix):
    """The socket is the access control: anything that can connect can submit
    arbitrary programs."""
    path, _ = unix
    assert path.stat().st_mode & 0o077 == 0


def test_two_clients_are_served_at_once(unix):
    """One check takes hundreds of milliseconds; a second client waiting on it
    would make the transport look like the bottleneck."""
    path, _ = unix
    with connect(path) as one, connect(path) as two:
        one.sendall((json.dumps({"op": "reset", "task_id": TASK}) + "\n").encode())
        two.sendall((json.dumps({"op": "health"}) + "\n").encode())
        assert read_line(one)["session"]
        assert read_line(two)["ok"]


@pytest.fixture
def http(server):
    listener = HTTPServer(server, "127.0.0.1", 0)
    thread = threading.Thread(target=listener.serve_forever, daemon=True)
    thread.start()
    try:
        yield listener.server_address[1]
    finally:
        listener.shutdown()
        listener.server_close()
        thread.join(timeout=5)


def http_call(port, method, path, body=None):
    import urllib.request

    request = urllib.request.Request(
        f"http://127.0.0.1:{port}{path}", method=method,
        data=None if body is None else json.dumps(body).encode(),
        headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(request, timeout=30) as response:
        return json.loads(response.read())


def test_http_health_and_metrics(http):
    assert http_call(http, "GET", "/health")["ok"]
    assert "episodes" in http_call(http, "GET", "/metrics")["metrics"]


def test_http_runs_an_episode(http, task):
    session = http_call(http, "POST", "/reset", {"task_id": TASK})["session"]
    reply = http_call(http, "POST", "/step", {
        "session": session,
        "files": {SOLUTION_FILE: task.reference_solution,
                  PROOF_FILE: task.reference_proof}})
    assert reply["done"] and reply["info"]["tier"] == 4
    assert http_call(http, "POST", "/close", {"session": session})["ok"]


def test_http_refuses_an_unknown_route(http):
    import urllib.error

    with pytest.raises(urllib.error.HTTPError) as caught:
        http_call(http, "POST", "/nonsense", {})
    assert caught.value.code == 404
    # ``HTTPError`` wraps the response, and the response holds the connection.
    # Nothing in the raise path closes either -- ``do_open`` closes the socket
    # but the response keeps a file object on it -- so an unread error leaves a
    # socket to the cyclic collector, which pytest's unraisable hook turns into
    # a failure under this suite's ``filterwarnings = ["error"]``.
    caught.value.close()


# --- the example client ------------------------------------------------------------

def test_the_typescript_client_runs_against_a_live_server(unix, repo, toolchain):
    """The example is the only non-Python client, so it is the only evidence
    that the protocol is actually usable from another stack. A test is what
    stops it rotting into a file that merely looks right."""
    import os
    import subprocess

    path, _ = unix
    result = subprocess.run(
        [str(toolchain.bun), "run", "examples/client.ts"],
        cwd=repo, capture_output=True, text=True, timeout=600,
        env={**os.environ, "GAVEL_SOCKET": str(path)})
    assert result.returncode == 0, result.stderr
    assert "tasks, bend" in result.stdout
    assert "server saw 3 episodes" in result.stdout
    # And the episodes it ran really are in the server's report.
    assert "reward 0.10" in result.stdout
