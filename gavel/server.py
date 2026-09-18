"""The episode protocol over a socket, for stacks that are not Python.

SPEC.md 6.1 says the API is transport-agnostic. The in-process ``GavelEnv`` is
the reference; this is the same protocol written down as JSON, served over a
Unix domain socket or over HTTP on loopback. Nothing here reimplements the
protocol -- every request lands in :meth:`GavelServer.handle`, and both
transports call it -- so a bug in one is a bug in both, which is the only way
two transports stay honest with each other.

Sessions rather than connections. HTTP has no connection to hang an episode on,
and even over a socket a client may want several episodes open at once. A
``reset`` mints a session id, and every later request carries it. Sessions
share the bank, the toolchain, the cache, the trajectory, and the metrics; each
holds its own episode state, because two policies must not share a turn
counter.

One request per line, one response per line, in that order. A malformed request
is answered with an error and does not close the connection: a client that
sends one bad frame should lose that frame, not the run.
"""

from __future__ import annotations

import json
import os
import socketserver
import threading
import uuid
from dataclasses import dataclass, field
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from typing import Any

from .cache import VerdictCache
from .check import CheckConfig
from .env import Action, GavelEnv
from .metrics import Metrics
from .tasks import Manifest, load_manifest
from .toolchain import DEFAULT_VERSION, Toolchain
from .trajectory import Trajectory

# A submission is a file or two of Bend. A megabyte of JSON per line is already
# two orders of magnitude past anything the gate would accept, so anything
# larger is a client bug or an attempt to make the server allocate; either way
# the answer is to refuse the frame rather than to read it.
MAX_LINE = 1024 * 1024

OPS = ("reset", "step", "close", "health")


class ServerError(RuntimeError):
    """A request the server understood and refused. Becomes an error frame."""


@dataclass
class Session:
    """One policy's episode. Holds the env, and the id it answers to.

    The lock is per session, not per server, because the shared things --
    the cache, the log, the report -- already guard themselves, and what is
    not shared is the env. A step mutates the turn counter, the turn list, and
    the running best, so two connections carrying the same session id would
    race on all three; the transport is threaded and nothing stops a client
    from opening two.
    """

    session_id: str
    env: GavelEnv
    lock: threading.Lock = field(default_factory=threading.Lock, repr=False)


