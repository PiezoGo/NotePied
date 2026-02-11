# NotePied

A modern, lightweight note-taking application for Linux.

## 📥 Download & Run (No Installation!)

1. Download `NotePied-x86_64.AppImage` from [Releases](https://github.com/PiezoGo/NotePied/releases)
2. `chmod +x NotePied-x86_64.AppImage`
3. `./NotePied-x86_64.AppImage`

**Linux only.** Windows/macOS versions coming later.

## Features
- Clean Qt5 interface
- Create, edit, save notes
- Portable AppImage - no dependencies!

## Build from Source
```bash
git clone https://github.com/PiezoGo/NotePied.git
cd NotePied
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
./NotePied