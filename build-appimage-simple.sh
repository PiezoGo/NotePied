#!/bin/bash
set -e

echo "=== Building NotePied AppImage ==="

# Clean
rm -rf AppDir NotePied*.AppImage

# Build the project first (ensure it's built)
cd build
make -j$(nproc)
cd ..

# Create AppDir structure
mkdir -p AppDir/usr/bin
mkdir -p AppDir/usr/share/applications
mkdir -p AppDir/usr/share/icons/hicolor/256x256/apps

# Copy executable
cp build/NotePied AppDir/usr/bin/

# Copy desktop file
cp NotePied.desktop AppDir/usr/share/applications/

# Copy icon
if [ -f "assets/icon.png" ]; then
    cp assets/icon.png AppDir/usr/share/icons/hicolor/256x256/apps/notepied.png
elif [ -f "note-pied.png" ]; then
    cp note-pied.png AppDir/usr/share/icons/hicolor/256x256/apps/notepied.png
else
    echo "Warning: No icon found. Creating default..."
    convert -size 256x256 xc:#4CAF50 -fill white -pointsize 72 \
            -gravity center -draw "text 0,0 'NP'" \
            AppDir/usr/share/icons/hicolor/256x256/apps/notepied.png 2>/dev/null || \
    echo "Created placeholder icon"
fi

# Make executable
chmod +x AppDir/usr/bin/NotePied

# Download linuxdeployqt if not present
if [ ! -f "linuxdeployqt.AppImage" ]; then
    echo "Downloading linuxdeployqt..."
    wget -q https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage -O linuxdeployqt.AppImage
    chmod +x linuxdeployqt.AppImage
fi

# Bundle Qt libraries
echo "Bundling Qt libraries..."
./linuxdeployqt.AppImage AppDir/usr/share/applications/NotePied.desktop -appimage

# Rename to simpler name
mv NotePied*.AppImage NotePied-Linux-x86_64.AppImage

echo ""
echo "=== SUCCESS! ==="
echo "AppImage created: NotePied-Linux-x86_64.AppImage"
echo ""
echo "To test:"
echo "  chmod +x NotePied-Linux-x86_64.AppImage"
echo "  ./NotePied-Linux-x86_64.AppImage"
