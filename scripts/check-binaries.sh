#!/usr/bin/env bash

function test_command() {
    RED="\033[01;31m"
    RESET="\033[0m"

    if ! command -v "${1}"; then
        echo -e "${RED}${1} not found!${RESET}"
        exit 1
    fi
}

BINARIES=( "clang" "ld.lld" "llvm-ar" "llvm-nm" )
for BINARY in "${BINARIES[@]}"; do
    test_command "${BINARY}-${LLVM_VERSION}"
done

QEMU_SUFFIXES=( "arm" "aarch64" "i386" "mips" "mipsel" "ppc" "ppc64" "x86_64" )
for QEMU_SUFFIX in "${QEMU_SUFFIXES[@]}"; do
    test_command "qemu-system-${QEMU_SUFFIX}"
done

BINUTILS_PREFIXES=( "" "aarch64-linux-gnu-" "arm-linux-gnueabi-" "mips-linux-gnu-"
                    "mipsel-linux-gnu-" "powerpc-linux-gnu-" "powerpc64-linux-gnu-"
                    "powerpc64le-linux-gnu-" "s390x-linux-gnu-" )
for BINUTILS_PREFIX in "${BINUTILS_PREFIXES[@]}"; do
    test_command "${BINUTILS_PREFIX}as"
done
