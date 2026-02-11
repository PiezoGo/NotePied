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
if [ ! -f "linuxdeployqt.AppImage" ]; then
    echo "Downloading linuxdeployqt..."
    wget -q https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage -O linuxdeployqt.AppImage
    chmod +x linuxdeployqt.AppImage
fi

# Prepare AppDir structure
echo "Preparing AppDir..."
mkdir -p AppDir/usr/share/applications
mkdir -p AppDir/usr/share/icons/hicolor/256x256/apps

# Copy desktop file
cp NotePied.desktop AppDir/usr/share/applications/

# Copy icon
if [ -f "note-pied.png" ]; then
    cp note-pied.png AppDir/usr/share/icons/hicolor/256x256/apps/notepied.png
    cp note-pied.png AppDir/NotePied.png
else
    echo "Warning: No icon found"
fi

# Make executable
chmod +x AppDir/usr/bin/NotePied

# STEP 1: Deploy Qt libraries (without creating AppImage)
echo "Step 1: Deploying Qt libraries..."
./linuxdeployqt.AppImage AppDir/usr/share/applications/NotePied.desktop \
    -unsupported-allow-new-glibc \
    -qmake=/usr/bin/qmake

# STEP 2: Create the AppImage
echo "Step 2: Creating AppImage..."
./linuxdeployqt.AppImage AppDir/usr/share/applications/NotePied.desktop \
    -appimage \
    -unsupported-allow-new-glibc \
    -qmake=/usr/bin/qmake

# Rename the AppImage
echo "Renaming AppImage..."
mv NotePied*.AppImage NotePied-x86_64.AppImage 2>/dev/null || true

echo ""
echo "=== BUILD SUCCESSFUL! ==="
echo "Your AppImage is ready: NotePied-x86_64.AppImage"
echo ""
echo "To test it:"
echo "  chmod +x NotePied-x86_64.AppImage"
echo "  ./NotePied-x86_64.AppImage"
ls -lh NotePied*.AppImage 2>/dev/null || echo "AppImage not found - check for errors above"
