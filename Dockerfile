FROM ubuntu:14.04

COPY ./ ./

RUN curl https://sh.rustup.rs -sSf | bash -s -- --default-toolchain nightly --profile minimal -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN cargo build --release
