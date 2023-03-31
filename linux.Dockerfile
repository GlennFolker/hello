FROM --platform=linux/amd64 ubuntu:16.04

WORKDIR /hello
COPY . .

RUN apt-get update
RUN apt-get install -y curl

RUN curl https://sh.rustup.rs -sSf | bash -s -- --default-toolchain nightly --profile minimal -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN rustup update
RUN cat docker-cargo-config.toml > /root/.cargo/config

RUN apt-get install -y gcc-multilib
RUN rustup target add \
    x86_64-unknown-linux-gnu \
    i686-unknown-linux-gnu

RUN cargo build --release \
    --target x86_64-unknown-linux-gnu \
    --target i686-unknown-linux-gnu

RUN apt-get autoremove -y gcc-multilib
RUN apt-get install -y \
    gcc-aarch64-linux-gnu \
    gcc-arm-linux-gnueabi

RUN rustup target add \
    aarch64-unknown-linux-gnu \
    armv7-unknown-linux-gnueabi

RUN cargo build --release \
    --target aarch64-unknown-linux-gnu \
    --target armv7-unknown-linux-gnueabi
