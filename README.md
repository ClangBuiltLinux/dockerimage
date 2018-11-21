# ClangBuiltLinux Docker image

This repo holds the files for [the ClangBuiltLinux Docker organization](https://hub.docker.com/r/clangbuiltlinux/). This allows us to have a consistent environment for our continuous integration, as well as getting other developers involved. It is based on Debian unstable and includes the nightly builds of Clang and lld from apt.llvm.org and binutils/QEMU for arm, arm64, powerpc, and x86_64.

Currently, this image is available for x86_64 hosts on [Docker Hub](https://hub.docker.com/r/clangbuiltlinux/debian/) (`docker run -ti clangbuiltlinux/debian`), which is updated daily via a Travis cron.

If you do not have an x86_64 system but would like to have access to this image, you can still clone this repo and build the image via `docker build -t clangbuiltlinux/debian .`.
