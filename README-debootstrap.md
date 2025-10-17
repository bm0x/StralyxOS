README: Debian rootfs helper (debootstrap)
========================================

Purpose
-------
This repository adds a non-intrusive helper script `scripts/build-rootfs-debian.sh` to
produce a Debian-based root filesystem using `debootstrap`. It's designed to coexist with
the existing build scripts and not overwrite any files owned by the team's main flow.

Key features
------------
- Creates a Debian rootfs for `amd64` or `arm64` (default: bookworm/amd64).
- Installs a kernel package (default: `linux-image-6.1`) to provide an LTS kernel by default.
- Optional KDE Plasma install (installs `task-kde-desktop` and `sddm`) and drops minimal
  default user settings into `/etc/skel` to keep consistent UX/UI for new users.
- Refuses to overwrite an existing rootfs directory to avoid accidental data loss.
- Dry-run support for safe experimentation.

Quick start
-----------
1. Ensure required host packages are installed:

```bash
sudo apt update
sudo apt install -y debootstrap qemu-user-static
```

2. Run a simple dry-run to see configuration:

```bash
./scripts/build-rootfs-debian.sh --dry-run
```

3. Create a Debian rootfs with LTS kernel (default):

```bash
./scripts/build-rootfs-debian.sh --arch amd64 --suite bookworm
```

4. Create a Debian desktop rootfs with KDE Plasma:

```bash
./scripts/build-rootfs-debian.sh --arch amd64 --suite bookworm --with-kde
```

Kernel versions and changing behavior
------------------------------------
- The script installs the package named with `--kernel`. By default that's `linux-image-6.1`.
- If you prefer a different LTS (for example 5.15 or a newer 6.x), pass `--kernel linux-image-5.15`
  (or the package name available in your chosen suite/mirror).
- You may also choose to build and include a custom kernel image; in that case produce a .deb
  and install it inside the chroot or copy the kernel into `arch/<arch>/kernel` and use
  the existing image-building flow.

Testing and CI guidance
-----------------------
- This script is intentionally non-invasive. To integrate with CI or developer workflows:
  - Create a feature branch and a PR containing the new script and README.
  - Use the `--rootfs` option to write outputs to a temporary CI workspace.
  - Add a small QEMU smoke test (see `tests/qemu`) that boots the rootfs image and runs
    a simple `systemctl --version` or `uname -a` check.

Safety notes
------------
- The script will not overwrite an existing directory. This prevents accidental deletion of
  team artifacts. Remove the directory explicitly if you know what you're doing.
- It requires `debootstrap` and (for cross-architecture second-stage) `qemu-user-static`.

Next steps I can take for you
----------------------------
- Update `packages/core/package-list.yaml` to reference an LTS kernel package (e.g. 6.1)
- Add a small QEMU test that boots the generated rootfs and checks KDE/SDDM installation
- Integrate the script into `scripts/build-rootfs.sh` behind a flag to keep backwards compatibility
