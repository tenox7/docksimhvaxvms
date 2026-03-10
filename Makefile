IMAGE := tenox7/openvms73
TAG := latest
PLATFORMS := linux/amd64,linux/arm64
BUILDER := openvms-builder

.PHONY: all build build-multiplatform push run clean setup-buildx

all: build

build:
	docker build -t $(IMAGE):$(TAG) .

push:
	docker buildx build \
		--platform $(PLATFORMS) \
		-t $(IMAGE):$(TAG) \
		--push \
		.

clean:
	docker rmi $(IMAGE):$(TAG) 2>/dev/null || true
