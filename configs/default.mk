# Default makefile configurations for building the distribution

# Define the target architectures
TARGET_ARCHS := x86_64 arm64

# Set the default package manager
PACKAGE_MANAGER := apt

# Define the root filesystem directories
ROOTFS_DIRS := rootfs/minimal rootfs/desktop

# Specify the build output directory
BUILD_OUTPUT := build

# Define the default build target
.PHONY: all
all: $(TARGET_ARCHS)

# Build for x86_64 architecture
x86_64:
	@echo "Building for x86_64 architecture..."
	# Add build commands here

# Build for ARM architecture
arm64:
	@echo "Building for ARM architecture..."
	# Add build commands here

# Clean build artifacts
.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	# Add clean commands here

# Install packages
.PHONY: install
install:
	@echo "Installing packages using $(PACKAGE_MANAGER)..."
	# Add installation commands here