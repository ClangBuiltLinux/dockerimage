# Use the latest Debian stable image as the base
FROM debian:stretch

# Make sure that all packages are up to date
RUN apt-get update -qq
RUN apt-get upgrade -y

# Install the base Debian packages that we need
RUN apt-get install -y \
        bc \
        binutils \
        binutils-aarch64-linux-gnu \
        binutils-arm-linux-gnueabi \
        bison \
        ccache \
        curl \
        expect \
        flex \
        git \
        gnupg \
        libssl-dev \
        make \
        openssl \
        qemu-system-arm \
        qemu-system-x86

# Install the latest nightly Clang/lld packages from apt.llvm.org
RUN curl https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch main" | tee -a /etc/apt/sources.list
RUN apt-get update -qq
RUN apt-get install -y \
        clang-8 \
        lld-8

# Install packages that are required for QEMU
RUN apt-get install -y \
        libglib2.0-dev \
        libpixman-1-dev \
        pkg-config \
        python

# Build and install QEMU 3.0 from source
RUN git clone https://git.qemu.org/git/qemu.git /root/qemu
WORKDIR /root/qemu
RUN git submodule update --init --recursive
RUN ./configure --target-list="aarch64-softmmu arm-softmmu i386-softmmu x86_64-softmmu ppc-softmmu ppc64-softmmu"
RUN make -j"$(nproc)" install
WORKDIR /
RUN rm -rf /root/qemu
