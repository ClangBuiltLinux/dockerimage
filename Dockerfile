# Use the latest Ubuntu image as the base
FROM ubuntu:rolling

# Make sure that all packages are up to date then
# install the base Ubuntu packages that we need for
# building the kernel
RUN apt-get update -qq && \
    apt-get upgrade -y && \
    ln -snf /usr/share/zoneinfo/UTC /etc/localtime && echo "UTC" > /etc/timezone && \
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
        xz-utils

# Install the latest nightly Clang/lld packages from apt.llvm.org and QEMU packages from Joel Stanley's PPA
RUN curl https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    echo "deb http://apt.llvm.org/cosmic/ llvm-toolchain-cosmic main" | tee -a /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E007EC6A && \
    echo "deb http://ppa.launchpad.net/shenki/ppa/ubuntu cosmic main" | tee -a /etc/apt/sources.list && \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        clang-8 \
        lld-8 \
        llvm-8 \
        skiboot \
        qemu-system-arm \
        qemu-system-ppc \
        qemu-system-x86

# Add a function to easily clone torvalds/linux, linux-next, and linux-stable
COPY clone_tree /root
RUN cat /root/clone_tree >> /root/.bashrc && \
    rm /root/clone_tree
