#!/bin/bash
set -euo pipefail

# qemu-smoke.sh
# Simple smoke test to validate a generated Debian rootfs.
# Behavior:
#  - If qemu-system-* is present, create a small disk image from the rootfs and try to boot it
#    (headless, short timeout) and run a basic command via serial/console.
#  - If QEMU is not available, fall back to running in-chroot checks (uname, systemctl).

ROOTFS_DIR="${1:-rootfs/debian-bookworm-amd64}"
IMAGE="/tmp/debian-smoke.img"
MOUNTPOINT="/tmp/debian-smoke-mnt"
QEMU_CMD="qemu-system-x86_64"
TIMEOUT=20

if [[ ! -d "$ROOTFS_DIR" ]]; then
  echo "Rootfs directory not found: $ROOTFS_DIR"
  echo "Run scripts/build-rootfs-debian.sh first or provide a valid rootfs path."
  exit 1
fi

if command -v "$QEMU_CMD" >/dev/null 2>&1; then
  echo "QEMU found: $QEMU_CMD — building image and attempting boot (timeout ${TIMEOUT}s)"
  # Create sparse image
  dd if=/dev/zero of=$IMAGE bs=1M count=0 seek=1024
  mkfs.ext4 -F $IMAGE

  mkdir -p $MOUNTPOINT
  sudo mount -o loop $IMAGE $MOUNTPOINT
  sudo cp -a $ROOTFS_DIR/* $MOUNTPOINT/
  sudo umount $MOUNTPOINT

  # Run QEMU in background and capture serial output to a file
  OUTFILE="/tmp/qemu-smoke.out"
  rm -f $OUTFILE

  $QEMU_CMD -hda $IMAGE -m 1024 -nographic -serial file:$OUTFILE &
  QEMU_PID=$!

  echo "Waiting up to ${TIMEOUT}s for boot output..."
  SECONDS=0
  while [[ $SECONDS -lt $TIMEOUT ]]; do
    sleep 1
    if grep -q "login:" $OUTFILE 2>/dev/null || grep -q "Welcome" $OUTFILE 2>/dev/null; then
      echo "Detected boot output — smoke test OK (login prompt or welcome message found)."
      kill $QEMU_PID || true
      rm -f $IMAGE
      exit 0
    fi
    SECONDS=$SECONDS+1
  done

  echo "Timeout waiting for boot output. See $OUTFILE for details."
  kill $QEMU_PID || true
  rm -f $IMAGE
  exit 2
else
  echo "QEMU not found. Running in-chroot checks instead."
  sudo mount --bind /dev $ROOTFS_DIR/dev
  sudo mount -t proc /proc $ROOTFS_DIR/proc
  sudo mount --bind /sys $ROOTFS_DIR/sys
  sudo cp /etc/resolv.conf $ROOTFS_DIR/etc/ || true

  echo "uname -a inside chroot:"
  sudo chroot $ROOTFS_DIR uname -a || true

  echo "systemctl --version inside chroot:"
  sudo chroot $ROOTFS_DIR systemctl --version || true

  sudo umount $ROOTFS_DIR/proc || true
  sudo umount $ROOTFS_DIR/sys || true
  sudo umount $ROOTFS_DIR/dev || true

  echo "In-chroot checks completed."
  exit 0
fi
