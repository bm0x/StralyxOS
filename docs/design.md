# Design Principles and Architecture of My Linux Distribution

## Overview
This document outlines the design principles and architecture of the My Linux Distribution project, which aims to provide a versatile and efficient operating system that can be installed on both x86_64 PC architectures and ARM mobile devices.

## Goals
- **Cross-Architecture Compatibility**: The distribution is designed to support both x86_64 and ARM architectures, ensuring a wide range of hardware compatibility.
- **Modularity**: The system is built in a modular fashion, allowing users to customize their installations with core and extra packages.
- **Lightweight and Efficient**: The minimal root filesystem is optimized for performance, making it suitable for both lightweight installations and resource-constrained environments.
- **User-Friendly Installation**: The installation scripts for both UEFI and mobile devices are designed to simplify the installation process for end-users.

## Architecture
### 1. Kernel
- **x86_64**: The kernel binaries and configuration files are located in `arch/x86_64/kernel`.
- **ARM**: The ARM kernel binaries and configuration files are found in `arch/arm64/kernel`.

### 2. Bootloaders
- **GRUB**: Configuration files for booting the x86_64 system are stored in `arch/x86_64/grub`.
- **U-Boot**: Boot files for ARM systems are located in `arch/arm64/u-boot`.

### 3. System Management
- **Systemd Units**: Systemd unit files for managing services are organized in `arch/x86_64/systemd-units` for x86_64 and `arch/arm64/systemd-units` for ARM.

### 4. Package Management
- **Core Packages**: The core packages are defined in `packages/core/package-list.yaml`, specifying versions and dependencies.
- **Extra Packages**: Additional packages can be included from the `packages/extra` directory.

### 5. Root Filesystem
- **Minimal**: The minimal root filesystem is located in `rootfs/minimal`, designed for lightweight installations.
- **Desktop Environment**: The desktop environment files are available in `rootfs/desktop`, providing a graphical user interface.

### 6. Installation Scripts
- **UEFI Installation**: The installation script for UEFI systems is found in `installer/uefi/install.sh`.
- **Mobile Installation**: The mobile installation script is located in `installer/mobile/install.sh`.

### 7. Configuration Files
- **Filesystem Table**: The filesystem table configuration is specified in `configs/fstab`.
- **Hostname**: The system hostname is defined in `configs/hostname`.
- **Makefile Configurations**: Default makefile configurations are stored in `configs/default.mk`.

### 8. Build and Image Creation
- **Root Filesystem Build**: The script to build the root filesystem is located in `scripts/build-rootfs.sh`.
- **Image Creation**: The script for creating an installable image is found in `scripts/build-image.sh`.
- **Image Signing**: The script to sign the generated image is located in `scripts/sign-image.sh`.

### 9. Testing
- **QEMU Testing**: Test scripts and configurations for running the distribution in a QEMU virtual environment are stored in `tests/qemu`.

## Conclusion
The My Linux Distribution project is designed with flexibility and efficiency in mind, catering to a diverse range of hardware while providing a user-friendly experience. The modular architecture allows for easy customization and scalability, making it suitable for both desktop and mobile environments.