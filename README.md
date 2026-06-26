FROM rust:1.75-slim as builder
WORKDIR /usr/src/gitlawb
COPY . .
RUN cargo build --release

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/src/gitlawb/target/release/gitlawb-node /usr/local/bin/gitlawb-node
CMD ["gitlawb-node"]
