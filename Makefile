IMAGE := tenox7/openvms73
TAG := latest
PLATFORMS := linux/amd64,linux/arm64
BUILDER := openvms-builder

.PHONY: all build build-multiplatform build-push data data-release push run clean setup-buildx

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

# upload new disk image version, e.g.: make data-release V=15
data-release:
	gh release create disk-v$(V) vax.dsk.xz --latest --title "vax.dsk.xz v$(V)" --notes "vax.dsk.xz disk image v$(V)"

clean:
	docker rmi $(IMAGE):$(TAG) 2>/dev/null || true
