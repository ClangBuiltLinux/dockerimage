DATE ?= $(shell date +%Y%m%d)
DOCKER ?= docker
REPO ?= clangbuiltlinux/ubuntu

image:
	@$(DOCKER) build -t $(REPO):latest .

release:
	@$(DOCKER) build -t $(REPO):$(DATE) -t $(REPO):latest .

check:
	$(DOCKER) run --rm -ti $(REPO):latest clang-9 --version
	@echo
	$(DOCKER) run --rm -ti $(REPO):latest ld.lld-9 --version
	@echo
	$(DOCKER) run --rm -ti $(REPO):latest qemu-system-arm --version
	@echo
	$(DOCKER) run --rm -ti $(REPO):latest qemu-system-aarch64 --version
	@echo
	$(DOCKER) run --rm -ti $(REPO):latest qemu-system-x86_64 --version
	@echo
	$(DOCKER) run --rm -ti $(REPO):latest qemu-system-ppc --version

deploy:
	@REPO=$(REPO) DATE=$(DATE) bash deploy.sh

help:
	@echo
	@echo "Possible targets:"
	@echo "    image:       Builds the image, tagged as the latest."
	@echo "    release:     Build the image, tagged as the latest and by date."
	@echo "    check:       Checks that clang, lld, and all of the QEMU binaries are available to use within the container."
	@echo "    deploy:      Pushes the image to Docker Hub (release should be run when deploying)."
	@echo "                 DOCKER_USERNAME and DOCKER_PASSWORD should be exported with the appropriate values when running this target."
	@echo
