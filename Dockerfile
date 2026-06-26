# Stage 1: Clone and build the binary from GitHub
FROM rust:1.78-slim AS builder
WORKDIR /usr/src
RUN apt-get update && apt-get install -y git pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/Virtuals-Protocol/Infodemic-AI-Core.git app
WORKDIR /usr/src/app
RUN cargo build --release --locked

# Stage 2: Create a runner image that HAS cargo so Fly's hidden default doesn't crash
FROM rust:1.78-slim
WORKDIR /app

# Copy the compiled binary straight into /app
COPY --from=builder /usr/src/app/target/release/infodemic-ai-core /app/infodemic-ai-core

# Write a tiny dummy Cargo.toml so Fly's forced 'cargo run' doesn't fail
RUN echo '[package]\nname = "infodemic-ai-core"\nversion = "0.1.0"\nedition = "2021"\n[bin]\nname = "infodemic-ai-core"\npath = "infodemic-ai-core"' > Cargo.toml

# When Fly forces 'cargo run', it executes our pre-compiled binary instantly
CMD ["cargo", "run"]
