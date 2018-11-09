# Use the latest Debian stable image as the base
FROM debian:stretch

# Make sure that all packages are up to date then
# install the base Debian packages that we need for
# building the kernel and QEMU
RUN apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get install -y \
        bc \
        binutils \
        binutils-aarch64-linux-gnu \
        binutils-arm-linux-gnueabi \
        binutils-powerpc64le-linux-gnu \
        bison \
        ccache \
        curl \
        expect \
        flex \
        git \
        gnupg \
        libglib2.0-dev \
        libpixman-1-dev \
        libssl-dev \
        make \
        pkg-config \
        python \
        openssl \
        qemu-system-arm \
        qemu-system-x86 \
        xz-utils

# Install the latest nightly Clang/lld packages from apt.llvm.org
RUN curl https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch main" | tee -a /etc/apt/sources.list && \
    apt-get update -qq && \
    apt-get install -y \
        clang-8 \
        lld-8

# Build and install QEMU 3.0 from source
RUN curl https://download.qemu.org/qemu-3.0.0.tar.xz | tar -C /root -xJf - && \
    cd /root/qemu-3.0.0 && \
    ./configure --target-list="aarch64-softmmu arm-softmmu i386-softmmu x86_64-softmmu ppc-softmmu ppc64-softmmu" && \
    make -j"$(nproc)" install && \
    rm -rf /root/qemu
