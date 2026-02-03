IMAGE := tenox7/openvms73
TAG := latest
PLATFORMS := linux/amd64,linux/arm64
BUILDER := openvms-builder

.PHONY: all build build-multiplatform push run clean setup-buildx compress

all: build

compress:
	@if [ ! -f vax.dsk.xz ]; then \
		echo "Compressing vax.dsk (1.7GB -> 63MB)..."; \
		xz -k vax.dsk; \
	else \
		echo "vax.dsk.xz already exists"; \
	fi

setup-buildx:
	@docker buildx create --name $(BUILDER) --use 2>/dev/null || docker buildx use $(BUILDER)

build: compress
	docker build -t $(IMAGE):$(TAG) .

build-multiplatform: compress setup-buildx
	docker buildx build \
		--platform $(PLATFORMS) \
		-t $(IMAGE):$(TAG) \
		--load \
		.

push: compress setup-buildx
	docker buildx build \
		--platform $(PLATFORMS) \
		-t $(IMAGE):$(TAG) \
		--push \
		.

clean:
	docker rmi $(IMAGE):$(TAG) 2>/dev/null || true
	docker buildx rm $(BUILDER) 2>/dev/null || true
