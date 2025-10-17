SHELL := /bin/bash

# Minimal Makefile quickstart for common tasks. This is intentionally tiny and
# delegates to the repository scripts to avoid duplicating logic.

.PHONY: quickstart check build-rootfs build-image image novnc stop clean help

help:
	@echo "Makefile quick targets for StralyxOS"
	@echo "  make quickstart   # run the full quickstart (check -> build -> image)"
	@echo "  make check        # run preflight checks"
	@echo "  make build-rootfs # build a minimal rootfs"
	@echo "  make image        # create a bootable image (multipass flow)"
	@echo "  make novnc        # run noVNC against an image"
	@echo "  make stop         # stop running noVNC/qemu"
	@echo "  make clean        # remove build artifacts (use with caution)"

check:
	@echo "Running preflight checks..."
	@./scripts/simetrio check || true

build-rootfs:
	@echo "Building minimal rootfs (example)..."
	@./scripts/build-rootfs-debian.sh --suite bookworm --arch amd64 --rootfs build/rootfs-minimal

image: build-rootfs
	@echo "Creating bootable image via Multipass flow (example)..."
	@./scripts/multipass-run.sh --name stralyx --mem 4G --cpus 2 --disk 20G

novnc:
	@echo "Start noVNC for testing (provide path to image if needed)"
	@./scripts/simetrio novnc build/Stralyx/output/debian-smoke.img || true

stop:
	@echo "Stop noVNC/QEMU if running"
	@./scripts/simetrio stop || true

clean:
	@echo "Clean build artifacts (non-destructive unless scripts do more)"
	@./scripts/simetrio clean --yes || true

quickstart: check build-rootfs image
