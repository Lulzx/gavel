# The reward path, in the environment it is meant to run in.
#
# The point of this image is not portability. It is that ``bwrap`` is present,
# so ``runner.select_backend("auto")`` resolves to a real sandbox and the
# adversarial corpus is measured against the boundary that will exist in
# production rather than against the dev-only one that has none. A suite that
# only ever runs on the developer's laptop proves nothing about isolation --
# the laptop backend is a subprocess with good manners.

FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bubblewrap ca-certificates curl unzip \
    && rm -rf /var/lib/apt/lists/*

# bun is pinned by version and the pin is enforced at runtime against
# toolchain/bun.version (toolchain.py): a different bun can change checker
# behaviour, so "close enough" is not a thing here.
ARG BUN_VERSION=1.3.14
RUN curl -fsSL https://bun.sh/install | bash -s -- "bun-v${BUN_VERSION}" \
    && ln -sf /root/.bun/bin/bun /usr/local/bin/bun \
    && test "$(bun --version)" = "${BUN_VERSION}"

COPY --from=ghcr.io/astral-sh/uv:0.8 /uv /usr/local/bin/uv

WORKDIR /gavel

# Dependencies first: they change far less often than the harness does.
# README.md comes with them because pyproject.toml names it as the project's
# readme, and hatchling reads it while building the editable install -- without
# it the build fails here, one layer before the file would have arrived.
COPY pyproject.toml uv.lock README.md ./
RUN uv sync --frozen --no-dev

COPY . .

ENV GAVEL_BUN=/usr/local/bin/bun \
    UV_LINK_MODE=copy \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# No ENTRYPOINT trickery: the default is the suite, and the sandbox is not
# optional, so a check that cannot be sandboxed fails loudly here rather than
# quietly falling back.
CMD ["uv", "run", "pytest", "-q"]
