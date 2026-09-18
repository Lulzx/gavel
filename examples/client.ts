// A Gavel client in a stack that is not Python, run with the bun already
// pinned for the checker:  bun run examples/client.ts
//
// It speaks one JSON object per line over a Unix socket, which is the whole
// protocol. The point of the example is that an RL loop living in another
// language needs nothing from Gavel except the ability to write two files and
// read a reward.
//
// Start a server first:
//   uv run gavel serve --socket /tmp/gavel.sock
import { connect, type Socket } from "node:net";

const SOCKET = process.env.GAVEL_SOCKET ?? "/tmp/gavel.sock";

class Gavel {
  #socket: Socket;
  #buffer = "";
  #waiting: ((line: string) => void)[] = [];

  private constructor(socket: Socket) {
    this.#socket = socket;
    socket.setEncoding("utf8");
    socket.on("data", (chunk: string) => {
      this.#buffer += chunk;
      // One response per request, in order, so a queue is enough -- no need
      // to correlate replies with ids.
      for (let at = this.#buffer.indexOf("\n"); at >= 0; at = this.#buffer.indexOf("\n")) {
        const line = this.#buffer.slice(0, at);
        this.#buffer = this.#buffer.slice(at + 1);
        this.#waiting.shift()?.(line);
      }
    });
  }

  static open(path = SOCKET): Promise<Gavel> {
    return new Promise((resolve, reject) => {
      const socket = connect(path);
      socket.once("connect", () => resolve(new Gavel(socket)));
      socket.once("error", reject);
    });
  }

  private send(request: unknown): Promise<any> {
    return new Promise((resolve) => {
      this.#waiting.push((line) => resolve(JSON.parse(line)));
      this.#socket.write(JSON.stringify(request) + "\n");
    });
  }

  async reset(taskId: string | null = null) {
    const reply = await this.send({ op: "reset", task_id: taskId });
    if (!reply.ok) throw new Error(`reset: ${reply.message}`);
    return reply;
  }

  async step(session: string, files: Record<string, string>) {
    return await this.send({ op: "step", session, files });
  }

  async close(session: string) {
    return await this.send({ op: "close", session });
  }

  async health() {
    return await this.send({ op: "health" });
  }

  end() {
    this.#socket.end();
  }
}

// A policy worth roughly what it costs to write: fill each hole with any
// inhabitant of the declared return type. Enough to clear the type checker
// and therefore to earn tier 2 -- which is the part of the protocol worth
// showing, because it is the first reward that is not zero. It proves
// nothing, so no law is credited and the episode ends at the turn limit.
const INHABITANT: Record<string, string> = {
  Nat: "0n",
  Int: "0",
  Bool: "True",
  String: '""',
};

function bodyFor(signature: string): string {
  const returns = /->\s*([A-Za-z_][A-Za-z0-9_.]*(?:<[^>]*>)?)/.exec(signature)?.[1];
  if (!returns) return "0n";
  if (returns.startsWith("List")) return "Nil{}";
  return INHABITANT[returns] ?? "?TODO";
}

function proposal(observation: any): Record<string, string> {
  const solution = observation.stub
    .split("\n")
    .map((line: string) =>
      line.includes("?TODO")
        ? `${line.slice(0, line.indexOf("?TODO"))}${bodyFor(previousDef(observation.stub, line))}`
        : line,
    )
    .join("\n");
  return { "solution.bend": solution, "PROOF.bend": observation.proof_header };
}

function previousDef(stub: string, line: string): string {
  const at = stub.indexOf(line);
  return stub.slice(Math.max(0, stub.lastIndexOf("def ", at)), at).trim();
}

async function main() {
  const gavel = await Gavel.open();
  const health = await gavel.health();
  console.log(`${health.tasks} tasks, bend ${health.bend_version}`);

  for (let episode = 0; episode < 3; episode++) {
    let { session, observation } = await gavel.reset(null);
    let total = 0;
    for (let turn = 0; turn < observation.max_turns; turn++) {
      const reply = await gavel.step(session, proposal(observation));
      if (!reply.ok) throw new Error(`step: ${reply.message}`);
      total += reply.reward;
      console.log(
        `episode ${episode} turn ${turn + 1}: tier ${reply.info.tier}` +
          ` (${reply.info.tier_name}) reward ${reply.reward.toFixed(2)}`,
      );
      // The checker's own words, which is what a policy repairs from -- the
      // current task's solution is what the next turn would rewrite.
      if (reply.done) break;
      observation = reply.observation;
    }
    console.log(`episode ${episode}: ${total.toFixed(2)} total`);
    await gavel.close(session);
  }

  const after = await gavel.health();
  console.log(
    `server saw ${after.metrics.episodes} episodes, ` +
      `solve rate ${after.metrics.solve_rate}`,
  );
  gavel.end();
}

await main();