@dataclass
class GavelServer:
    """The protocol, independent of how the bytes arrived."""

    manifest: Manifest
    toolchain: Toolchain
    mode: str = "dense"
    max_turns: int = 4
    backend: str = "auto"
    store_actions: bool = False
    cache: VerdictCache | None = None
    trajectory: Trajectory | None = None
    metrics: Metrics = field(default_factory=Metrics)

    sessions: dict[str, Session] = field(default_factory=dict, init=False)
    _lock: threading.Lock = field(default_factory=threading.Lock,
                                  init=False, repr=False)
    _closed: bool = field(default=False, init=False, repr=False)

    @property
    def closed(self) -> bool:
        return self._closed

    @classmethod
    def from_manifest(cls, path: Path | str = "manifest.json",
                      **kwargs: Any) -> "GavelServer":
        manifest = load_manifest(Path(path))
        toolchain = Toolchain.load(manifest.bend_version or DEFAULT_VERSION)
        return cls(manifest=manifest, toolchain=toolchain, **kwargs)

    # --- protocol --------------------------------------------------------------

    def handle(self, request: dict[str, Any]) -> dict[str, Any]:
        """One request. Never raises for a client's mistake."""
        if not isinstance(request, dict):
            return _error("invalid", "a request must be a JSON object")
        op = request.get("op")
        if op not in OPS:
            return _error("invalid",
                          f"unknown op {op!r}; expected one of {list(OPS)}")
        try:
            return getattr(self, f"_op_{op}")(request)
        except ServerError as exc:
            return _error("refused", str(exc))
        except Exception as exc:                       # noqa: BLE001
            # A crash in one request must not take the server with it: an
            # unattended soak is supposed to be unattended.
            return _error("failed", f"{type(exc).__name__}: {exc}")

    def serve_line(self, line: str) -> str:
        """One line in, one line out. The whole transport-facing surface."""
        try:
            request = json.loads(line)
        except json.JSONDecodeError as exc:
            return json.dumps(_error("invalid", f"malformed JSON: {exc}"))
        return json.dumps(self.handle(request))

    # --- ops -------------------------------------------------------------------

    def _op_health(self, request: dict[str, Any]) -> dict[str, Any]:
        return {"ok": True, "op": "health", "tasks": len(self.manifest),
                "bend_version": self.toolchain.version,
                "bank_hash": self.manifest.hash,
                "sessions": len(self.sessions),
                "episodes": self.metrics.episodes,
                "metrics": self.metrics.to_json()}

    def _op_reset(self, request: dict[str, Any]) -> dict[str, Any]:
        task_id = request.get("task_id")
        if task_id is not None and not isinstance(task_id, str):
            return _error("invalid", "task_id must be a string or null")
        session = self.new_session(request.get("session"))
        with session.lock:
            observation = session.env.reset(task_id)
        return {"ok": True, "op": "reset", "session": session.session_id,
                "observation": observation}

    def _op_step(self, request: dict[str, Any]) -> dict[str, Any]:
        session = self.session(request.get("session"))
        files = request.get("files")
        if not isinstance(files, dict) or not all(
                isinstance(k, str) and isinstance(v, str)
                for k, v in files.items()):
            return _error("invalid",
                          "files must be an object of string -> string")
        with session.lock:
            observation, reward, done, verdict = session.env.step(
                Action(files=files))
        return {"ok": True, "op": "step", "session": session.session_id,
                "observation": observation, "reward": reward, "done": done,
                "info": verdict.to_json()}

    def _op_close(self, request: dict[str, Any]) -> dict[str, Any]:
        """End a session. Ending one that is already gone is not an error: a
        client cleaning up after a dropped connection cannot know."""
        session_id = request.get("session")
        with self._lock:
            session = self.sessions.pop(session_id, None)
        if session is not None:
            # Under the session's own lock, so a close cannot land in the
            # middle of the step it is closing on top of.
            with session.lock:
                session.env.close()
        return {"ok": True, "op": "close", "session": session_id}

    # --- sessions --------------------------------------------------------------

    def new_session(self, session_id: str | None = None) -> Session:
        identifier = session_id or uuid.uuid4().hex[:12]
        env = GavelEnv(manifest=self.manifest, toolchain=self.toolchain,
                       mode=self.mode, max_turns=self.max_turns,
                       config=CheckConfig(backend=self.backend),
                       cache=self.cache, trajectory=self.trajectory,
                       store_actions=self.store_actions)
        # Every session's episodes land in the server's one report, because a
        # report is about the run and the run is every client.
        env.metrics = self.metrics
        session = Session(session_id=identifier, env=env)
        with self._lock:
            previous = self.sessions.get(identifier)
            self.sessions[identifier] = session
        if previous is not None:
            # A client that resets an id it already holds is starting a new
            # episode. The turns it already spent are still data, so the old
            # env is closed -- which logs an open episode -- rather than
            # dropped on the floor.
            with previous.lock:
                previous.env.close()
        return session

    def session(self, session_id: Any) -> Session:
        if not isinstance(session_id, str) or not session_id:
            raise ServerError("a request after reset must carry its session id")
        with self._lock:
            session = self.sessions.get(session_id)
        if session is None:
            raise ServerError(f"no session {session_id!r}; call reset first")
        return session

    def close(self) -> None:
        """Stop serving and release everything this server owns.

        The cache is closed here, unlike in ``GavelEnv``: a server owns its
        memo, whereas an env merely borrows one.
        """
        with self._lock:
            sessions, self.sessions = list(self.sessions.values()), {}
            self._closed = True
        for session in sessions:
            with session.lock:
                session.env.close()
        if self.trajectory is not None:
            self.trajectory.close()
        if self.cache is not None:
            self.cache.close()


def _error(kind: str, message: str) -> dict[str, Any]:
    return {"ok": False, "error": kind, "message": message}


# --- transport: Unix domain socket ------------------------------------------------

class _UnixHandler(socketserver.StreamRequestHandler):
    def handle(self) -> None:
        server: "UnixServer" = self.server  # type: ignore[assignment]
        while True:
            line = self.rfile.readline(MAX_LINE + 1)
            if not line:
                return
            if len(line) > MAX_LINE:
                self._send(json.dumps(_error(
                    "invalid", f"request line exceeds {MAX_LINE} bytes")))
                return
            self._send(server.gavel.serve_line(line.decode("utf-8")))
            if server.gavel.closed:
                return

    def _send(self, text: str) -> None:
        self.wfile.write((text + "\n").encode("utf-8"))
        self.wfile.flush()


