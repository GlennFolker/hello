FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y \
    build-essential \
    curl

RUN apt-get update

RUN curl https://sh.rustup.rs -sSf | bash -s -- --default-toolchain nightly --profile minimal -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /usr/src/hello
RUN ls .

RUN cargo build --release --target aarch64-unknown-linux-gnu
