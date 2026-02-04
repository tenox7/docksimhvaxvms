IMAGE := tenox7/openvms73
TAG := latest
PLATFORMS := linux/amd64,linux/arm64
BUILDER := openvms-builder

.PHONY: all build build-multiplatform push run clean setup-buildx compress

all: build

compress:
	@if [ ! -f vax.dsk.xz ]; then \
		echo "Compressing vax.dsk..."; \
		xz -k vax.dsk; \
	else \
		echo "vax.dsk.xz already exists"; \
	fi

build: compress
	docker build -t $(IMAGE):$(TAG) .

push: compress
	docker buildx build \
		--platform $(PLATFORMS) \
		-t $(IMAGE):$(TAG) \
		--push \
		.

clean:
	docker rmi $(IMAGE):$(TAG) 2>/dev/null || true
