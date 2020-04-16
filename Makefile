DATE ?= $(shell date +%Y%m%d)
DOCKER ?= docker
LLVM_VERSION ?= 11
LATEST_TAG := llvm$(LLVM_VERSION)-latest
REPO ?= clangbuiltlinux/ubuntu

TAG_FLAGS := -t $(REPO):$(LATEST_TAG)
ifeq ($(LLVM_VERSION),11)
TAG_FLAGS := $(TAG_FLAGS) -t $(REPO):latest
endif

image:
	@$(DOCKER) build $(TAG_FLAGS) --build-arg LLVM_VERSION=$(LLVM_VERSION) .

release:
	@$(DOCKER) build -t $(REPO):llvm$(LLVM_VERSION)-$(DATE) $(TAG_FLAGS) --build-arg LLVM_VERSION=$(LLVM_VERSION) .

check:
	$(DOCKER) run --rm -ti --env LLVM_VERSION=$(LLVM_VERSION) --mount type=bind,source=$(shell pwd),target=/dockerimage $(REPO):$(LATEST_TAG) bash /dockerimage/scripts/check-binaries.sh

deploy:
	@REPO=$(REPO) DATE=$(DATE) LLVM_VERSION=$(LLVM_VERSION) bash scripts/deploy.sh

help:
	@echo
	@echo "Possible targets:"
	@echo "    image:       Builds the image, tagged as the latest."
	@echo "    release:     Build the image, tagged as the latest and by date."
	@echo "    check:       Checks that clang, lld, and all of the QEMU binaries are available to use within the container."
	@echo "    deploy:      Pushes the image to Docker Hub (release should be run when deploying)."
	@echo "                 DOCKER_USERNAME and DOCKER_PASSWORD should be exported with the appropriate values when running this target."
	@echo
