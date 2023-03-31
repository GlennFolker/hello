FROM --platform=linux/amd64 ubuntu:16.04

WORKDIR /hello
COPY . .

RUN apt search gcc i686
RUN apt search gcc i386
RUN apt search libgcc i686
RUN apt search libgcc i386

RUN apt-get update
RUN apt-get install -y \
    gcc libc6-dev-i386 libc6-dev-i386-cross \
    gcc-aarch64-linux-gnu \
    gcc-arm-linux-gnueabi \
    gcc-mingw-w64-x86-64 \
    gcc-mingw-w64-i686 \
    curl

RUN curl https://sh.rustup.rs -sSf | bash -s -- --default-toolchain nightly --profile minimal -y
ENV PATH="/root/.cargo/bin:${PATH}"

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
codegen-units = 1\n\
" > /root/.cargo/config

RUN rustup target add \
    x86_64-unknown-linux-gnu \
    i686-unknown-linux-gnu \
    aarch64-unknown-linux-gnu \
    armv7-unknown-linux-gnueabi \
    x86_64-pc-windows-gnu \
    i686-pc-windows-gnu

RUN cargo build --release \
    --target x86_64-unknown-linux-gnu \
    --target i686-unknown-linux-gnu \
    --target aarch64-unknown-linux-gnu \
    --target armv7-unknown-linux-gnueabi \
    --target x86_64-pc-windows-gnu \
    --target i686-pc-windows-gnu
