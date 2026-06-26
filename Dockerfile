# Use the official Rust image as a builder
FROM docker.io/library/rust:1.78-slim AS builder

WORKDIR /usr/src

# Install required system dependencies for the build
RUN apt-get update && apt-get install -y git pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*

# Define the token argument
ARG GITHUB_TOKEN

# Clone the repository using the build argument variable
RUN git clone https://${GITHUB_TOKEN}@github.com/Virtuals-Protocol/Infodemic-AI-Core.git app

WORKDIR /usr/src/app

# Build the Rust application in release mode
RUN cargo build --release

# Use a slim Debian image for the final runtime container
FROM docker.io/library/debian:bookworm-slim AS runtime

WORKDIR /app

# Install runtime dependencies
RUN apt-get update && apt-get install -y ca-certificates libssl3 && rm -rf /var/lib/apt/lists/*

# Copy the compiled binary from the builder stage
COPY --from=builder /usr/src/app/target/release/infodemic-ai-core /app/infodemic-ai-core

# Set the binary as the entry point execution command
CMD ["./infodemic-ai-core"]
