FROM ubuntu:14.04

WORKDIR /hello
COPY . .

RUN apt-get update
RUN apt-get install -y \
    gcc \
    curl

RUN curl https://sh.rustup.rs -sSf | bash -s -- --default-toolchain nightly --profile minimal -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN cargo build --release
