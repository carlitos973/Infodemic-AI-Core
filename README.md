FROM rust:1.75-slim AS builder

RUN apt-get update && apt-get install -y \
    build-essential pkg-config libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/gitlawb
COPY . .
RUN cargo build --release --locked

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    ca-certificates libssl3 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/src/gitlawb/target/release/gitlawb-node /usr/local/bin/gitlawb-node
CMD ["gitlawb-node"]