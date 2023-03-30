FROM --platform=linux/amd64 ubuntu:14.04

WORKDIR /hello
COPY . .

RUN apt-get update
RUN apt-get install -y \
    gcc \
    gcc-aarch64-linux-gnu \
    gcc-mingw-w64-x86-64 \
    curl

RUN curl https://sh.rustup.rs -sSf | bash -s -- --default-toolchain nightly --profile minimal -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN echo " \
[target.x86_64-unknown-linux-gnu] \
linker = "gcc" \
[target.aarch64-unknown-linux-gnu] \
linker = "aarch64-linux-gnu-gcc" \
[target.x86_64-pc-windows-gnu] \
linker = "x86_64-w64-mingw32-gcc" \
[profile.release] \
lto = on \
codegen-units = 1 \
" > /root/.cargo/config

RUN rustup target add \
    aarch64-unknown-linux-gnu \
    x86_64-pc-windows-gnu

RUN cargo build --release \
    --target x86_64-unknown-linux-gnu \
    --target aarch64-unknown-linux-gnu \
    --target x86_64-pc-windows-gnu
