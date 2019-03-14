# Use the latest slim Debian testing image as the base
FROM debian:testing-slim

# Make sure that all packages are up to date then
# install the base Debian packages that we need for
# building the kernel
RUN apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
        bc \
        binutils \
        binutils-aarch64-linux-gnu \
        binutils-arm-linux-gnueabi \
        binutils-powerpc-linux-gnu \
        binutils-powerpc64-linux-gnu \
        binutils-powerpc64le-linux-gnu \
        bison \
        ca-certificates \
        ccache \
        curl \
        expect \
        flex \
        git \
        gnupg \
        libelf-dev \
        libssl-dev \
        make \
        openssl \
        qemu-skiboot \
        qemu-system-arm \
        qemu-system-ppc \
        qemu-system-x86 \
        u-boot-tools \
        xz-utils

# Install the latest nightly Clang/lld packages from apt.llvm.org
RUN curl https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    echo "deb http://apt.llvm.org/unstable/ llvm-toolchain main" | tee -a /etc/apt/sources.list && \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        clang-9 \
        lld-9 \
        llvm-9 && \
    chmod -f +x /usr/lib/llvm-9/bin/*

# Add a function to easily clone torvalds/linux, linux-next, and linux-stable
COPY clone_tree /root
RUN cat /root/clone_tree >> /root/.bashrc && \
    rm /root/clone_tree
