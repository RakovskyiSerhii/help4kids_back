#!/bin/bash

# Dart SDK Installation Script for AlmaLinux 10
# Alternative methods when snap is not available

set -e

echo "=========================================="
echo "Dart SDK Installation for AlmaLinux 10"
echo "=========================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root or with sudo${NC}"
    exit 1
fi

# Method 1: Install from Dart's official repository (Recommended)
install_from_repo() {
    echo -e "${GREEN}Installing Dart from official repository...${NC}"
    
    # Install prerequisites
    dnf install -y wget curl
    
    # Download and install Dart SDK
    DART_VERSION=$(curl -s https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION)
    DART_ARCH="x64"
    
    echo "Latest Dart version: $DART_VERSION"
    
    # Download Dart SDK
    cd /tmp
    wget "https://storage.googleapis.com/dart-archive/channels/stable/release/$DART_VERSION/sdk/dartsdk-linux-$DART_ARCH-release.zip"
    
    # Install unzip if not available
    dnf install -y unzip
    
    # Extract to /usr/lib
    unzip -q "dartsdk-linux-$DART_ARCH-release.zip" -d /usr/lib/
    
    # Create symlink
    ln -sf /usr/lib/dart-sdk/bin/dart /usr/local/bin/dart
    ln -sf /usr/lib/dart-sdk/bin/pub /usr/local/bin/pub
    
    # Add to PATH in profile
    if ! grep -q "DART_SDK" /etc/profile; then
        echo 'export DART_SDK=/usr/lib/dart-sdk' >> /etc/profile
        echo 'export PATH=$PATH:$DART_SDK/bin' >> /etc/profile
    fi
    
    # Cleanup
    rm -f "dartsdk-linux-$DART_ARCH-release.zip"
    
    echo -e "${GREEN}✓ Dart installed successfully${NC}"
}

# Method 2: Install snapd first, then Dart
install_snapd_then_dart() {
    echo -e "${GREEN}Installing snapd, then Dart...${NC}"
    
    # Install snapd
    dnf install -y snapd
    
    # Enable and start snapd
    systemctl enable --now snapd
    systemctl enable --now snapd.socket
    
    # Create symlink for snap
    ln -sf /var/lib/snapd/snap /snap
    
    # Wait a moment for snapd to be ready
    sleep 5
    
    # Install Dart via snap
    snap install dart --classic
    
    echo -e "${GREEN}✓ Dart installed via snap${NC}"
}

# Method 3: Manual download and setup
install_manual() {
    echo -e "${GREEN}Manual installation method...${NC}"
    
    DART_VERSION="3.6.0"  # Update to latest stable if needed
    DART_ARCH="x64"
    INSTALL_DIR="/opt/dart"
    
    dnf install -y wget unzip
    
    cd /tmp
    wget "https://storage.googleapis.com/dart-archive/channels/stable/release/$DART_VERSION/sdk/dartsdk-linux-$DART_ARCH-release.zip"
    
    mkdir -p "$INSTALL_DIR"
    unzip -q "dartsdk-linux-$DART_ARCH-release.zip" -d "$INSTALL_DIR"
    
    # Create symlinks
    ln -sf "$INSTALL_DIR/dart-sdk/bin/dart" /usr/local/bin/dart
    ln -sf "$INSTALL_DIR/dart-sdk/bin/pub" /usr/local/bin/pub
    
    # Add to PATH
    if ! grep -q "DART_SDK" /etc/profile; then
        echo "export DART_SDK=$INSTALL_DIR/dart-sdk" >> /etc/profile
        echo 'export PATH=$PATH:$DART_SDK/bin' >> /etc/profile
    fi
    
    rm -f "dartsdk-linux-$DART_ARCH-release.zip"
    
    echo -e "${GREEN}✓ Dart installed to $INSTALL_DIR${NC}"
}

# Main installation
echo "Select installation method:"
echo "1) Official repository (Recommended)"
echo "2) Install snapd first, then Dart"
echo "3) Manual installation to /opt/dart"
read -p "Enter choice [1-3]: " choice

case $choice in
    1)
        install_from_repo
        ;;
    2)
        install_snapd_then_dart
        ;;
    3)
        install_manual
        ;;
    *)
        echo -e "${RED}Invalid choice. Using method 1 (Official repository)${NC}"
        install_from_repo
        ;;
esac

# Verify installation
echo ""
echo "Verifying installation..."
export PATH=$PATH:/usr/lib/dart-sdk/bin:/opt/dart/dart-sdk/bin:/snap/bin
dart --version

echo ""
echo -e "${GREEN}=========================================="
echo "Installation Complete!"
echo "==========================================${NC}"
echo ""
echo "Dart version: $(dart --version)"
echo ""
echo -e "${YELLOW}Note: You may need to log out and back in, or run:${NC}"
echo "  source /etc/profile"
echo "  export PATH=\$PATH:/usr/lib/dart-sdk/bin"
echo ""


