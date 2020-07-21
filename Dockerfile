# Use the latest Ubuntu Focal (20.04 LTS) image as the base
FROM ubuntu:focal

# Default to the development branch of LLVM (currently 12)
# User can override this to a stable branch (like 10 or 11)
ARG LLVM_VERSION=12

# Make sure that all packages are up to date then
# install the base Ubuntu packages that we need for
# building the kernel
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        bc \
        binutils \
        binutils-aarch64-linux-gnu \
        binutils-arm-linux-gnueabi \
        binutils-mips-linux-gnu \
        binutils-mipsel-linux-gnu \
        binutils-powerpc-linux-gnu \
        binutils-powerpc64-linux-gnu \
        binutils-powerpc64le-linux-gnu \
        binutils-riscv64-linux-gnu \
        binutils-s390x-linux-gnu \
        bison \
        ca-certificates \
        ccache \
        cpio \
        curl \
        expect \
        flex \
        git \
        gnupg \
        libelf-dev \
        libssl-dev \
        lz4 \
        make \
        opensbi \
        openssl \
        ovmf \
        qemu-efi-aarch64 \
        qemu-system-arm \
        qemu-system-mips \
        qemu-system-misc \
        qemu-system-ppc \
        qemu-system-x86 \
        u-boot-tools \
        xz-utils \
        zstd && \
    rm -rf /var/lib/apt/lists/*

# Install the latest nightly Clang/lld packages from apt.llvm.org
# Delete all the apt list files since they're big and get stale quickly
RUN curl https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal$(test ${LLVM_VERSION} -ne 12 && echo "-${LLVM_VERSION}") main" | tee -a /etc/apt/sources.list && \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        clang-${LLVM_VERSION} \
        lld-${LLVM_VERSION} \
        llvm-${LLVM_VERSION} && \
    chmod -f +x /usr/lib/llvm-${LLVM_VERSION}/bin/* && \
    rm -rf /var/lib/apt/lists/*

# Check and see Clang has not been rebuilt in more than five days if we are on the master branch and fail the build if so
# We copy, execute, then remove because it is not necessary to carry this script in the image once it's built
COPY scripts/check-clang.sh /
RUN bash /check-clang.sh && \
    rm /check-clang.sh

# Add a function to easily clone torvalds/linux, linux-next, and linux-stable
COPY env/clone_tree /root
RUN cat /root/clone_tree >> /root/.bashrc && \
    rm /root/clone_tree
