FROM --platform=linux/arm64 ubuntu:14.04

RUN apt-get update
RUN apt-get install -y \
    build-essential \
    curl

RUN apt-get update

RUN curl https://sh.rustup.rs -sSf | bash -s -- --default-toolchain nightly --profile minimal -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN ls /
RUN ls ~
RUN ls ~/hello
RUN cargo build --release --target aarch64-unknown-linux-gnu
