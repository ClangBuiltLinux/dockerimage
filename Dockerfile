# Use the latest slim Debian testing image as the base
FROM debian:testing-slim

# Default to the development branch of LLVM (currently 9)
# User can override this to a stable branch (like 7 or 8)
ARG LLVM_VERSION=9

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
# Delete all the apt list files since they're big and get stale quickly
RUN curl https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    echo "deb http://apt.llvm.org/buster/ llvm-toolchain-buster$(test ${LLVM_VERSION} -ne 9 && echo "-${LLVM_VERSION}") main" | tee -a /etc/apt/sources.list && \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        clang-${LLVM_VERSION} \
        lld-${LLVM_VERSION} \
        llvm-${LLVM_VERSION} && \
    chmod -f +x /usr/lib/llvm-${LLVM_VERSION}/bin/* && \
    rm -rf /var/lib/apt/lists/*

# Check and see Clang has not been rebuilt in more than five days if we are on the master branch and fail the build if so
# We copy, execute, then remove because it is not necessary to carry this script in the image once it's built
COPY clang-check.sh /
RUN bash /clang-check.sh && \
    rm /clang-check.sh

# Add a function to easily clone torvalds/linux, linux-next, and linux-stable
COPY clone_tree /root
RUN cat /root/clone_tree >> /root/.bashrc && \
    rm /root/clone_tree
