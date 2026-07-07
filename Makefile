IMAGE := tenox7/openvms73
TAG := latest
PLATFORMS := linux/amd64,linux/arm64
BUILDER := openvms-builder

.PHONY: all build build-multiplatform build-push push run clean setup-buildx

all: build

build:
	docker build -t $(IMAGE):$(TAG) .

build-push:
	docker buildx build \
		--platform $(PLATFORMS) \
		-t $(IMAGE):$(TAG) \
		--push \
		.

push:
	docker push $(IMAGE):$(TAG)

clean:
	docker rmi $(IMAGE):$(TAG) 2>/dev/null || true
