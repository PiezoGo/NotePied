#!/bin/bash
set -e  # Exit on any error

echo "=== Building NotePied AppImage ==="

# Clean up previous builds
echo "Cleaning previous builds..."
rm -rf build AppDir NotePied*.AppImage

# Create build directory
mkdir build
cd build

# Configure with CMake
echo "Configuring with CMake..."
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr

# Build the project
echo "Building project..."
make -j$(nproc)

# Install to AppDir (for packaging)
echo "Installing to AppDir..."
make install DESTDIR=../AppDir

cd ..

echo "AppDir structure created successfully"

# Download linuxdeployqt if not present
if ! command -v linuxdeployqt &> /dev/null; then
    echo "Downloading linuxdeployqt..."
    wget -q https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage
    chmod +x linuxdeployqt-continuous-x86_64.AppImage
    sudo mv linuxdeployqt-continuous-x86_64.AppImage /usr/local/bin/linuxdeployqt
fi

# Prepare AppDir structure
echo "Preparing AppDir..."
mkdir -p AppDir/usr/share/applications
mkdir -p AppDir/usr/share/icons/hicolor/256x256/apps

# Copy desktop file
cp NotePied.desktop AppDir/usr/share/applications/

# Copy icon
if [ -f "assets/icon.png" ]; then
    cp assets/icon.png AppDir/usr/share/icons/hicolor/256x256/apps/notepied.png
else
    echo "Warning: No icon found at assets/icon.png"
    echo "Creating default icon..."
    mkdir -p assets
    wget -q -O assets/icon.png https://via.placeholder.com/256/4CAF50/FFFFFF?text=NP
    cp assets/icon.png AppDir/usr/share/icons/hicolor/256x256/apps/notepied.png
fi

# Make executable
chmod +x AppDir/usr/bin/NotePied

# Use linuxdeployqt to bundle Qt libraries
echo "Running linuxdeployqt to bundle Qt libraries..."
linuxdeployqt AppDir/usr/share/applications/NotePied.desktop -appimage

# The AppImage will have a long name, let's rename it
echo "Renaming AppImage..."
mv NotePied*.AppImage NotePied-x86_64.AppImage

echo ""
echo "=== BUILD SUCCESSFUL! ==="
echo "Your AppImage is ready: NotePied-x86_64.AppImage"
echo ""
echo "To test it:"
echo "  chmod +x NotePied-x86_64.AppImage"
echo "  ./NotePied-x86_64.AppImage"