# ClangBuiltLinux Docker image

This repo holds the files for [the ClangBuiltLinux Docker organization](https://hub.docker.com/r/clangbuiltlinux/). This allows us to have a consistent environment for our continuous integration, as well as getting other developers involved. It is based on the latest Ubuntu image and includes the nightly builds of Clang and lld from apt.llvm.org and binutils/QEMU for arm, arm64, powerpc, and x86_64.

Currently, this image is available for x86_64 hosts on [Docker Hub](https://hub.docker.com/r/clangbuiltlinux/ubuntu/) (`docker run -ti clangbuiltlinux/ubuntu`), which is updated daily via a Travis cron.

We are thinking of ways to make this image available to other architectures. The biggest blocker is the nightly Clang builds are only for x86.

## Using this image for development

Once you have started running this image, you will have the full set of tools needed to build the upstream Linux kernel with Clang. There are a couple of different ways to use this container:

* If you are a beginner and want to see how a build with Clang goes, we have a script that will pull a mainline tree, build a kernel image, and boot it in QEMU. To use it, clone [our continuous-integration repo](https://github.com/ClangBuiltLinux/continuous-integration) and run `./driver.sh -h` to get some more information.

* If you are more experienced but don't have a local tree to use, there is a convenient function included to get a shallow clone of `torvalds/linux`, `linux-next`, and `linux-stable` called `clone_tree`. It can be examined in this repo or within the image under `/root/.bashrc`. To build with Clang, you can run `make CC=clang-8 HOSTCC=clang-8` in lieu of `make` alone.

* If you are an experienced developer and have your own tree you would like to test, you can bind mount your current kernel source into the Docker container by passing `--mount type=bind,source="${PWD}",target=/"$(basename "${PWD}")" --workdir /"$(basename "${PWD}")"` to the `docker run` command above from within the source tree ([example](https://github.com/nathanchance/scripts/blob/82ac3b27f635/snippets/cbl#L344-L349)), To build with Clang, you can run `make CC=clang-8 HOSTCC=clang-8` in lieu of `make` alone. If you want to keep all your work in the container, you can add `,readonly` to the `--mount` flag and pass `O=/out` to all `make` invocations. See [Docker's documentation](https://docs.docker.com/storage/bind-mounts/) for more info.

Feel free to report any issues found in [our main Linux repo](https://github.com/ClangBuiltLinux/linux/issues)!

## Pushing a new image manually

Travis handles pushing images when new commits are added to the repo and daily via a cron. However, if the images need to be refreshed manually and you have been given access to push new images to Docker Hub, you can update the image by running `DOCKER_USERNAME=<your_username> DOCKER_PASSWORD=<your_password> make release deploy`.
