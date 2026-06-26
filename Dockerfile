FROM rust:1.78-slim
WORKDIR /app
# This skips copying a local src folder and just spins up a ready environment
CMD ["cargo", "run"]
