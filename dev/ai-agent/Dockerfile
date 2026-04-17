#
# Dockerfile for Coding Agent environment
#

#
# Build stage
#
FROM debian:trixie-slim AS builder
LABEL maintainer="haeho7 <i@demo.com>"

# install packages
RUN apt-get update \
  && apt-get install --no-install-recommends -y \
      ca-certificates curl wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# install claude code
ARG CLAUDE_VER=2.1.110
RUN curl -fsSL https://claude.ai/install.sh | bash -s -- ${CLAUDE_VER} \
  && cd /root \
  && install .local/share/claude/versions/${CLAUDE_VER} /usr/local/bin/claude \
  && rm -rf .cache .claude .claude.json .local

# install codex
ARG CODEX_VER=rust-v0.121.0
RUN case "$(dpkg --print-architecture)" in \
       amd64) arch="x86_64";; \
       *) arch="aarch64";; \
    esac \
  && curl -L https://github.com/openai/codex/releases/download/${CODEX_VER}/codex-${arch}-unknown-linux-musl.tar.gz | \
      tar xzvf - -C /usr/local/bin/ codex-${arch}-unknown-linux-musl \
  && mv /usr/local/bin/codex-${arch}-unknown-linux-musl /usr/local/bin/codex

#
# Runtime stage
#
FROM haeho7/docker-images:dev
LABEL maintainer="haeho7 <i@demo.com>"

# install bubblewrap
RUN apt-get update \
  && apt-get install --no-install-recommends -y \
      ca-certificates bubblewrap \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# claude code
ENV DISABLE_AUTOUPDATER=1
ENV DISABLE_TELEMETRY=1
ENV CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1

# codex
ENV OPENAI_API_KEY=

COPY --from=builder /usr/local/bin/claude /usr/local/bin/
COPY --from=builder /usr/local/bin/codex /usr/local/bin/
