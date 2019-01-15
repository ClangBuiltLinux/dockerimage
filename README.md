# ClangBuiltLinux Docker image

This repo holds the files for [the ClangBuiltLinux Docker organization](https://hub.docker.com/r/clangbuiltlinux/). This allows us to have a consistent environment for our continuous integration, as well as getting other developers involved. It is based on the latest Ubuntu image and includes the nightly builds of Clang and lld from apt.llvm.org and binutils/QEMU for arm, arm64, powerpc, and x86_64.

Currently, this image is available for x86_64 hosts on [Docker Hub](https://hub.docker.com/r/clangbuiltlinux/ubuntu/) (`docker run -ti clangbuiltlinux/ubuntu`), which is updated daily via a Travis cron.

We are thinking of ways to make this image available to other architectures. The biggest blocker is the nightly Clang builds are only for x86.

## Using this image for development

Once you have started running this image, you will have the full set of tools needed to build the upstream Linux kernel with Clang. There is a convenient function included to get a shallow clone of `torvalds/linux`, `linux-next`, and `linux-stable` called `clone_tree`. It can be examined in this repo or within the image under `/root/.bashrc`. If you want a script that will pull one of those trees, build a kernel, and boot it in QEMU, clone [our continuous-integration repo](https://github.com/ClangBuiltLinux/continuous-integration) and run `./driver.sh -h` to get some more information. If you have your own tree you would like to test, run `make CC=clang-8 HOSTCC=clang-8` in lieu of just `make` for all commands. You can bind mount your current kernel source into the Docker container by passing `--workdir /src --volume ${PWD}:/src` to `docker run` from within the source tree (see [Docker's documentation](https://docs.docker.com/engine/reference/run/#volume-shared-filesystems) for more info. Feel free to report any issues found in [our main Linux repo](https://github.com/ClangBuiltLinux/linux/issues)!

## Pushing a new image manually

Travis handles pushing images when new commits are added to the repo and daily via a cron. However, if the images need to be refreshed manually and you have been given access to push new images to Docker Hub, you can update the image by running `DOCKER_USERNAME=<your_username> DOCKER_PASSWORD=<your_password> make release deploy`.
