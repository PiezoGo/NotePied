cmake_minimum_required(VERSION 3.10)
project(NotePied VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find Qt5
find_package(Qt5 COMPONENTS Core Gui Widgets REQUIRED)

# List EXACT files you have
set(SOURCES
    main.cpp
    mainwindow.cpp
)

set(HEADERS
    mainwindow.h
)

set(FORMS
    mainwindow.ui
)

set(RESOURCES
    resources.qrc
)

# Create executable
add_executable(NotePied ${SOURCES} ${HEADERS} ${FORMS} ${RESOURCES})

# Link Qt libraries
target_link_libraries(NotePied 
    Qt5::Core
    Qt5::Gui
    Qt5::Widgets
)

# Install for AppImage
install(TARGETS NotePied DESTINATION bin)
