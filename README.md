# My Linux Distro

Welcome to My Linux Distro, a versatile Linux distribution designed to run seamlessly on both PC (x86_64) and mobile devices (ARM). This project aims to provide a lightweight, user-friendly operating system that caters to a wide range of hardware.

## Features

- **Multi-Architecture Support**: Installable on both x86_64 and ARM architectures.
- **Minimal and Desktop Environments**: Choose between a lightweight installation or a full desktop experience.
- **Custom Installer Scripts**: Automated installation processes for UEFI and mobile devices.
- **Core and Extra Packages**: A curated selection of essential packages with the option to add more.

## Directory Structure

- **arch/**: Contains architecture-specific files.
  - **x86_64/**: Kernel, GRUB, and systemd units for x86_64.
  - **arm64/**: Kernel, U-Boot, and systemd units for ARM.
  
- **packages/**: Core and extra packages for the distribution.
  
- **rootfs/**: Root filesystem directories for minimal and desktop environments.
  
- **installer/**: Installation scripts for UEFI and mobile devices.
  
- **configs/**: Configuration files for system settings.
  
- **scripts/**: Utility scripts for building the root filesystem and images.
  
- **tooling/**: Tools for managing chroot environments and creating bootable images.
  
- **docs/**: Documentation outlining design principles and architecture.
  
- **tests/**: Testing configurations for QEMU virtual environments.

## Getting Started

1. Clone the repository:
   ```
   git clone <repository-url>
   cd my-linux-distro
   ```

2. Build the root filesystem:
   ```
   ./scripts/build-rootfs.sh
   ```

3. Create an installable image:
   ```
   ./scripts/build-image.sh
   ```

4. Follow the installation instructions in the respective installer directory.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue for any suggestions or improvements.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.