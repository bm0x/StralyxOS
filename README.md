# StralyxOS — minimal, modular Linux distribution

StralyxOS is a small distro project that focuses on portability, reproducible image builds, and flexible install targets (desktop and mobile). The repository contains architecture-specific artifacts, package lists, installer tooling and utilities to create testable disk images.

This README is intentionally concise and focuses on the project's structure and high-level workflows. Operational and developer-facing scripts live in `scripts/` (including a UX wrapper called "Simetrio"); consult `scripts/README-simetrio.md` for details about the interactive CLI/TUI.

Key goals
---------
- Multi-architecture support: produce images for x86_64 and arm64 platforms with appropriate boot mechanisms (GRUB on x86_64, U-Boot on arm64).
- Reproducible rootfs: use debootstrap (Debian) for deterministic base root filesystems and layered package lists for core/extra packages.
- Safe, opt-in desktop builds: desktop images (KDE Plasma) are optional and explicitly requested through build flags.
- Browser-based testing: support running images under QEMU and exposing the VM using noVNC for remote browser access.

Repository layout (high level)
-----------------------------
- `arch/`
   - `x86_64/` — kernels, GRUB bits and systemd units for x86_64 targets.
   - `arm64/` — kernel, U-Boot images and systemd units primarily for mobile/arm64 targets.

- `packages/`
   - `core/` and `extra/` lists define package sets used by rootfs builders.

- `rootfs/`
   - `minimal/` and `desktop/` skeletons used when assembling images.

- `installer/`
   - UEFI and mobile installer scripts and helpers.

- `configs/`
   - Files such as `fstab`, `hostname` and other configuration snippets used by builders.

- `tooling/`
   - Utilities and third-party tools used for packaging, chroot management, noVNC, and tests. Contains a vendored noVNC tree used for the browser VNC proxy.

- `tests/`
   - QEMU smoke tests and scripts used for CI or local validation of generated images.

High-level workflows
--------------------
1. Create a root filesystem
    - Debian-based rootfs is produced using `debootstrap` (see `scripts/build-rootfs-debian.sh`). The rootfs is constructed from package lists (core + optional extras).

2. Produce a bootable disk image
    - The build process creates a partition table, formats partitions, copies the rootfs into the image and installs a bootloader (GRUB for x86_64 or U-Boot for arm64). On macOS the image build is run inside a Multipass VM to avoid host-mount restrictions.

3. Test via QEMU + noVNC
    - Images can be booted in QEMU. The repository includes tooling to start QEMU and proxy VNC to the browser using noVNC for user-friendly testing.

4. Install on target hardware
    - Installer scripts and UEFI/mobile helpers prepare media for installation; follow the `installer/` documentation for target-specific instructions.

Common commands
---------------
These are the top-level tasks most contributors will use. (The `scripts/` directory contains the orchestration wrappers.)

Build minimal rootfs (example):

```bash
./scripts/build-rootfs-debian.sh --suite bookworm --arch amd64 --rootfs build/rootfs-minimal
```

Create a bootable image (example):

```bash
./scripts/multipass-run.sh --name stralyx --mem 4G --cpus 2 --disk 20G --with-kde
```

Run QEMU with the created image (example):

```bash
qemu-system-x86_64 -m 2048 -drive file=build/output/stralyx.img,format=raw -enable-kvm -net nic -net user
```

Testing and CI
--------------
- The `tests/qemu` directory contains smoke tests that boot images in QEMU and perform basic checks. These are a good starting point for automated verification in CI.
- When running tests in macOS CI agents, prefer Multipass-based builders to avoid filesystem limitations that affect `debootstrap`.

Troubleshooting highlights
-------------------------
- debootstrap failures (mknod / Operation not permitted): typically caused by debootstrap running into a host-mounted directory that enforces `nodev`/`noexec` (common on macOS). Use the Multipass VM flow to perform debootstrap inside the guest.
- Image not booting: verify that GRUB or U-Boot was installed into the target image's loop device. The logs from the partitioning and `grub-install` step are the first place to check.
- noVNC / browser problems: ensure the websockify proxy is running and the QEMU VNC server is listening on the expected display (usually :1 / port 5901). The noVNC `index.html` is served from `tooling/novnc/`.

Contributing
------------
- Keep system-level steps in the bash scripts; the Python CLI/TUI is for orchestration and UX only.
- If you add features that change image layout or boot behavior, add a test under `tests/qemu` that boots the image and validates the change.

Further reading
---------------
- `docs/design.md` — design rationale and architecture notes.
- `tooling/novnc/docs/` — noVNC embedding and proxy documentation.

License
-------
Check the top-level LICENSE for project licensing.

Badges (optional)
-----------------
You may want to add status and license badges to the top of this README. Don't add live URLs here unless you have the services configured. Example (copy/paste and replace the target URLs):

```markdown
![CI](https://img.shields.io/badge/ci-pending-lightgrey)
![License](https://img.shields.io/badge/license-MIT-blue)
```

Quickstart (three commands)
---------------------------
If you just want to try the most common flow locally (build rootfs, create image, run noVNC), the `Makefile` provides a tiny quickset of targets. From the repository root:

```bash
# 1) Run preflight checks and build a minimal rootfs
make build-rootfs

# 2) Create a bootable image (example multipass flow)
make image

# 3) Serve the image via noVNC (opens a browser-accessible VNC)
make novnc

# Stop the noVNC run
make stop

# Clean build artifacts (use with caution)
make clean
```

Notes
-----
- The `Makefile` targets are convenience wrappers around the repository's `scripts/` helpers. They are intentionally thin — the real logic remains in the scripts so you can run them directly when you need to tune flags or debug.
- On macOS the image build uses Multipass internally. If you need to reproduce or debug lower-level steps, inspect `scripts/multipass-run.sh` and `scripts/build-rootfs-debian.sh`.
