#!/bin/bash

# This script automates the installation process for UEFI systems.

set -e

# Define variables
ROOTFS_DIR="./rootfs/minimal"
TARGET_DEVICE="/dev/sdX"  # Replace with the actual target device
EFI_PARTITION="${TARGET_DEVICE}1"
ROOT_PARTITION="${TARGET_DEVICE}2"

# Function to create partitions
create_partitions() {
    echo "Creating partitions on ${TARGET_DEVICE}..."
    parted ${TARGET_DEVICE} mklabel gpt
    parted -a optimal ${TARGET_DEVICE} mkpart primary fat32 1MiB 512MiB
    parted -a optimal ${TARGET_DEVICE} mkpart primary ext4 512MiB 100%
    mkfs.fat -F32 ${EFI_PARTITION}
    mkfs.ext4 ${ROOT_PARTITION}
}

# Function to mount filesystems
mount_filesystems() {
    echo "Mounting filesystems..."
    mount ${ROOT_PARTITION} /mnt
    mkdir -p /mnt/boot/efi
    mount ${EFI_PARTITION} /mnt/boot/efi
}

# Function to copy root filesystem
copy_rootfs() {
    echo "Copying root filesystem..."
    cp -r ${ROOTFS_DIR}/* /mnt/
}

# Function to install bootloader
install_bootloader() {
    echo "Installing bootloader..."
    grub-install --target=x86_64-efi --efi-directory=/mnt/boot/efi --bootloader-id=my-linux-distro
    grub-mkconfig -o /mnt/boot/grub/grub.cfg
}

# Function to unmount filesystems
unmount_filesystems() {
    echo "Unmounting filesystems..."
    umount /mnt/boot/efi
    umount /mnt
}

# Main installation process
create_partitions
mount_filesystems
copy_rootfs
install_bootloader
unmount_filesystems

echo "Installation completed successfully!"