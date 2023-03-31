FROM --platform=linux/amd64 ubuntu:22.04

WORKDIR /hello
COPY . .

RUN apt-get update
RUN apt-get install -y curl

RUN curl https://sh.rustup.rs -sSf | bash -s -- --default-toolchain nightly --profile minimal -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN rustup update
RUN cat docker-cargo-config.toml > /root/.cargo/config

RUN apt-get install -y \
    gcc-mingw-w64-x86-64 \
    gcc-mingw-w64-i686

RUN rustup target add \
    x86_64-pc-windows-gnu \
    i686-pc-windows-gnu

RUN cargo build --release \
    --target x86_64-pc-windows-gnu \
    --target i686-pc-windows-gnu