class UnixServer(socketserver.ThreadingUnixStreamServer):
    """A Unix socket, one thread per client.

    Threaded because a check takes hundreds of milliseconds and a second client
    waiting on it would make the transport look like the bottleneck.
    """

    daemon_threads = True
    allow_reuse_address = True

    def __init__(self, path: Path | str, gavel: GavelServer) -> None:
        self.gavel = gavel
        self.path = Path(path)
        if self.path.parent and str(self.path.parent) not in ("", "."):
            self.path.parent.mkdir(parents=True, exist_ok=True)
        # ``struct sockaddr_un`` holds 104 bytes on macOS and 108 on Linux, and
        # the only sign of exceeding it is an OSError from deep inside the
        # bind. A test's tmp_path is routinely longer than that, so say what is
        # wrong instead of letting the caller decode AF_UNIX.
        if len(str(self.path).encode()) >= 104:
            raise ServerError(
                f"socket path is {len(str(self.path).encode())} bytes; the "
                f"limit is 103. Use a shorter directory (a temp dir, or an "
                f"abstract name) -- got {self.path}")
        if self.path.exists():
            # A stale socket from a killed run would otherwise fail the bind
            # with EADDRINUSE forever. Safe to remove: a live server has the
            # file open, and its owner is whoever is running this.
            self.path.unlink()
        super().__init__(str(self.path), _UnixHandler)
        # The socket is the access control, so it must not be world-writable:
        # anything that can connect can submit arbitrary programs.
        os.chmod(self.path, 0o600)

    def serve_forever(self, *args: Any, **kwargs: Any) -> None:
        try:
            super().serve_forever(*args, **kwargs)
        finally:
            self.server_close()
            self.path.unlink(missing_ok=True)


# --- transport: HTTP ---------------------------------------------------------------

class _HTTPHandler(BaseHTTPRequestHandler):
    server_version = "gavel"
    protocol_version = "HTTP/1.1"

    def do_GET(self) -> None:                       # noqa: N802
        if self.path.rstrip("/") in ("", "/health"):
            self._reply(self.server.gavel.handle({"op": "health"}))  # type: ignore[attr-defined]
        elif self.path.rstrip("/") == "/metrics":
            self._reply({"ok": True, "metrics": self.server.gavel.metrics.to_json()})  # type: ignore[attr-defined]
        else:
            self._reply(_error("invalid", f"no route {self.path!r}"), status=404)

    def do_POST(self) -> None:                      # noqa: N802
        routes = {"/reset": "reset", "/step": "step", "/close": "close"}
        op = routes.get(self.path.rstrip("/"))
        if op is None:
            self._reply(_error("invalid", f"no route {self.path!r}"), status=404)
            return
        length = int(self.headers.get("Content-Length") or 0)
        if length > MAX_LINE:
            self._reply(_error("invalid", "request body too large"), status=413)
            return
        raw = self.rfile.read(length)
        try:
            body = json.loads(raw or b"{}")
        except json.JSONDecodeError as exc:
            self._reply(_error("invalid", f"malformed JSON: {exc}"), status=400)
            return
        body["op"] = op
        self._reply(self.server.gavel.handle(body))  # type: ignore[attr-defined]

    def _reply(self, body: dict[str, Any], status: int = 200) -> None:
        blob = json.dumps(body).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(blob)))
        self.end_headers()
        self.wfile.write(blob)

    def log_message(self, *args: Any) -> None:
        """Silent. The server's own metrics are the record; stderr is for
        whatever the operator put there."""


class HTTPServer(ThreadingHTTPServer):
    daemon_threads = True

    def __init__(self, gavel: GavelServer, host: str = "127.0.0.1",
                 port: int = 8765) -> None:
        self.gavel = gavel
        # Default loopback: this server runs whatever it is sent, so binding it
        # to a public interface is a decision the operator has to make on
        # purpose, by passing a host.
        super().__init__((host, port), _HTTPHandler)

    def serve_forever(self, *args: Any, **kwargs: Any) -> None:
        try:
            super().serve_forever(*args, **kwargs)
        finally:
            self.server_close()


def serve(*, socket_path: Path | str | None = None,
          http: tuple[str, int] | None = None,
          gavel: GavelServer | None = None,
          **kwargs: Any) -> None:
    """Block on one or both transports. Ctrl-C stops both."""
    server = gavel or GavelServer.from_manifest(**kwargs)
    servers: list[Any] = []
    if socket_path is not None:
        servers.append(UnixServer(socket_path, server))
    if http is not None:
        servers.append(HTTPServer(server, *http))
    if not servers:
        raise ValueError("serve() needs a socket_path, an http address, or both")

    threads = [threading.Thread(target=s.serve_forever, daemon=True)
               for s in servers[1:]]
    for thread in threads:
        thread.start()
    try:
        servers[0].serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        for extra in servers[1:]:
            extra.shutdown()
        for thread in threads:
            thread.join(timeout=2.0)
        server.close()


__all__ = ["GavelServer", "HTTPServer", "MAX_LINE", "OPS", "ServerError",
           "Session", "UnixServer", "serve"]
