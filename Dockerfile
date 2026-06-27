FROM rust:1.78-slim AS builder

ARG GITHUB_TOKEN
WORKDIR /usr/src

RUN apt-get update && \
    apt-get install -y git pkg-config libssl-dev && \
    rm -rf /var/lib/apt/lists/*

RUN git clone \
    https://x-access-token:${GITHUB_TOKEN}@github.com/carlitos973/Infodemic-AI-Core.git \
    app

WORKDIR /usr/src/app
RUN cargo build --release

FROM debian:bookworm-slim AS runtime

WORKDIR /app

RUN apt-get update && \
    apt-get install -y ca-certificates libssl3 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/src/app/target/release/infodemic-ai-core /app/

CMD ["/app/infodemic-ai-core"]
