IMAGE := tenox7/openvms73
TAG := latest
PLATFORMS := linux/amd64,linux/arm64
BUILDER := openvms-builder

.PHONY: all build build-multiplatform build-push data push run clean setup-buildx

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

data:
	rm -f vax.dsk.xz
	mv data/vax.dsk .
	xz -9vv vax.dsk

clean:
	docker rmi $(IMAGE):$(TAG) 2>/dev/null || true
