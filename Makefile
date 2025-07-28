DOCKER_TAG ?= ubuntu2404
PACKAGE_NAME ?=
IN_DOCKER ?= 1

.PHONY: all
all:
	echo ""


.PHONY: build-docker-ubuntu2204
build-docker-ubuntu2204:
	docker build -t deb-downloader:ubuntu2204 -f ./docker/Dockerfile.ubuntu2204 ./docker

.PHONY: build-docker-ubuntu2404
build-docker-ubuntu2404:
	docker build -t deb-downloader:ubuntu2404 -f ./docker/Dockerfile.ubuntu2404 ./docker

.PHONY: run
run:
	docker run --rm -it -v $(shell pwd):/app deb-downloader:$(DOCKER_TAG) bash

.PHONY: download
download:
ifeq ($(IN_DOCKER), 1)
	docker run --rm -it -v $(shell pwd):/app deb-downloader:$(DOCKER_TAG) python3 main.py download $(PACKAGE_NAME)
else
	python3 main.py download $(PACKAGE_NAME)
endif

.PHONY: unpack
unpack:
ifeq ($(IN_DOCKER), 1)
	docker run --rm -it -v $(shell pwd):/app deb-downloader:$(DOCKER_TAG) python3 main.py unpack
else
	python3 main.py unpack
endif

.PHONY: clean
clean:
	sudo rm -rf ./output