FROM rust:latest as builder
WORKDIR /usr/src/app

# 1. Copy your manifests first
COPY Cargo.toml Cargo.lock ./

# 2. Copy your actual source code
COPY src ./src

# 3. Build for release
RUN cargo build --release --locked
