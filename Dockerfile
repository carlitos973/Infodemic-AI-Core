# Stage 1: Clone and build the binary from GitHub
FROM rust:1.78-slim AS builder
WORKDIR /usr/src
RUN apt-get update && apt-get install -y git pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*

# Paste your ghp_ token right here:
RUN git clone https://YOUR_TOKEN_HERE@github.com/Virtuals-Protocol/Infodemic-AI-Core.git app

WORKDIR /usr/src/app
RUN cargo build --release --locked

# Stage 2: Create a clean runner environment
FROM debian:bookworm-slim
WORKDIR /app
RUN apt-get update && apt-get install -y ca-certificates libssl3 && rm -rf /var/lib/apt/lists/*

# Copy the compiled binary from Stage 1
COPY --from=builder /usr/src/app/target/release/infodemic-ai-core /app/infodemic-ai-core

CMD ["./infodemic-ai-core"]
