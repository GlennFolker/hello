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

RUN echo -e " \n\
[target.x86_64-unknown-linux-gnu] \n\
linker = "gcc" \n\
[target.aarch64-unknown-linux-gnu] \n\
linker = "aarch64-linux-gnu-gcc" \n\
[target.x86_64-pc-windows-gnu] \n\
linker = "x86_64-w64-mingw32-gcc" \n\
[profile.release] \n\
lto = on \n\
codegen-units = 1 \n\
" > /root/.cargo/config

RUN rustup target add \
    aarch64-unknown-linux-gnu \
    x86_64-pc-windows-gnu

RUN cargo build --release \
    --target x86_64-unknown-linux-gnu \
    --target aarch64-unknown-linux-gnu \
    --target x86_64-pc-windows-gnu
