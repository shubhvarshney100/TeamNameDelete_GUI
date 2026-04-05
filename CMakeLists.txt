cmake_minimum_required(VERSION 3.16)

project(SecureWipe LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find the required Qt modules.
# DEFINITIVE FIX: Added 'Widgets' and 'Pdf' to this list.
find_package(Qt6 REQUIRED COMPONENTS Quick Core Gui Widgets Pdf)

qt_add_executable(appSecureWipe
    main.cpp
    drivemanager.cpp
    drivemanager.h
    pdfgenerator.cpp
    pdfgenerator.h
    qml.qrc
)

# Tell our QML what our C++ backend is called
qt_add_qml_module(appSecureWipe
    URI com.securewipe.backend
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/LandingPage.qml
        qml/DriveSelectionPage.qml
        qml/WipeProgressPage.qml
        qml/CompletionPage.qml
        qml/CertificatesPage.qml
        RESOURCES .gitignore
)

# Link the required Qt libraries to our application
# DEFINITIVE FIX: Added Qt::Widgets and Qt::Pdf to link against.
target_link_libraries(appSecureWipe PRIVATE
    Qt::Quick
    Qt::Core
    Qt::Gui
    Qt::Widgets
    Qt::Pdf
)

