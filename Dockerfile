# ==========================================
# Stage 1: Build the application
# ==========================================
FROM rust:1.78-slim AS builder

WORKDIR /usr/src/app

# Install build dependencies (required for many Rust crates)
RUN apt-get update && apt-get install -y pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*

# Copy the configuration manifests first
COPY Cargo.toml Cargo.lock ./

# Copy the actual source code
COPY src ./src

# Build the release binary
RUN cargo build --release --locked

# ==========================================
# Stage 2: Run the application
# ==========================================
FROM debian:bookworm-slim

WORKDIR /app

# Install runtime dependencies (like SSL certificates for web requests)
RUN apt-get update && apt-get install -y ca-certificates libssl3 && rm -rf /var/lib/apt/lists/*

# Copy the compiled binary from the builder stage
# NOTE: Replace 'infodemic-ai-core' with the actual binary name defined in your Cargo.toml if it differs
COPY --from=builder /usr/src/app/target/release/infodemic-ai-core /app/infodemic-ai-core

# Set the startup command
CMD ["./infodemic-ai-core"]
