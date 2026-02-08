# NotePied

**NotePied** is a basic desktop note-taking tool with a modern Qt interface.  
Perfect for quick thoughts, lists, and plain-text editing.

- **Private & offline** — no cloud, no tracking
- **Lightweight** C++ + Qt application
- **Simple GUI** powered by Qt Designer (.ui file)

![NotePied Icon / Preview](note-pied.png)

## Current Status
- Personal / early-stage project
- Source code is public
- **No pre-built binaries or official releases** yet (check back later for AppImage, Windows .exe, etc.)
- Build from source is straightforward on Linux

**Topics:** c, cpp, qt, qtcreator, desktop-application

## Features (based on current implementation)
- Clean, minimal note-taking window
- Text editing capabilities (via Qt widgets)
- Embedded resources (icons, etc. via resources.qrc)
- Linux desktop integration support (via NotePied.desktop)

## Requirements (Linux)
- **CMake** ≥ 3.10
- **Qt 6** development packages (or Qt 5 – adjust as needed)
- C++ compiler (g++, clang++)
- git (to clone)

Tested conceptually on Ubuntu/Debian-style systems.

## How to Build and Run on Linux

1. **Install dependencies** (Ubuntu/Debian example)

   ```bash
   sudo apt update
   sudo apt install build-essential cmake qt6-base-dev qt6-tools-dev qt6-tools-dev-tools libqt6widgets6 libqt6core6 libqt6gui6```

2. **Clone the repository**
```git clone https://github.com/PiezoGo/NotePied.git
cd NotePied```


3. **Build the application**
```mkdir build && cd build
cmake ..
make -j$(nproc)```

This should produce an executable named something like NotePied (check with ls after building; look in CMakeLists.txt for the exact add_executable target name).

4. **Run it**
```./NotePied```

## Contributing

Contributions are welcome! You can:

- Open issues

- Send pull requests

- Add features or docs

Please follow good commit practices.