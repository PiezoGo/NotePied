#!/bin/bash
set -e

echo "=== Building NotePied AppImage with Qt5 ==="

# Clean
rm -rf AppDir NotePied*.AppImage

# Rebuild to ensure it's using Qt5
cd build
make -j$(nproc)
cd ..

# Create fresh AppDir
mkdir -p AppDir/usr/bin
mkdir -p AppDir/usr/share/applications
mkdir -p AppDir/usr/share/icons/hicolor/256x256/apps

# Copy files
cp build/NotePied AppDir/usr/bin/
cp NotePied.desktop AppDir/usr/share/applications/
cp note-pied.png AppDir/usr/share/icons/hicolor/256x256/apps/notepied.png 2>/dev/null || true

chmod +x AppDir/usr/bin/NotePied

# Create a proper AppRun script
cat > AppDir/AppRun << 'EOF2'
#!/bin/bash
HERE="$(dirname "$(readlink -f "$0")")"
export LD_LIBRARY_PATH="$HERE/usr/lib:$LD_LIBRARY_PATH"
export QT_PLUGIN_PATH="$HERE/usr/plugins"
export QML_IMPORT_PATH="$HERE/usr/qml"
export QML2_IMPORT_PATH="$HERE/usr/qml"
exec "$HERE/usr/bin/NotePied" "$@"
EOF2
chmod +x AppDir/AppRun

# Make sure we have linuxdeployqt
if [ ! -f "linuxdeployqt.AppImage" ]; then
    wget -q https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage -O linuxdeployqt.AppImage
    chmod +x linuxdeployqt.AppImage
fi

# Set Qt5 directory explicitly
export QMAKE=/usr/bin/qmake
export QT_PLUGIN_PATH=/usr/lib/x86_64-linux-gnu/qt5/plugins

echo "Using QMAKE: $(which qmake)"
echo "Using QT_PLUGIN_PATH: $QT_PLUGIN_PATH"

# First deploy libraries without creating AppImage
echo "Deploying Qt libraries..."
./linuxdeployqt.AppImage AppDir/usr/share/applications/NotePied.desktop \
    -unsupported-allow-new-glibc \
    -verbose=2 \
    -qmake=/usr/bin/qmake

echo "Creating AppImage..."
./linuxdeployqt.AppImage AppDir/usr/share/applications/NotePied.desktop \
    -appimage \
    -unsupported-allow-new-glibc \
    -qmake=/usr/bin/qmake

if ls NotePied*.AppImage 1> /dev/null 2>&1; then
    echo ""
    echo "=== SUCCESS! ==="
    echo "AppImage: $(ls NotePied*.AppImage)"
else
    echo ""
    echo "=== Trying alternative method with appimagetool ==="
    wget -q https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -O appimagetool.AppImage
    chmod +x appimagetool.AppImage
    ./appimagetool.AppImage AppDir
fi
