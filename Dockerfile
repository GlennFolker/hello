FROM --platform=linux/amd64 ubuntu:16.04

WORKDIR /hello
COPY . .

RUN apt-get update
RUN apt-get install -y curl

RUN curl https://sh.rustup.rs -sSf | bash -s -- --default-toolchain nightly --profile minimal -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN rustup update

RUN printf "\n\
[target.x86_64-unknown-linux-gnu]\n\
linker = \"gcc\"\n\
[target.i686-unknown-linux-gnu]\n\
linker = \"gcc\"\n\
[target.aarch64-unknown-linux-gnu]\n\
linker = \"aarch64-linux-gnu-gcc\"\n\
[target.armv7-unknown-linux-gnueabi]\n\
linker = \"arm-linux-gnueabi-gcc\"\n\
[target.x86_64-pc-windows-gnu]\n\
linker = \"x86_64-w64-mingw32-gcc\"\n\
[target.i686-pc-windows-gnu]\n\
linker = \"i686-w64-mingw32-gcc\"\n\
[profile.release]\n\
lto = \"on\"\n\
panic = \"abort\"\n\
codegen-units = 1\n\
" > /root/.cargo/config

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
    gcc-arm-linux-gnueabi \
    gcc-mingw-w64-x86-64 \
    gcc-mingw-w64-i686

RUN rustup target add \
    aarch64-unknown-linux-gnu \
    armv7-unknown-linux-gnueabi \
    x86_64-pc-windows-gnu \
    i686-pc-windows-gnu

RUN cargo build --release \
    --target aarch64-unknown-linux-gnu \
    --target armv7-unknown-linux-gnueabi \
    --target x86_64-pc-windows-gnu \
    --target i686-pc-windows-gnu
